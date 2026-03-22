CREATE SCHEMA university;
SET search_path TO university;

CREATE TABLE university.Students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE university.Courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    credits INT
);

CREATE TABLE university.Enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT,
    course_id INT,
    enroll_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)

);

--Xem danh sách database
SELECT datname FROM pg_database;

--Xem danh sách schema
SELECT schema_name FROM information_schema.schemata;

--Xem cấu trúc bảng Students, Courses, Enrollments
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'university'
  AND table_name IN ('Students', 'Courses', 'Enrollments')
ORDER BY table_name;