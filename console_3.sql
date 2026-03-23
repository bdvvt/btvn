CREATE SCHEMA library;
SET search_path TO library;

CREATE TABLE library.Books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(200),
    author VARCHAR(100),
    published_year INT,
    available BOOLEAN DEFAULT TRUE
);

CREATE TABLE library.Members (
    member_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    join_date DATE DEFAULT CURRENT_DATE
);