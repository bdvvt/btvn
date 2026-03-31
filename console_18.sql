CREATE TABLE book (
                      book_id SERIAL PRIMARY KEY,
                      title VARCHAR(255),
                      author VARCHAR(100),
                      genre VARCHAR(50),
                      price DECIMAL(10,2),
                      description TEXT,
                      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO book (title, author, genre, price, description) VALUES
                                                                ('Harry Potter and the Sorcerer''s Stone', 'J.K. Rowling', 'Fantasy', 19.99, 'A young wizard begins his magical journey.'),
                                                                ('Harry Potter and the Chamber of Secrets', 'J.K. Rowling', 'Fantasy', 21.99, 'The second year at Hogwarts with dark secrets.'),
                                                                ('The Hobbit', 'J.R.R. Tolkien', 'Fantasy', 25.50, 'A hobbit goes on an unexpected adventure.'),
                                                                ('The Lord of the Rings', 'J.R.R. Tolkien', 'Fantasy', 35.00, 'Epic journey to destroy the One Ring.'),
                                                                ('A Brief History of Time', 'Stephen Hawking', 'Science', 18.75, 'Understanding the universe and black holes.'),
                                                                ('The Theory of Everything', 'Stephen Hawking', 'Science', 20.00, 'Explains cosmology for general readers.'),
                                                                ('Clean Code', 'Robert C. Martin', 'Programming', 30.00, 'A handbook of agile software craftsmanship.'),
                                                                ('The Pragmatic Programmer', 'Andrew Hunt', 'Programming', 28.99, 'Tips for becoming a better programmer.'),
                                                                ('Atomic Habits', 'James Clear', 'Self-help', 22.00, 'Build good habits and break bad ones.'),
                                                                ('Think and Grow Rich', 'Napoleon Hill', 'Self-help', 15.00, 'Classic book on personal success.'),
                                                                ('To Kill a Mockingbird', 'Harper Lee', 'Fiction', 18.00, 'A story about racial injustice.'),
                                                                ('1984', 'George Orwell', 'Fiction', 17.50, 'Dystopian novel about totalitarian regime.'),
                                                                ('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 16.20, 'The American dream and tragedy.'),
                                                                ('Moby Dick', 'Herman Melville', 'Fiction', 19.40, 'A captain obsessed with a white whale.'),
                                                                ('Deep Learning', 'Ian Goodfellow', 'Technology', 45.00, 'Comprehensive introduction to deep learning.'),
                                                                ('Artificial Intelligence: A Modern Approach', 'Stuart Russell', 'Technology', 50.00, 'AI concepts and applications.'),
                                                                ('The Alchemist', 'Paulo Coelho', 'Fiction', 14.99, 'A journey of self-discovery.'),
                                                                ('Sapiens', 'Yuval Noah Harari', 'History', 23.50, 'History of humankind.'),
                                                                ('Homo Deus', 'Yuval Noah Harari', 'History', 24.00, 'Future of humanity.'),
                                                                ('The Lean Startup', 'Eric Ries', 'Business', 27.00, 'Build startups efficiently.');
EXPLAIN ANALYZE
SELECT * FROM book WHERE author ILIKE '%Rowling%';
SELECT * FROM book WHERE genre = 'Fantasy';


CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX idx_author_trgm
    ON book USING GIN (author gin_trgm_ops);

CREATE INDEX idx_genre
    ON book USING BTREE (genre);

SELECT *
FROM book
WHERE to_tsvector('english', title || ' ' || description)
          @@ to_tsquery('wizard');

CREATE INDEX idx_book_genre_cluster
    ON book(genre);
CLUSTER book USING idx_book_genre_cluster;

EXPLAIN ANALYZE
SELECT * FROM book WHERE genre = 'Fantasy';
