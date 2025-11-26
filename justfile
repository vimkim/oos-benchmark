set shell := ["nu", "-c"]

mod cub '~/my-cubrid/stow/cubrid/justfile'

cubrid-server-refresh:
    do -i { cubrid service stop }
    do -i { cubrid server stop testdb }
    do -i { cubrid server start testdb }
    do -i { cubrid broker start }

show-trace:
    uv run show_trace.py -c 'select crount(*) from t_oos_ovf'

make-insert-sql-t_2500:
    ^uv run -- src/make_sql_bulk_insert.py -t t_2500 -o t_2500.sql -n 300000 -l 512 --num-char 1 --char-len 500

make-insert-sql-t_15500:
    ^uv run src/make_sql_bulk_insert.py -t t_15500 -o t_15500.sql -n 300000 -l 512 --num-char 2 --char-len 1875

make-insert-sql-t_16500:
    ^uv run src/make_sql_bulk_insert.py -t t_16500 -o t_16500.sql -n 300000 -l 16500 --num-char 0 --char-len 0

load-t_2500:
    cs --no-auto-commit -i t_2500.sql

load-t_15500:
    cs --no-auto-commit -i t_15500.sql

load-t_16500:
    cs --no-auto-commit -i t_16500.sql

run-benchmark-2500-id-develop-512M:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_2500" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '512.0M'

run-benchmark-2500-all-develop-512M:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_2500" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '512.0M'

run-benchmark-2500-id-develop-20G:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_2500" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '20.0G'

run-benchmark-2500-all-develop-20G:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_2500" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '20.0G'

run-benchmark-15500-id-develop-512M:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_15500" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '512.0M'

run-benchmark-15500-all-develop-512M:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_15500" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '512.0M'

run-benchmark-15500-id-develop-20G:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_15500" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '20.0G'

run-benchmark-15500-all-develop-20G:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_15500" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '20.0G'

run-benchmark-16500-id-develop-512M:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_16500" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '512.0M'

run-benchmark-16500-all-develop-512M:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_16500" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '512.0M'

run-benchmark-16500-id-develop-20G:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_16500" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '20.0G'

run-benchmark-16500-all-develop-20G:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_16500" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '20.0G'

run-benchmark-2500-id-oos-perf-512M:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_2500" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '512.0M'

run-benchmark-2500-all-oos-perf-512M:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_2500" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '512.0M'

run-benchmark-2500-id-oos-perf-20G:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_2500" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '20.0G'

run-benchmark-2500-all-oos-perf-20G:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_2500" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '20.0G'

run-benchmark-15500-id-oos-perf-512M:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_15500" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '512.0M'

run-benchmark-15500-all-oos-perf-512M:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_15500" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '512.0M'

run-benchmark-15500-id-oos-perf-20G:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_15500" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '20.0G'

run-benchmark-15500-all-oos-perf-20G:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_15500" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '20.0G'

run-benchmark-16500-id-oos-perf-512M:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_16500" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '512.0M'

run-benchmark-16500-all-oos-perf-512M:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_16500" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '512.0M'

run-benchmark-16500-id-oos-perf-20G:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_16500" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '20.0G'

run-benchmark-16500-all-oos-perf-20G:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_16500" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '20.0G'

run-benchmarks-develop-512M: cubrid-set-data-buffer-512M
    just run-benchmark-2500-id-develop-512M
    just run-benchmark-2500-all-develop-512M
    just run-benchmark-15500-id-develop-512M
    just run-benchmark-15500-all-develop-512M
    just run-benchmark-16500-id-develop-512M
    just run-benchmark-16500-all-develop-512M

run-benchmarks-develop-20G: cubrid-set-data-buffer-20G
    just run-benchmark-2500-id-develop-20G
    just run-benchmark-2500-all-develop-20G
    just run-benchmark-15500-id-develop-20G
    just run-benchmark-15500-all-develop-20G
    just run-benchmark-16500-id-develop-20G
    just run-benchmark-16500-all-develop-20G

run-benchmarks-oos-perf-512M: cubrid-set-data-buffer-512M
    just run-benchmark-2500-id-oos-perf-512M
    just run-benchmark-2500-all-oos-perf-512M
    just run-benchmark-15500-id-oos-perf-512M
    just run-benchmark-15500-all-oos-perf-512M
    just run-benchmark-16500-id-oos-perf-512M
    just run-benchmark-16500-all-oos-perf-512M

run-benchmarks-oos-perf-20G: cubrid-set-data-buffer-20G
    just run-benchmark-2500-id-oos-perf-20G
    just run-benchmark-2500-all-oos-perf-20G
    just run-benchmark-15500-id-oos-perf-20G
    just run-benchmark-15500-all-oos-perf-20G
    just run-benchmark-16500-id-oos-perf-20G
    just run-benchmark-16500-all-oos-perf-20G

cubrid-set-data-buffer-512M:
    crudini --set $"($env.CUBRID)/conf/cubrid.conf" 'common' data_buffer_size 512M
    cubrid server restart testdb

cubrid-set-data-buffer-20G:
    crudini --set $"($env.CUBRID)/conf/cubrid.conf" 'common' data_buffer_size 20G
    cubrid server restart testdb

cubrid-shutdown-and-prepare-broker:
    do -i { cubrid service stop }
    do -i { cubrid server stop testdb }
    cubrid broker start

run-benchmarks-oos-perf: cubrid-shutdown-and-prepare-broker
    just run-benchmarks-oos-perf-20G
    just run-benchmarks-oos-perf-512M

run-benchmarks-develop: cubrid-shutdown-and-prepare-broker
    just run-benchmarks-develop-20G
    just run-benchmarks-develop-512M

report-sqlite:
    open ./report-sqlite.sql | sqlite3 out/benchmarks.sqlite -box
