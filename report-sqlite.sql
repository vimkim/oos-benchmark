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
    cubrid_branch;

.print '';

.print '------------------------------------------------------------------';

.print '- select id';

.print '------------------------------------------------------------------';

.print 'select id from t_2500, order by user_level_total_time';

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
    col_names = 'id'
    AND table_name = 't_2500'
ORDER BY
    cast(avg_user_level_total_time AS real);

.print '';

.print 'select id from t_15500, order by user_level_total_time';

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
    col_names = 'id'
    AND table_name = 't_15500'
ORDER BY
    cast(avg_user_level_total_time AS real);

.print '';

.print 'select id from t_16500, order by user_level_total_time';

.print 'TIP: this goes to overflow';

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
    col_names = 'id'
    AND table_name = 't_16500'
ORDER BY
    cast(avg_user_level_total_time AS real);

.print '';

.print '------------------------------------------------------------------';

.print '- select *';

.print '------------------------------------------------------------------';

.print 'select * from t_2500, order by user_level_total_time';

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
    AND table_name = 't_2500'
ORDER BY
    cast(avg_user_level_total_time AS real);

.print '';

.print 'select * from t_15500, order by user_level_total_time';

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
    AND table_name = 't_15500'
ORDER BY
    cast(avg_user_level_total_time AS real);

.print '';

.print 'select * from t_16500, order by user_level_total_time';

.print 'TIP: this goes to overflow';

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
    AND table_name = 't_16500'
ORDER BY
    cast(avg_user_level_total_time AS real);
