#!/usr/bin/env python3
import CUBRIDdb

def main():
    conn = CUBRIDdb.connect(
        'CUBRID:localhost:33000:testdb:::',  # adjust if needed
        'dba',
        ''
    )
    try:
        cur = conn.cursor()

        # Drop if exists (optional)
        try:
            cur.execute("drop table t_oos_heap_2000_13000")
            pass
        except Exception:
            pass

        # Create table
        cur.execute("""
            create table t_oos_heap_2000_13000 (
                id int,
                ch char(2000),
                txt varchar(13000)
            )
        """)

        # Data for insertion
        ch_value = "a" * 2000
        txt_value = "b" * 13000

        # Insert 10 rows
        for i in range(1, 110000):
            cur.execute(
                "insert into t_oos_heap_2000_13000(id,ch,txt) values(?,?,?)",
                (i, ch_value, txt_value)
            )

            if i % 1000 == 0:
                print(f"Inserted {i} rows...")
                conn.commit()



        conn.commit()
        print("Done inserting 10 rows into t_oos_heap_2000_13000")

    finally:
        conn.close()


if __name__ == "__main__":
    main()

