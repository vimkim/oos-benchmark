SELECT
    cubrid_branch,
    data_buffer_size,
    col_names,
    table_name,
    num_rows,
    avg(user_level_total_time) AS 'avg_user_level_total_time (ms)',
    avg(heap_time) AS 'avg_heap_time (ms)',
    avg(heap_ioread) AS 'avg_ioread (count)',
    avg(heap_fetch) AS 'avg_heap_fetch (count)',
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

.print '- join, t_15500';

.print '------------------------------------------------------------------';

SELECT
    cubrid_branch,
    data_buffer_size,
    col_names,
    table_name,
    num_rows,
    avg(user_level_total_time) AS 'avg_user_level_total_time (ms)',
    avg(heap_time) AS 'avg_heap_time (ms)',
    avg(heap_ioread) AS 'avg_ioread (count)',
    avg(heap_fetch) AS 'avg_heap_fetch (count)',
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
    table_name = 'JOIN(LEFT=t_15500,RIGHT=t_15500,TYPE=INNER,COND=l.id = r.id,LIMIT_L=50000,LIMIT_R=50000)'
ORDER BY
    cast(avg(user_level_total_time) AS real);

.print '';

.print '------------------------------------------------------------------';

.print '- join, t_16500';

.print '------------------------------------------------------------------';

SELECT
    cubrid_branch,
    data_buffer_size,
    col_names,
    table_name,
    num_rows,
    avg(user_level_total_time) AS 'avg_user_level_total_time (ms)',
    avg(heap_time) AS 'avg_heap_time (ms)',
    avg(heap_ioread) AS 'avg_ioread (count)',
    avg(heap_fetch) AS 'avg_heap_fetch (count)',
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
    table_name = 'JOIN(LEFT=t_16500,RIGHT=t_16500,TYPE=INNER,COND=l.id = r.id,LIMIT_L=50000,LIMIT_R=50000)'
ORDER BY
    cast(avg(user_level_total_time) AS real);
