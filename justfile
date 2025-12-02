set shell := ["nu", "-c"]

mod cub '~/my-cubrid/stow/cubrid/justfile'
mod join './join.just'

cubrid-server-refresh:
    do -i { cubrid service stop }
    do -i { cubrid server stop testdb }
    do -i { cubrid server start testdb }
    do -i { cubrid broker start }

show-trace:
    uv run show_trace.py -c 'select crount(*) from t_oos_ovf'

make-insert-sql-t_2500:
    ^uv run -- src/make_sql_bulk_insert.py -t t_2500 -o t_2500.sql -n 300000 -l 512 --num-char 1 --char-len 500

make-insert-sql-t_8000:
    ^uv run -- src/make_sql_bulk_insert.py -t t_8000 -o t_8000.sql -n 300000 -l 512 --num-char 1 --char-len 1746

make-insert-sql-t_15500:
    ^uv run src/make_sql_bulk_insert.py -t t_15500 -o t_15500.sql -n 300000 -l 512 --num-char 2 --char-len 1875

make-insert-sql-t_16500:
    ^uv run src/make_sql_bulk_insert.py -t t_16500 -o t_16500.sql -n 300000 -l 16500 --num-char 0 --char-len 0

make-insert-sql-t_oos_8000:
    ^uv run src/make_sql_bulk_insert.py -t t_oos_8000 -o t_oos_8000.sql -n 300000 -l 512 --num-char 0 --char-len 0 --num-varchar=10

make-insert-sql-t_oos_vc20:
    ^uv run src/make_sql_bulk_insert.py -t t_oos_vc20 -o t_oos_vc20.sql -n 300000 -l 512 --num-char 0 --char-len 0 --num-varchar=20

load-t_2500:
    cs --no-auto-commit -i t_2500.sql

load-t_8000:
    cs --no-auto-commit -i t_8000.sql

load-t_15500:
    cs --no-auto-commit -i t_15500.sql

load-t_16500:
    cs --no-auto-commit -i t_16500.sql

load-t_oos_8000:
    cs --no-auto-commit -i t_oos_8000.sql

load-t_oos_vc20:
    cs --no-auto-commit -i t_oos_vc20.sql

run-benchmark-oos_vc20-id-oos-perf-512M:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_oos_vc20" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '512.0M'

run-benchmark-oos_vc20-all-oos-perf-512M:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_oos_vc20" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '512.0M'

run-benchmark-oos_vc20-id-oos-perf-20G:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_oos_vc20" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '20.0G'

run-benchmark-oos_vc20-all-oos-perf-20G:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_oos_vc20" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '20.0G'

run-benchmark-oos_vc20-id-develop-512M:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_oos_vc20" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '512.0M'

run-benchmark-oos_vc20-all-develop-512M:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_oos_vc20" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '512.0M'

run-benchmark-oos_vc20-id-develop-20G:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_oos_vc20" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '20.0G'

run-benchmark-oos_vc20-all-develop-20G:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_oos_vc20" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '20.0G'

run-benchmark-oos_8000-id-develop-512M:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_oos_8000" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '512.0M'

run-benchmark-oos_8000-all-develop-512M:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_oos_8000" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '512.0M'

run-benchmark-oos_8000-id-develop-20G:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_oos_8000" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '20.0G'

run-benchmark-oos_8000-all-develop-20G:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_oos_8000" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '20.0G'

run-benchmark-2500-id-develop-512M:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_2500" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '512.0M'

run-benchmark-2500-all-develop-512M:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_2500" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '512.0M'

run-benchmark-2500-id-develop-20G:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_2500" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '20.0G'

run-benchmark-2500-all-develop-20G:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_2500" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '20.0G'

run-benchmark-8000-id-develop-512M:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_8000" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '512.0M'

run-benchmark-8000-all-develop-512M:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_8000" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '512.0M'

