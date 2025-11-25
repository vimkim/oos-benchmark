SELECT
    col_names,
    table_name,
    num_rows,
    avg(heap_time) AS avg_heap_time,
    avg(heap_ioread) AS avg_ioread,
    avg(heap_fetch) AS avg_heap_fetch,
    count(*) AS num_of_tests
FROM
    benchmarks
GROUP BY
    col_names,
    table_name,
    num_rows
ORDER BY
    avg_heap_time;
