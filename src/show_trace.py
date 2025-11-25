#!/usr/bin/env python3
import argparse
import json
import sys

import CUBRIDdb


def run_query(sql: str):
    # Adjust connection parameters as needed
    conn = CUBRIDdb.connect(
        'CUBRID:localhost:33000:testdb:::',  # conn_url
        'dba',                               # user
        ''                                   # password
    )

    try:
        cur = conn.cursor()

        # Enable trace output in JSON
        cur.execute("set trace on output json;")

        # Execute user command
        cur.execute(sql)

        # Optionally fetch and print result rows
        rows = cur.fetchall()
        for row in rows:
            sys.stderr.write(str(row))

        # Show trace
        cur.execute("show trace")
        trace_rows = cur.fetchall()

        if not trace_rows:
            print("No trace data returned.", file=sys.stderr)
            return 1

        # The first column of the first row contains the JSON trace text
        trace_json = trace_rows[0][0]

        try:
            data = json.loads(trace_json)
        except json.JSONDecodeError as e:
            print("Failed to decode trace JSON:", e, file=sys.stderr)
            print(trace_json)
            return 1

        print(json.dumps(data, indent=2))
        return 0

    finally:
        conn.close()


def main():
    parser = argparse.ArgumentParser(
        description="Execute a CUBRID SQL command and print its trace in JSON."
    )
    parser.add_argument(
        "-c", "--command",
        required=True,
        help="SQL command to execute (e.g. \"select count(*) from t_oos_ovf\")"
    )

    args = parser.parse_args()
    sql = args.command

    # Very simple guard; you can relax this if you want non-SELECT statements
    if not sql.strip().lower().startswith("select"):
        print("Only SELECT statements are allowed for this CLI.", file=sys.stderr)
        sys.exit(1)

    rc = run_query(sql)
    sys.exit(rc)


if __name__ == "__main__":
    main()
