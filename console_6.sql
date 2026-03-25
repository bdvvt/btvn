CREATE TABLE students (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50),
  age INT,
  major VARCHAR(50),
  gpa DECIMAL(3,2)
);

INSERT INTO students (name, age, major, gpa) VALUES
  ('An', 20, 'CNTT', 3.5),
  ('Bình', 21, 'Toán', 3.2),
  ('Cường', 22, 'CNTT', 3.8),
  ('Dương', 20, 'Vật lý', 3.0),
  ('Em', 21, 'CNTT', 2.9);

INSERT INTO students (name, age, major, gpa)
VALUES ('Hùng', 23, 'Hóa học', 3.4);

UPDATE students
SET gpa = 3.6
WHERE name = 'Bình';

DELETE FROM students
WHERE gpa < 3.0;

SELECT name, major
FROM students
ORDER BY gpa DESC;

SELECT DISTINCT name
FROM students
WHERE major = 'CNTT';

SELECT *
FROM students
WHERE gpa BETWEEN 3.0 AND 3.6;

SELECT *
FROM students
WHERE name LIKE 'C%';

SELECT *
FROM students
ORDER BY name ASC
LIMIT 3 OFFSET 1;
