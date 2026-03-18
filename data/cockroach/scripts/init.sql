CREATE DATABASE IF NOT EXISTS db_workbench;

USE db_workbench;

CREATE TABLE IF NOT EXISTS test (
    id INT PRIMARY KEY,
    name STRING,
    project STRING
);

UPSERT INTO test (id, name, project)
VALUES (1, 'Andre', 'db-workbench');