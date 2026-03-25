CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    gender VARCHAR(10),
    birth_year INT,
    major VARCHAR(50),
    gpa DECIMAL(3,2)
);

INSERT INTO students (full_name, gender, birth_year, major, gpa) VALUES
    ('Nguyễn Văn A', 'Nam', 2002, 'CNTT', 3.6),
    ('Trần Thị Bích Ngọc', 'Nữ', 2001, 'Kinh tế', 3.2),
    ('Lê Quốc Cường', 'Nam', 2003, 'CNTT', 2.7),
    ('Phạm Minh Anh', 'Nữ', 2000, 'Luật', 3.9),
    ('Nguyễn Văn A', 'Nam', 2002, 'CNTT', 3.6),
    ('Lưu Đức Tài', NULL, 2004, 'Cơ khí', NULL),
    ('Võ Thị Thu Hằng', 'Nữ', 2001, 'CNTT', 3.0);

INSERT INTO students (full_name, gender, birth_year, major, gpa)
VALUES ('Phan Hoàng Nam', 'Nam', 2003, 'CNTT', 3.8);

UPDATE students
SET gpa = 3.4
WHERE full_name = 'Lê Quốc Cường';

DELETE FROM students
WHERE gpa IS NULL;

SELECT *
FROM students
WHERE major = 'CNTT' AND gpa >= 3.0
LIMIT 3;

SELECT DISTINCT major
FROM students;

SELECT *
FROM students
WHERE major = 'CNTT'
ORDER BY gpa DESC, full_name ASC;

SELECT *
FROM students
WHERE full_name LIKE 'Nguyễn%';

SELECT *
FROM students
WHERE birth_year BETWEEN 2001 AND 2003;