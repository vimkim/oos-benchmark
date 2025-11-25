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
        "--num-char",
        type=int,
        required=False,
        help="Number of 2k byte CHAR columns (c1..cN) to insert"
    )
    parser.add_argument(
        "--char-len"
        type=int,
        required=True,
        help="Length of each CHAR(n) column"
    )
    args = parser.parse_args()

    TABLE_NAME = args.table_name
    OUTPUT_FILE = args.output
    NUM_CHAR = args.num_char if args.num_char else 0
    CHAR_LENGTH = args.char_len
    CUBRID_CHAR_SIZE = 4
    A_LEN = args.length - (CHAR_LENGTH * NUM_CHAR * CUBRID_CHAR_SIZE)

    TOTAL_ROWS = args.nums
    ROWS_PER_INSERT = 100
    INSERTS_PER_COMMIT = 100   # 100 inserts * 100 rows = 10,000 rows per COMMIT

    # Precompute column definitions and lists
    base_columns = ["id", "txt"]
    char_columns = [f"c{i + 1}" for i in range(NUM_CHAR)]
    all_columns = base_columns + char_columns
    column_list_sql = ", ".join(all_columns)

    # For CREATE TABLE
    if NUM_CHAR > 0:
        char_defs = ", ".join(
            f"{col} CHAR({CHAR_LENGTH})" for col in char_columns)
        table_def = f"(id INT, txt VARCHAR, {char_defs})"
    else:
        table_def = "(id INT, txt VARCHAR)"

    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        # Table creation
        f.write(f"CREATE TABLE {TABLE_NAME} {table_def};\n")
        f.write("COMMIT;\n\n")

        current_rows = []
        insert_count = 0

        for i in range(1, TOTAL_ROWS + 1):
            # id and txt
            values = [
                str(i),
                f"RPAD('A', {A_LEN}, 'A')",
            ]

            # c1..cN as CHAR({CHAR_LENGTH}) filled with 'B', 'C', 'D', ...
            for j in range(NUM_CHAR):
                letter_ord = ord('B') + j
                if letter_ord > ord('Z'):
                    letter = 'Z'
                else:
                    letter = chr(letter_ord)
                values.append(f"RPAD('{letter}', {CHAR_LENGTH}, '{letter}')")

            row_sql = "(" + ", ".join(values) + ")"
            current_rows.append(row_sql)

            if len(current_rows) == ROWS_PER_INSERT:
                f.write(
                    f"INSERT INTO {TABLE_NAME} ({column_list_sql}) VALUES\n")
                f.write(",\n".join(current_rows))
                f.write(";\n\n")

                current_rows.clear()
                insert_count += 1

                if insert_count % INSERTS_PER_COMMIT == 0:
                    f.write("COMMIT;\n\n")

        # Handle remainder if TOTAL_ROWS is not a multiple of ROWS_PER_INSERT
        if current_rows:
            f.write(f"INSERT INTO {TABLE_NAME} ({column_list_sql}) VALUES\n")
            f.write(",\n".join(current_rows))
            f.write(";\n\n")
            f.write("COMMIT;\n\n")


if __name__ == "__main__":
    main()
