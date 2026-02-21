USE mysql;

CREATE TABLE IF NOT EXISTS test (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    project VARCHAR(100)
);

INSERT INTO test (id, name, project)
VALUES (1, 'Andre', 'local-databases')
ON DUPLICATE KEY UPDATE id = id;