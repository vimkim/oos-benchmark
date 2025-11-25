#!/usr/bin/env python3
import argparse


def main():
    parser = argparse.ArgumentParser(
        description="Generate bulk INSERT SQL for CUBRID using RPAD."
    )
    parser.add_argument(
        "-t", "--table-name",
        required=True,
        help="Name of the target table (e.g. tbl)"
    )
    parser.add_argument(
        "-o", "--output",
        required=True,
        help="Output SQL file name"
    )
    parser.add_argument(
        "-l", "--length",
        type=int,
        required=True,
        help="Length of the 'A' string (for RPAD)"
    )
    parser.add_argument(
        "-n", "--nums",
        type=int,
        required=True,
        help="Number of rows to insert"
    )
    parser.add_argument(
        "--num-char"
        type=int,
        required=False,
        help="Number of 2k byte char columns to insert"
    )
    args = parser.parse_args()

    TABLE_NAME = args.table_name
    OUTPUT_FILE = args.output
    A_LEN = args.length
    NUM_CHAR = args.num_char if args.num_char else 0

    TOTAL_ROWS = args.nums
    ROWS_PER_INSERT = 100
    INSERTS_PER_COMMIT = 100   # 100 inserts * 100 rows = 10,000 rows per COMMIT

    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        # Table creation (adjust as needed)
        f.write(f"CREATE TABLE {TABLE_NAME} (id INT, txt VARCHAR);\n")
        f.write("COMMIT;\n\n")

        current_rows = []
        insert_count = 0

        for i in range(1, TOTAL_ROWS + 1):
            # Use RPAD to generate string of length A_LEN
            current_rows.append(f"({i}, RPAD('A', {A_LEN}, 'A'))")

            if len(current_rows) == ROWS_PER_INSERT:
                f.write(f"INSERT INTO {TABLE_NAME} (id, txt) VALUES\n")
                f.write(",\n".join(current_rows))
                f.write(";\n\n")

                current_rows.clear()
                insert_count += 1

                if insert_count % INSERTS_PER_COMMIT == 0:
                    f.write("COMMIT;\n\n")

        # Safety: handle remainder if TOTAL_ROWS is not multiple of ROWS_PER_INSERT
        if current_rows:
            f.write(f"INSERT INTO {TABLE_NAME} (id, txt) VALUES\n")
            f.write(",\n".join(current_rows))
            f.write(";\n\n")
            f.write("COMMIT;\n\n")


if __name__ == "__main__":
    main()
