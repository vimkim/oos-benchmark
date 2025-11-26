#!/usr/bin/env python3
import argparse
import json
import sys
import os
import sqlite3
from datetime import datetime, UTC
import subprocess
import re
import time

import CUBRIDdb


SQL_TEMPLATE = """
SELECT
    /*+ NO_MERGE RECOMPILE NO_PARALLEL_HEAP_SCAN PARALLEL(0) */
    count(*)
FROM
    (
        SELECT
            /*+ NO_MERGE RECOMPILE NO_PARALLEL_HEAP_SCAN PARALLEL(0) */
            {col_names}
        FROM
            {table_name}
        LIMIT
            {num_rows}
    );
"""


def build_sql(col_names: str, table_name: str, num_rows: int) -> str:
    return SQL_TEMPLATE.format(
        col_names=col_names,
        table_name=table_name,
        num_rows=num_rows,
    )


def extract_subquery_scan(trace: dict) -> dict:
    try:
        return trace["Trace Statistics"]["SELECT"]["SUBQUERY (uncorrelated)"][0]["SELECT"]["SCAN"]
    except Exception:
        return {"error": "SCAN information not found in trace JSON"}


def run_trace_for_query(conn_url: str, user: str, password: str, sql: str):
    conn = CUBRIDdb.connect(conn_url, user, password)
    try:
        cur = conn.cursor()

        cur.execute("set trace on output json;")

        cur.execute(sql)
        cur.fetchall()

        # time benchmark of the next line
        start = time.perf_counter()
        cur.execute(sql)
        elapsed = time.perf_counter() - start
        cur.fetchall()

        cur.execute("show trace")
        rows = cur.fetchall()
        if not rows:
            raise RuntimeError("No trace data returned")

        trace_json = rows[0][0]
        return (json.loads(trace_json), elapsed)

    finally:
        conn.close()


def save_result(output_json: dict, filename: str):
    os.makedirs("out", exist_ok=True)
    path = os.path.join("out", filename)
    with open(path, "w") as f:
        json.dump(output_json, f, indent=2)
    print(f"Saved: {path}")


def parse_args():
    parser = argparse.ArgumentParser(
        description="Run one trace benchmark and save result JSON")
    parser.add_argument(
        "--conn-url", default="CUBRID:localhost:33000:testdb:::")
    parser.add_argument("--user", default="dba")
    parser.add_argument("--password", default="")
    parser.add_argument("--col-names", required=True)
    parser.add_argument("--table-name", required=True)
    parser.add_argument("--num-rows", type=int, default=300000)
    parser.add_argument("--times", type=int, default=1)
    parser.add_argument(
        "--db-path",
        default="out/benchmarks.sqlite",
        help="Path to SQLite DB file (default: out/benchmarks.sqlite)",
    )
    parser.add_argument("--cubrid-branch", required=True)
    parser.add_argument("--data-buffer-size", required=True)
    return parser.parse_args()


def init_db(db_path: str):
    os.makedirs(os.path.dirname(db_path), exist_ok=True)
    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    cur.execute(
        """
        CREATE TABLE IF NOT EXISTS benchmarks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cubrid_branch TEXT NOT NULL,
            data_buffer_size INTEGER NOT NULL,
            ts TEXT NOT NULL,
            test_no INTEGER NOT NULL,
            col_names TEXT NOT NULL,
            table_name TEXT NOT NULL,
            num_rows INTEGER NOT NULL,

            user_level_total_time INTEGER NOT NULL,
            access TEXT,
            heap_time INTEGER,
            heap_fetch INTEGER,
            heap_ioread INTEGER,
            heap_readrows INTEGER,
            heap_rows INTEGER,

            UNIQUE(test_no, col_names, table_name, num_rows, cubrid_branch, data_buffer_size)
        )
        """
    )

    conn.commit()
    return conn


def save_result_db(conn: sqlite3.Connection, result: dict):
    cur = conn.cursor()

    subq = result.get("subquery_scan", {})
    heap = subq.get("heap", {})

    cur.execute(
        """
        INSERT OR REPLACE INTO benchmarks (
            ts,
            test_no,
            cubrid_branch,
            data_buffer_size,
            col_names,
            table_name,
            num_rows,
            user_level_total_time,
            access,
            heap_time,
            heap_fetch,
            heap_ioread,
            heap_readrows,
            heap_rows
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        (
            datetime.now(UTC).isoformat(timespec="seconds"),
            result["test_no"],
            result["cubrid_branch"],
            result["data_buffer_size"],
            result["col_names"],
            result["table_name"],
            result["num_rows"],
            result["user_level_total_time"],
            subq.get("access"),
            heap.get("time"),
            heap.get("fetch"),
            heap.get("ioread"),
            heap.get("readrows"),
            heap.get("rows"),
        ),
    )

    conn.commit()


def validate_cubrid_conf(args):
    # 1. Check that CUBRID env var contains args.cubrid_branch
    cubrid_env = os.environ.get("CUBRID")
    if not cubrid_env:
        raise RuntimeError("CUBRID environment variable is not set")

    if args.cubrid_branch not in cubrid_env:
        raise ValueError(
            f"CUBRID env var '{cubrid_env}' does not contain branch '{args.cubrid_branch}'"
        )

    # 2. Check that `cubrid paramdump` contains expected data_buffer_size
    try:
        result = subprocess.run(
            ["cubrid", "paramdump", "testdb"],
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
    except FileNotFoundError:
        raise RuntimeError("cubrid binary not found in PATH")
    except subprocess.CalledProcessError as e:
        raise RuntimeError(f"cubrid paramdump failed: {e.stderr}") from e

    output = result.stdout

    # Get only the line containing data_buffer_size
    line = next(
        (l for l in output.splitlines() if "data_buffer_size" in l),
        None
    )

    if not line:
        raise ValueError("data_buffer_size not found in paramdump output")

# Extract the value (20.0G)
    match = re.search(r"data_buffer_size\s*=\s*([^\s()]+)", line)
    if not match:
        raise ValueError("Failed to parse data_buffer_size value")

    actual_value = match.group(1)   # "20.0G"

    if actual_value != str(args.data_buffer_size):
        raise ValueError(
            f"data_buffer_size mismatch: expected {args.data_buffer_size}, got {actual_value}"
        )


def main():
    args = parse_args()
    sql = build_sql(args.col_names, args.table_name, args.num_rows)

    validate_cubrid_conf(args)

    # init sqlite db once
    db_conn = init_db(args.db_path)

    for i in range(args.times):
        
        trace_data, elapsed = run_trace_for_query(
            args.conn_url, args.user, args.password, sql)

        subq = extract_subquery_scan(trace_data)

        result = {
            "test_no": i,
            "cubrid_branch": args.cubrid_branch,
            "data_buffer_size": args.data_buffer_size,
            "col_names": args.col_names,
            "table_name": args.table_name,
            "num_rows": args.num_rows,
            "subquery_scan": subq,
            "user_level_total_time": int(elapsed * 1_000) # millisecond
        }

        filename = f"{args.cubrid_branch}_{args.data_buffer_size}_{args.table_name}_{args.col_names}_{args.num_rows}_testno_{i}.json"
        save_result(result, filename)

        # SQLite row
        save_result_db(db_conn, result)

    db_conn.close()


if __name__ == "__main__":
    main()
