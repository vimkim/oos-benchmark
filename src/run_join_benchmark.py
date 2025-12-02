#!/usr/bin/env python3
import argparse

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
            {select_list}
        FROM
            {left_table} AS l
            {join_type} JOIN {right_table} AS r
                ON {join_condition}
        LIMIT
            {num_rows}
    ) t;
"""


def build_join_sql(
    select_list: str,
    left_table: str,
    right_table: str,
    join_condition: str,
    join_type: str,
    num_rows: int,
) -> str:
    return SQL_TEMPLATE_JOIN.format(
        select_list=select_list,
        left_table=left_table,
        right_table=right_table,
        join_condition=join_condition,
        join_type=join_type.upper(),
        num_rows=num_rows,
    )


def parse_args():
    parser = argparse.ArgumentParser(
        description="Run one JOIN trace benchmark and save result JSON"
    )
    parser.add_argument(
        "--conn-url", default="CUBRID:localhost:33000:testdb:::"
    )
    parser.add_argument("--user", default="dba")
    parser.add_argument("--password", default="")

    # JOIN-specific knobs
    parser.add_argument(
        "--select-list",
        required=True,
        help='SELECT list for inner query, e.g. "l.id, r.value"',
    )
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
    parser.add_argument(
        "--join-condition",
        required=True,
        help='JOIN condition, e.g. "l.id = r.id"',
    )
    parser.add_argument(
        "--join-type",
        default="INNER",
        help='JOIN type (INNER, LEFT, RIGHT, etc). Default: INNER',
    )

    parser.add_argument("--num-rows", type=int, default=300000)
    parser.add_argument("--times", type=int, default=1)

    parser.add_argument(
        "--db-path",
        default="out/join-benchmarks.sqlite",
        help="Path to SQLite DB file (default: out/join-benchmarks.sqlite)",
    )
    parser.add_argument("--cubrid-branch", required=True)
    parser.add_argument("--data-buffer-size", required=True)
    return parser.parse_args()


def sanitize_for_filename(s: str) -> str:
    import re

    return re.sub(r"[^0-9A-Za-z_.-]+", "_", s)


def main():
    args = parse_args()

    # Build JOIN SQL
    sql = build_join_sql(
        select_list=args.select_list,
        left_table=args.left_table_name,
        right_table=args.right_table_name,
        join_condition=args.join_condition,
        join_type=args.join_type,
        num_rows=args.num_rows,
    )

    # Ensure we are running against the intended CUBRID build + buffer size
    validate_cubrid_conf(args)

    # Initialize / migrate SQLite DB (reuses same schema as scan benchmark)
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

        result = {
            "test_no": i,
            "cubrid_branch": args.cubrid_branch,
            "data_buffer_size": args.data_buffer_size,
            # For compatibility with the existing SQLite schema:
            "col_names": args.select_list,
            "table_name": f"{args.left_table_name} {args.join_type} JOIN "
                          f"{args.right_table_name} ON {args.join_condition}",
            "num_rows": args.num_rows,
            "subquery_scan": subq,
            "user_level_total_time": int(elapsed * 1_000),  # milliseconds
        }

        # JSON output
        filename = (
            f"{args.cubrid_branch}_{args.data_buffer_size}_join_"
            f"{left}_{join_type}_{right}_{join_key}_{args.num_rows}_testno_{i}.json"
        )
        save_result(result, filename)

        # SQL text output
        sql_filename = (
            f"{args.cubrid_branch}_{args.data_buffer_size}_join_"
            f"{left}_{join_type}_{right}_{join_key}_{args.num_rows}_testno_{i}.sql"
        )
        save_sql(sql, sql_filename)

        # SQLite row
        save_result_db(db_conn, result)

    db_conn.close()


if __name__ == "__main__":
    main()

