-- All tables of a database.
SHOW TABLES FROM airbnb;

-- Foreign key details.
SELECT * FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE TABLE_SCHEMA = 'airbnb';

-- Tables' Structure (Columns, Data Types, etc.).
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'airbnb';

-- Database Size.
SELECT table_schema AS "Database", 
       ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS "Size (MB)" 
FROM INFORMATION_SCHEMA.TABLES 
WHERE table_schema = 'airbnb'
GROUP BY table_schema;

-- Character Set and Collation of a Database.
SELECT SCHEMA_NAME, DEFAULT_CHARACTER_SET_NAME, DEFAULT_COLLATION_NAME 
FROM INFORMATION_SCHEMA.SCHEMATA 
WHERE SCHEMA_NAME = 'airbnb';

-- All indexes of all tables.
SELECT * FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = 'airbnb';

-- Constraints of all tables.
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = 'airbnb';

-- Number of entries in each table of a databse.
SELECT 
    TABLE_NAME AS table_name,
    TABLE_ROWS AS row_count,
    ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024, 2) AS table_size_mb
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'airbnb';

-- The total size of indexes of a database.
SELECT 
    ROUND(SUM(INDEX_LENGTH) / 1024 / 1024, 2) AS total_index_size_mb
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'airbnb';
