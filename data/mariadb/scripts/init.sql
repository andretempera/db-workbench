-- Create test table if not exists
CREATE TABLE IF NOT EXISTS test (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    project VARCHAR(100)
);

INSERT INTO test (id, name, project)
VALUES (1, 'Andre', 'db-workbench')
ON DUPLICATE KEY UPDATE id = id;

-- Ensure root can connect from any host
ALTER USER 'root'@'%' IDENTIFIED BY 'rootpass';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;