run-join-benchmark-t_15500-limit-50000-id-oos-perf-512M:
	^uv run src/run_join_benchmark.py --left-table-name "t_15500" --right-table-name "t_15500" --left-limit 50000 --right-limit 50000 --join-condition "l.id = r.id" --join-type "INNER" --times 3 --cubrid-branch "oos-perf" --data-buffer-size "512.0M"

run-join-benchmark-t_15500-limit-50000-id-develop-512M:
	^uv run src/run_join_benchmark.py --left-table-name "t_15500" --right-table-name "t_15500" --left-limit 50000 --right-limit 50000 --join-condition "l.id = r.id" --join-type "INNER" --times 3 --cubrid-branch "develop" --data-buffer-size "512.0M"

run-join-benchmark-t_16500-limit-50000-id-oos-perf-512M:
	^uv run src/run_join_benchmark.py --left-table-name "t_16500" --right-table-name "t_16500" --left-limit 50000 --right-limit 50000 --join-condition "l.id = r.id" --join-type "INNER" --times 3 --cubrid-branch "oos-perf" --data-buffer-size "512.0M"

run-join-benchmark-t_16500-limit-50000-id-develop-512M:
	^uv run src/run_join_benchmark.py --left-table-name "t_16500" --right-table-name "t_16500" --left-limit 50000 --right-limit 50000 --join-condition "l.id = r.id" --join-type "INNER" --times 3 --cubrid-branch "develop" --data-buffer-size "512.0M"

report-join-sqlite:
    open ./report-join-sqlite.sql | sqlite3 out/join-benchmarks.sqlite -box | awk -f color-table.awk


