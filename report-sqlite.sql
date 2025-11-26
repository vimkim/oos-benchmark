SELECT
    cubrid_branch,
    data_buffer_size,
    col_names,
    table_name,
    num_rows,
    avg(user_level_total_time) AS avg_user_level_total_time,
    avg(heap_time) AS avg_heap_time,
    avg(heap_ioread) AS avg_ioread,
    avg(heap_fetch) AS avg_heap_fetch,
    count(*) AS num_of_tests
FROM
    benchmarks
GROUP BY
    col_names,
    table_name,
    num_rows,
    cubrid_branch,
    data_buffer_size
ORDER BY
    data_buffer_size,
    table_name,
    col_names,
    cubrid_branch,
    avg_heap_time;

.print 'hellowolrd'

SELECT
    cubrid_branch,
    data_buffer_size,
    col_names,
    table_name,
    num_rows,
    avg(user_level_total_time) AS avg_user_level_total_time,
    avg(heap_time) AS avg_heap_time,
    avg(heap_ioread) AS avg_ioread,
    avg(heap_fetch) AS avg_heap_fetch,
    count(*) AS num_of_tests
FROM
    benchmarks
GROUP BY
    col_names,
    table_name,
    num_rows,
    cubrid_branch,
    data_buffer_size
HAVING
    col_names = '*'
ORDER BY
    data_buffer_size,
    table_name,
    col_names,
    cubrid_branch,
    avg_heap_time;
