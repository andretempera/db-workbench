CREATE DATABASE IF NOT EXISTS db_workbench;

CREATE TABLE IF NOT EXISTS db_workbench.test
(
    id UInt32,
    name String,
    project String
) ENGINE = MergeTree()
ORDER BY id;

INSERT INTO db_workbench.test
SELECT 1, 'Andre', 'db-workbench'
WHERE NOT EXISTS (
    SELECT 1 FROM db_workbench.test WHERE id = 1
);
