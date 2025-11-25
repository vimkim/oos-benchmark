SHOW TABLES;

DROP TABLE IF EXISTS tbl;

CREATE TABLE tbl (id int, txt varchar(14000));

SET
    trace ON output text;

SHOW trace;

DROP TABLE IF EXISTS t_oos_14000;

SELECT
    count(*)
FROM
    t_oos_14000;

SELECT
    *
FROM
    t_oos_14000;

SHOW trace;
