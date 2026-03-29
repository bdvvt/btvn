-- 1. Tạo bảng Sinh viên
CREATE TABLE students (
                          student_id SERIAL PRIMARY KEY,
                          full_name VARCHAR(100),
                          major VARCHAR(50)
);

-- 2. Tạo bảng Môn học
CREATE TABLE courses (
                         course_id SERIAL PRIMARY KEY,
                         course_name VARCHAR(100),
                         credit INT
);

-- 3. Tạo bảng Đăng ký học (Bảng trung gian lưu điểm)
CREATE TABLE enrollments (
                             student_id INT REFERENCES students(student_id),
                             course_id INT REFERENCES courses(course_id),
                             score NUMERIC(5,2),
                             PRIMARY KEY (student_id, course_id)
);

-- Thêm dữ liệu Sinh viên
INSERT INTO students (full_name, major) VALUES
                                            ('Nguyễn Văn An', 'Công nghệ thông tin'),
                                            ('Trần Thị Bình', 'Công nghệ thông tin'),
                                            ('Lê Hoàng Nam', 'Quản trị kinh doanh'),
                                            ('Phạm Minh Đức', 'Quản trị kinh doanh'),
                                            ('Võ Thị Xuân', 'Ngôn ngữ Anh');

-- Thêm dữ liệu Môn học
INSERT INTO courses (course_name, credit) VALUES
                                              ('Cơ sở dữ liệu', 3),
                                              ('Lập trình Java', 4),
                                              ('Kinh tế vĩ mô', 3),
                                              ('Tiếng Anh chuyên ngành', 2);

-- Thêm dữ liệu Điểm số (Enrollments)
INSERT INTO enrollments (student_id, course_id, score) VALUES
                                                           (1, 1, 8.5), (1, 2, 9.0), -- An học CNTT
                                                           (2, 1, 7.0), (2, 2, 6.5), -- Bình học CNTT
                                                           (3, 3, 8.0),              -- Nam học QTKD
                                                           (4, 3, 6.0),              -- Đức học QTKD
                                                           (5, 4, 9.5),              -- Xuân học Ngôn ngữ Anh
                                                           (1, 4, 7.5);              -- An học thêm Tiếng Anh

SELECT s.full_name as tensv,c.course_name as Mh,e.score as "diem"
FROM students s
JOIN enrollments e on s.student_id = e.student_id
JOIN courses c on c.course_id = e.course_id;

SELECT
        AVG(score) as diemtb,
        MAX(score) as diemcao,
        MIN(score) as diemthap
FROM enrollments e

GROUP BY e.student_id;

SELECT s.full_name,AVG(e.score) AS avg_SCORE
FROM students s
JOIN enrollments e on s.student_id = e.student_id
GROUP BY s.full_name
HAVING AVG(e.score) > 7.5;

SELECT
    s.full_name,c.course_name ,c.credit ,e.score
FROM students s
         JOIN enrollments e ON s.student_id = e.student_id
         JOIN courses c ON e.course_id = c.course_id;

select e.student_id,avg(e.score)
from enrollments e
GROUP BY  e.student_id
having  avg(e.score) >(
SELECT avg(e.score)
FROM enrollments e)
