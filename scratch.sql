SET
    trace ON output text;

SHOW TABLES;

DROP TABLE IF EXISTS tbl;

SHOW trace;

DROP TABLE IF EXISTS t_oos_12000;

-------------------------------------------------------------------------------
-- select id
-------------------------------------------------------------------------------
SELECT
    /*+ NO_MERGE RECOMPILE NO_PARALLEL_HEAP_SCAN PARALLEL(0) */
    count(*)
FROM
    (
        SELECT
            /*+ NO_MERGE RECOMPILE NO_PARALLEL_HEAP_SCAN PARALLEL(0) */
            id
        FROM
            t_2500
        LIMIT
            300000
    );

SHOW trace;

-------------------------------------------------------------------------------
-- select txt
-------------------------------------------------------------------------------
SELECT
    /*+ NO_MERGE RECOMPILE NO_PARALLEL_HEAP_SCAN PARALLEL(0) */
    count(*)
FROM
    (
        SELECT
            /*+ NO_MERGE RECOMPILE NO_PARALLEL_HEAP_SCAN PARALLEL(0) */
            txt
        FROM
            t_2500
        LIMIT
            300000
    );

SHOW trace;

-------------------------------------------------------------------------------
-- select *
-------------------------------------------------------------------------------
SELECT
    /*+ NO_MERGE RECOMPILE NO_PARALLEL_HEAP_SCAN PARALLEL(0) */
    count(*)
FROM
    (
        SELECT
            /*+ NO_MERGE RECOMPILE NO_PARALLEL_HEAP_SCAN PARALLEL(0) */
            *
        FROM
            t_2500
        LIMIT
            300000
    );

SHOW trace;

-------------------------------------------------------------------------------
-- debugging
-------------------------------------------------------------------------------
/* for debugging oos. breakpoint at oos_read */
SELECT
    txt
FROM
    t_2500
WHERE
    id = 1;

-------------------------------------------------------------------------------
-- select id
-------------------------------------------------------------------------------
SELECT
    /*+ NO_MERGE RECOMPILE NO_PARALLEL_HEAP_SCAN PARALLEL(0) */
    count(*)
FROM
    (
        SELECT
            /*+ NO_MERGE RECOMPILE NO_PARALLEL_HEAP_SCAN PARALLEL(0) */
            id
        FROM
            t_15500
        LIMIT
            300000
    );

SHOW trace;

-------------------------------------------------------------------------------
-- select txt
-------------------------------------------------------------------------------
SELECT
    /*+ NO_MERGE RECOMPILE NO_PARALLEL_HEAP_SCAN PARALLEL(0) */
    count(*)
FROM
    (
        SELECT
            /*+ NO_MERGE RECOMPILE NO_PARALLEL_HEAP_SCAN PARALLEL(0) */
            txt
        FROM
            t_15500
        LIMIT
            300000
    );

SHOW trace;

-------------------------------------------------------------------------------
-- select *
-------------------------------------------------------------------------------
SELECT
    /*+ NO_MERGE RECOMPILE NO_PARALLEL_HEAP_SCAN PARALLEL(0) */
    count(*)
FROM
    (
        SELECT
            /*+ NO_MERGE RECOMPILE NO_PARALLEL_HEAP_SCAN PARALLEL(0) */
            *
        FROM
            t_15500
        LIMIT
            300000
    );

SHOW trace;

-------------------------------------------------------------------------------
-- debugging
-------------------------------------------------------------------------------
/* for debugging oos. breakpoint at oos_read */
SELECT
    *
FROM
    t_15500
WHERE
    id = 1;
