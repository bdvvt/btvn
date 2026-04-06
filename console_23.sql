CREATE TABLE employees (
                           emp_id SERIAL PRIMARY KEY,
                           emp_name VARCHAR(100),
                           job_level INT,
                           salary NUMERIC
);

INSERT INTO employees (emp_name, job_level, salary) VALUES
                                                        ('Nguyen Van A', 1, 1000.00),
                                                        ('Tran Thi B', 2, 2000.00),
                                                        ('Le Van C', 3, 3000.00);

CREATE OR REPLACE PROCEDURE adjust_salary(
    p_emp_id INT,
    OUT p_new_salary NUMERIC
)
    LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE employees
    SET salary = CASE
                     WHEN job_level = 1 THEN salary * 1.05
                     WHEN job_level = 2 THEN salary * 1.10
                     WHEN job_level = 3 THEN salary * 1.15
                     ELSE salary
        END
    WHERE emp_id = p_emp_id
    RETURNING salary INTO p_new_salary;
    IF p_new_salary IS NULL THEN
        p_new_salary := 0;
    END IF;
END;
$$;

CALL adjust_salary(3, NULL);
SELECT * FROM employees WHERE emp_id = 3;