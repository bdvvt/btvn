CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name varchar(100)
);

CREATE TABLE employees (
                           emp_id SERIAL PRIMARY KEY,
                           emp_name VARCHAR(100),
                           dept_id INT REFERENCES departments(dept_id),
                           salary NUMERIC(10,2),
                           hire_date DATE
);


CREATE TABLE projects (
                          project_id SERIAL PRIMARY KEY,
                          project_name VARCHAR(100),
                          dept_id INT REFERENCES departments(dept_id)
);

INSERT INTO departments (dept_name) VALUES
                                        ('Phòng Kỹ thuật'),
                                        ('Phòng Kinh doanh'),
                                        ('Phòng Nhân sự'),
                                        ('Phòng Marketing');

INSERT INTO employees (emp_name, dept_id, salary, hire_date) VALUES
                                                                 ('Nguyễn Văn A', 1, 20000000.00, '2023-01-15'),
                                                                 ('Trần Thị B', 1, 18000000.00, '2023-02-20'),
                                                                 ('Lê Văn C', 2, 12000000.00, '2023-03-10'),
                                                                 ('Phạm Minh D', 2, 14000000.00, '2023-04-05'),
                                                                 ('Hoàng Thị E', 3, 10000000.00, '2023-05-12'),
                                                                 ('Ngô Văn F', 1, 25000000.00, '2022-11-01'),
                                                                 ('Đặng Thị G', 4, 16000000.00, '2023-06-25');

INSERT INTO projects (project_name, dept_id) VALUES
                                                 ('Hệ thống E-learning', 1),
                                                 ('Chiến dịch Sale Hè', 2),
                                                 ('Tuyển dụng IT', 3),
                                                 ('Ứng dụng Mobile', 1),
                                                 ('Quản lý Kho', 2);

SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
         JOIN departments AS d ON e.dept_id = d.dept_id;

SELECT
    SUM(salary) as tongquyluong,
    AVG(salary) as mucluongtrungbinh,
    MAX(salary) as luongcaonhat,
    MIN(salary) as luongthapnhat,
    COUNT(emp_id) as tongsonhanvien
FROM employees;

SELECT d.dept_name, AVG(e.salary) AS avg_salary
FROM employees e
         JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING AVG(e.salary) > 15000000;

SELECT
    p.project_name,d.dept_name,e.emp_name
FROM projects p
         JOIN departments d ON p.dept_id = d.dept_id
         JOIN employees e ON d.dept_id = e.dept_id;



SELECT e.emp_name,d.dept_name,e.salary
FROM employees e
join departments d on e.dept_id = d.dept_id
where (e.dept_id,e.salary) in
(select  e.dept_id, max(e.salary)
 from employees e
    group by  e.dept_id);