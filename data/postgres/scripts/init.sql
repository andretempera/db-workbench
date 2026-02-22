SET search_path TO public;

CREATE TABLE IF NOT EXISTS test (
    id INTEGER PRIMARY KEY,
    name TEXT,
    project TEXT
);

INSERT INTO test (id, name, project)
VALUES (1, 'Andre', 'db-workbench')
ON CONFLICT (id) DO NOTHING;