-- Cassandra initialization

-- Use keyspace from environment variable if possible
-- Default to "testks" if not set
CREATE KEYSPACE IF NOT EXISTS testks
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

USE testks;

CREATE TABLE IF NOT EXISTS test (
  id int PRIMARY KEY,
  name text,
  project text
);

-- Insert a single row if it doesn't already exist
INSERT INTO test (id, name, project) 
VALUES (1, 'Andre', 'db-workbench') IF NOT EXISTS;