run-benchmark-8000-id-develop-20G:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_8000" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '20.0G'

run-benchmark-8000-all-develop-20G:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_8000" --num-rows 300000 --times 3 --cubrid-branch 'develop' --data-buffer-size '20.0G'

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

run-benchmark-oos_8000-id-oos-perf-512M:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_oos_8000" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '512.0M'

run-benchmark-oos_8000-all-oos-perf-512M:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_oos_8000" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '512.0M'

run-benchmark-oos_8000-id-oos-perf-20G:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_oos_8000" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '20.0G'

run-benchmark-oos_8000-all-oos-perf-20G:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_oos_8000" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '20.0G'

run-benchmark-2500-id-oos-perf-512M:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_2500" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '512.0M'

run-benchmark-2500-all-oos-perf-512M:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_2500" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '512.0M'

run-benchmark-2500-id-oos-perf-20G:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_2500" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '20.0G'

run-benchmark-2500-all-oos-perf-20G:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_2500" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '20.0G'

run-benchmark-8000-id-oos-perf-512M:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_8000" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '512.0M'

run-benchmark-8000-all-oos-perf-512M:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_8000" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '512.0M'

run-benchmark-8000-id-oos-perf-20G:
    ^uv run src/run_benchmark.py --col-names "id" --table-name "t_8000" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '20.0G'

run-benchmark-8000-all-oos-perf-20G:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_8000" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '20.0G'

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

run-benchmark-16500-all-oos-perf-40G:
    ^uv run src/run_benchmark.py --col-names "*" --table-name "t_16500" --num-rows 300000 --times 3 --cubrid-branch 'oos-perf' --data-buffer-size '40.0G'

run-benchmarks-oos_vc20:
    just change-mode-develop
    just run-benchmarks-oos_vc20-develop
    just change-mode-oos-perf
    just run-benchmarks-oos_vc20-oos-perf

run-benchmarks-oos_vc20-develop: cubrid-shutdown-and-prepare-broker
    just run-benchmarks-oos_vc20-develop-20G
    just run-benchmarks-oos_vc20-develop-512M

run-benchmarks-oos_vc20-oos-perf: cubrid-shutdown-and-prepare-broker
    just run-benchmarks-oos_vc20-oos-perf-20G
    just run-benchmarks-oos_vc20-oos-perf-512M

run-benchmarks-oos_vc20-develop-512M: cubrid-set-data-buffer-512M
    just run-benchmark-oos_vc20-id-develop-512M
    just run-benchmark-oos_vc20-all-develop-512M

run-benchmarks-oos_vc20-develop-20G: cubrid-set-data-buffer-20G
    just run-benchmark-oos_vc20-id-develop-20G
    just run-benchmark-oos_vc20-all-develop-20G

run-benchmarks-oos_vc20-oos-perf-512M: cubrid-set-data-buffer-512M
    just run-benchmark-oos_vc20-id-oos-perf-512M
    just run-benchmark-oos_vc20-all-oos-perf-512M

run-benchmarks-oos_vc20-oos-perf-20G: cubrid-set-data-buffer-20G
    just run-benchmark-oos_vc20-id-oos-perf-20G
    just run-benchmark-oos_vc20-all-oos-perf-20G

run-benchmarks-oos_8000-develop-512M: cubrid-set-data-buffer-512M
    just run-benchmark-oos_8000-id-develop-512M
    just run-benchmark-oos_8000-all-develop-512M

run-benchmarks-oos_8000-develop-20G: cubrid-set-data-buffer-20G
    just run-benchmark-oos_8000-id-develop-20G
    just run-benchmark-oos_8000-all-develop-20G

run-benchmarks-oos_8000-oos-perf-512M: cubrid-set-data-buffer-512M
    just run-benchmark-oos_8000-id-oos-perf-512M
    just run-benchmark-oos_8000-all-oos-perf-512M

