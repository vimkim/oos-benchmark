#!/usr/bin/env python3
import argparse
import re

from run_benchmark import (
    run_trace_for_query,
    extract_subquery_scan,
    init_db,
    save_result_db,
    save_result,
    save_sql,
    validate_cubrid_conf,
)

SQL_TEMPLATE_JOIN = """
SELECT
    /*+ NO_MERGE RECOMPILE NO_PARALLEL_HEAP_SCAN PARALLEL(0) */
    count(*)
FROM
    (
        SELECT
            /*+ NO_MERGE RECOMPILE NO_PARALLEL_HEAP_SCAN PARALLEL(0) */
            l.id
        FROM
            (
                SELECT
                    /*+ NO_MERGE RECOMPILE NO_PARALLEL_HEAP_SCAN PARALLEL(0) */
                    id 
                FROM
                    {left_table}
                LIMIT
                    {left_limit}
            ) AS l
            {join_type} JOIN (
                SELECT
                    /*+ NO_MERGE RECOMPILE NO_PARALLEL_HEAP_SCAN PARALLEL(0) */
                    id 
                FROM
                    {right_table}
                LIMIT
                    {right_limit}
            ) AS r ON {join_condition}
    ) AS t;
"""


def build_join_sql(
    left_table: str,
    right_table: str,
    left_limit: int,
    right_limit: int,
    join_condition: str,
    join_type: str,
) -> str:
    return SQL_TEMPLATE_JOIN.format(
        left_table=left_table,
        right_table=right_table,
        left_limit=left_limit,
        right_limit=right_limit,
        join_condition=join_condition,
        join_type=join_type.upper(),
    )


def parse_args():
    parser = argparse.ArgumentParser(
        description="Run one JOIN trace benchmark (subselect LIMIT + JOIN) and save result JSON"
    )
    parser.add_argument(
        "--conn-url", default="CUBRID:localhost:33000:testdb:::"
    )
    parser.add_argument("--user", default="dba")
    parser.add_argument("--password", default="")

    # left / right tables
    parser.add_argument(
        "--left-table-name",
        required=True,
        help="Left table name in the JOIN",
    )
    parser.add_argument(
        "--right-table-name",
        required=True,
        help="Right table name in the JOIN",
    )

    # inner SELECT limits
    parser.add_argument(
        "--left-limit",
        type=int,
        default=10,
        help="LIMIT for inner SELECT on left table (default: 10)",
    )
    parser.add_argument(
        "--right-limit",
        type=int,
        default=10,
        help="LIMIT for inner SELECT on right table (default: 10)",
    )

    parser.add_argument(
        "--join-condition",
        default="l.id = r.id",
        help='JOIN condition, e.g. "l.id = r.id" (default: l.id = r.id)',
    )
    parser.add_argument(
        "--join-type",
        default="INNER",
        help='JOIN type (INNER, LEFT, RIGHT, etc). Default: INNER',
    )

    parser.add_argument(
        "--times",
        type=int,
        default=1,
        help="Number of repetitions",
    )

    parser.add_argument(
        "--db-path",
        default="out/join-benchmarks.sqlite",
        help="Path to SQLite DB file (default: out/join-benchmarks.sqlite)",
    )
    parser.add_argument("--cubrid-branch", required=True)
    parser.add_argument("--data-buffer-size", required=True)
    return parser.parse_args()


def sanitize_for_filename(s: str) -> str:
    return re.sub(r"[^0-9A-Za-z_.-]+", "_", s)


def main():
    args = parse_args()

    sql = build_join_sql(
        left_table=args.left_table_name,
        right_table=args.right_table_name,
        left_limit=args.left_limit,
        right_limit=args.right_limit,
        join_condition=args.join_condition,
        join_type=args.join_type,
    )

    # Validate CUBRID env + data_buffer_size
    validate_cubrid_conf(args)

    # Reuse same SQLite schema as the scan benchmark
    db_conn = init_db(args.db_path)

    left = sanitize_for_filename(args.left_table_name)
    right = sanitize_for_filename(args.right_table_name)
    join_type = sanitize_for_filename(args.join_type)
    join_key = sanitize_for_filename(args.join_condition)

    for i in range(args.times):
        trace_data, elapsed = run_trace_for_query(
            args.conn_url, args.user, args.password, sql
        )

        subq = extract_subquery_scan(trace_data)

        # num_rows: record what we limited to on the left side
        result = {
            "test_no": i,
            "cubrid_branch": args.cubrid_branch,
            "data_buffer_size": args.data_buffer_size,
            "col_names": "l.id",  # middle SELECT projection
            "table_name": (
                f"JOIN(LEFT={args.left_table_name},RIGHT={args.right_table_name},"
                f"TYPE={args.join_type},COND={args.join_condition},"
                f"LIMIT_L={args.left_limit},LIMIT_R={args.right_limit})"
            ),
            "num_rows": args.left_limit,
            "subquery_scan": subq,
            "user_level_total_time": int(elapsed * 1_000),  # ms
        }

        filename = (
            f"{args.cubrid_branch}_{args.data_buffer_size}_join_"
            f"{left}_{join_type}_{right}_{join_key}_"
            f"L{args.left_limit}_R{args.right_limit}_testno_{i}.json"
        )
        save_result(result, filename)

        sql_filename = (
            f"{args.cubrid_branch}_{args.data_buffer_size}_join_"
            f"{left}_{join_type}_{right}_{join_key}_"
            f"L{args.left_limit}_R{args.right_limit}_testno_{i}.sql"
        )
        save_sql(sql, sql_filename)

        save_result_db(db_conn, result)

    db_conn.close()


if __name__ == "__main__":
    main()
