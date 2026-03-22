CREATE SCHEMA library;
SET search_path TO library;

CREATE TABLE library.Books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    author VARCHAR(50) NOT NULL,
    published_year INT,
    price REAL
);
--Xem danh sách database
SELECT datname FROM pg_database;

--Xem danh sách schema
SELECT schema_name
FROM information_schema.schemata;

--Xem cấu trúc bảng Books
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'library'
AND table_name = 'Books';
