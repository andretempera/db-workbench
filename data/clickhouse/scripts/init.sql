CREATE DATABASE IF NOT EXISTS testdb;

CREATE TABLE IF NOT EXISTS testdb.test
(
    id UInt32,
    name String,
    project String
) ENGINE = MergeTree()
ORDER BY id;

-- Remove existing row with id = 1 to prevent duplicates
ALTER TABLE testdb.test DELETE WHERE id = 1;

INSERT INTO testdb.test VALUES (1, 'Andre', 'db-workbench');