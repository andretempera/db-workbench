CREATE KEYSPACE IF NOT EXISTS testks
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

USE testks;

CREATE TABLE IF NOT EXISTS test (
  id int PRIMARY KEY,
  name text,
  project text
);

INSERT INTO test (id, name, project) VALUES (1, 'Andre', 'local-databases');