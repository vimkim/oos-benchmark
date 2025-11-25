set shell := ["nu", "-c"]

cubrid-server-refresh:
    cubrid service stop
    cubrid server stop testdb
    cubrid server start testdb
    cubrid broker start

show-trace:
    uv run show_trace.py -c 'select crount(*) from t_oos_ovf'

make-sql-t_oos_12000_char_0:
    ^uv run src/make_sql_bulk_insert.py -t t_oos_12000_char_0 -o t_oos_12000_char_0.sql -l 12000 -n 300000 --num-char 0 --char-len 500

make-sql-t_oos_12000_char_2:
    ^uv run src/make_sql_bulk_insert.py -t t_oos_12000_char_2 -o t_oos_12000_char_2.sql -l 12000 -n 300000 --num-char 2

make-insert-sql-t_2500:
    ^uv run -- src/make_sql_bulk_insert.py -t t_2500 -o t_2500.sql -n 300000 -l 512 --num-char 1 --char-len 500

make-insert-sql-t_15500:
    ^uv run src/make_sql_bulk_insert.py -t t_15500 -o t_15500.sql -n 300000 -l 512 --num-char 2 --char-len 1875

load-t_2500:
    cs --no-auto-commit -i t_2500.sql

load-t_15500:
    cs --no-auto-commit -i t_15500.sql

load-t_oos_12000_char_0:
    cs -i t_oos_12000_char_0.sql --no-auto-commit

load-t_oos_12000_char_2:
    cs -i t_oos_12000_char_2.sql --no-auto-commit

run-benchmark-2500-id:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_2500" --num-rows 300000 --times 3

run-benchmark-2500-all:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_2500" --num-rows 300000 --times 3

run-benchmark-15500-id:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_15500" --num-rows 300000 --times 3

run-benchmark-15500-all:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_15500" --num-rows 300000 --times 3

run-benchmarks:
    just run-benchmark-2500-id
    just run-benchmark-2500-all
    just run-benchmark-15500-id
    just run-benchmark-15500-all

report-develop-512:
    open ./report-sqlite.sql | sqlite3 out/develop-512/benchmarks.sqlite -box

report-develop-20000:
    open ./report-sqlite.sql | sqlite3 out/develop-20000/benchmarks.sqlite -box

report-oos-512:
    open ./report-sqlite.sql | sqlite3 out/oos-512/benchmarks.sqlite -box

report-oos-20000:
    open ./report-sqlite.sql | sqlite3 out/oos-20000/benchmarks.sqlite -box
