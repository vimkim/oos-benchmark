show-trace:
    uv run show_trace.py -c 'select count(*) from t_oos_ovf'

make-sql-t_oos_14000_char_0:
    ^uv run src/make_sql_bulk_insert.py -t t_oos_14000_char_0 -o t_oos_14000_char_0.sql -l 14000 -n 300000 --num-char 0

make-sql-t_oos_14000_char_2:
    ^uv run src/make_sql_bulk_insert.py -t t_oos_14000_char_2 -o t_oos_14000_char_2.sql -l 14000 -n 300000 --num-char 2

load-t_oos_14000_char_0:
    cs -i t_oos_14000_char_0.sql --no-auto-commit

load-t_oos_14000_char_2:
    cs -i t_oos_14000_char_2.sql --no-auto-commit
