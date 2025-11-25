show-trace:
    uv run show_trace.py -c 'select count(*) from t_oos_ovf'

make-sql-t_oos_14000:
    ^uv run src/make_sql_bulk_insert.py -t t_oos_14000 -o t_oos_14000.sql -l 14000 -n 300000

load-t_oos_14000:
    cs -i t_oos_14000.sql --no-auto-commit
