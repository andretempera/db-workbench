CREATE DATABASE IF NOT EXISTS testdb;

CREATE TABLE IF NOT EXISTS testdb.test
(
    id UInt32,
    name String,
    project String
) ENGINE = MergeTree()
ORDER BY id;

INSERT INTO testdb.test VALUES (1, 'Andre', 'local-databases');