run-benchmarks-oos_8000-oos-perf-20G: cubrid-set-data-buffer-20G
    just run-benchmark-oos_8000-id-oos-perf-20G
    just run-benchmark-oos_8000-all-oos-perf-20G

run-benchmarks-8000-develop-512M: cubrid-set-data-buffer-512M
    just run-benchmark-8000-id-develop-512M
    just run-benchmark-8000-all-develop-512M

run-benchmarks-8000-develop-20G: cubrid-set-data-buffer-20G
    just run-benchmark-8000-id-develop-20G
    just run-benchmark-8000-all-develop-20G

run-benchmarks-8000-oos-perf-512M: cubrid-set-data-buffer-512M
    just run-benchmark-8000-id-oos-perf-512M
    just run-benchmark-8000-all-oos-perf-512M

run-benchmarks-8000-oos-perf-20G: cubrid-set-data-buffer-20G
    just run-benchmark-8000-id-oos-perf-20G
    just run-benchmark-8000-all-oos-perf-20G

run-benchmarks-develop-512M: cubrid-set-data-buffer-512M
    just run-benchmark-2500-id-develop-512M
    just run-benchmark-2500-all-develop-512M
    just run-benchmark-8000-id-develop-512M
    just run-benchmark-8000-all-develop-512M
    just run-benchmark-15500-id-develop-512M
    just run-benchmark-15500-all-develop-512M
    just run-benchmark-16500-id-develop-512M
    just run-benchmark-16500-all-develop-512M

run-benchmarks-develop-20G: cubrid-set-data-buffer-20G
    just run-benchmark-2500-id-develop-20G
    just run-benchmark-2500-all-develop-20G
    just run-benchmark-8000-id-develop-20G
    just run-benchmark-8000-all-develop-20G
    just run-benchmark-15500-id-develop-20G
    just run-benchmark-15500-all-develop-20G
    just run-benchmark-16500-id-develop-20G
    just run-benchmark-16500-all-develop-20G

run-benchmarks-oos-perf-512M: cubrid-set-data-buffer-512M
    just run-benchmark-2500-id-oos-perf-512M
    just run-benchmark-2500-all-oos-perf-512M
    just run-benchmark-8000-id-oos-perf-512M
    just run-benchmark-8000-all-oos-perf-512M
    just run-benchmark-15500-id-oos-perf-512M
    just run-benchmark-15500-all-oos-perf-512M
    just run-benchmark-16500-id-oos-perf-512M
    just run-benchmark-16500-all-oos-perf-512M

run-benchmarks-oos-perf-20G: cubrid-set-data-buffer-20G
    just run-benchmark-2500-id-oos-perf-20G
    just run-benchmark-2500-all-oos-perf-20G
    just run-benchmark-8000-id-oos-perf-20G
    just run-benchmark-8000-all-oos-perf-20G
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

cubrid-set-data-buffer-40G:
    crudini --set $"($env.CUBRID)/conf/cubrid.conf" 'common' data_buffer_size 40G
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
    open ./report-sqlite.sql | sqlite3 out/benchmarks.sqlite -box | awk -f color-table.awk

change-mode-develop:
    do -i { cubrid service stop }
    ^echo 'PRESET_MODE=release_gcc' | save -f .env
    ^echo 'SOURCE_DIR=/home/vimkim/gh/cb/develop' | save --append .env

change-mode-oos-perf:
    do -i { cubrid service stop }
    ^echo 'PRESET_MODE=release_gcc' o> .env
    ^echo 'SOURCE_DIR=/home/vimkim/gh/cb/oos-perf' | save --append .env

cubrid-start:
    cubrid broker start
    cubrid server start testdb

perf-record-cub_server:
    sudo perf record -F max -g -a -p (^ps aux | rg vimkim | rg cub_server | fzf | awk '{print $2}')

perf-report:
    sudo perf report -g

perf-flamegraph:
    sudo perf script | inferno-collapse-perf | flamelens
