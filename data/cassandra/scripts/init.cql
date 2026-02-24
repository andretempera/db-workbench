CREATE KEYSPACE IF NOT EXISTS db_workbench
WITH replication = {
    'class': 'SimpleStrategy',
    'replication_factor': 1
};

USE db_workbench;

CREATE TABLE IF NOT EXISTS test (
    id int PRIMARY KEY,
    name text,
    project text
);

INSERT INTO test (id, name, project)
VALUES (1, 'Andre', 'db-workbench')
IF NOT EXISTS;