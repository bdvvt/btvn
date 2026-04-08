CREATE TABLE employees (
                           id SERIAL PRIMARY KEY,
                           name VARCHAR(255),
                           position VARCHAR(100),
                           salary NUMERIC(12,2)
);

CREATE TABLE employees_log (
                               log_id SERIAL PRIMARY KEY,
                               employee_id INT,
                               operation VARCHAR(10),
                               old_data JSONB,
                               new_data JSONB,
                               change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_employee_changes()
    RETURNS TRIGGER AS $$
BEGIN

    -- INSERT
    IF TG_OP = 'INSERT' THEN
        INSERT INTO employees_log(employee_id, operation, old_data, new_data, change_time)
        VALUES (
                   NEW.id,
                   'INSERT',
                   NULL,
                   to_jsonb(NEW),
                   CURRENT_TIMESTAMP
               );
        RETURN NEW;
    END IF;

    -- UPDATE
    IF TG_OP = 'UPDATE' THEN
        INSERT INTO employees_log(employee_id, operation, old_data, new_data, change_time)
        VALUES (
                   NEW.id,
                   'UPDATE',
                   to_jsonb(OLD),
                   to_jsonb(NEW),
                   CURRENT_TIMESTAMP
               );
        RETURN NEW;
    END IF;

    -- DELETE
    IF TG_OP = 'DELETE' THEN
        INSERT INTO employees_log(employee_id, operation, old_data, new_data, change_time)
        VALUES (
                   OLD.id,
                   'DELETE',
                   to_jsonb(OLD),
                   NULL,
                   CURRENT_TIMESTAMP
               );
        RETURN OLD;
    END IF;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_employee
    AFTER INSERT OR UPDATE OR DELETE ON employees
    FOR EACH ROW
EXECUTE FUNCTION log_employee_changes();

INSERT INTO employees (name, position, salary)
VALUES ('Nguyen Van A', 'Developer', 1000);

UPDATE employees
SET salary = 1500
WHERE id = 1;

DELETE FROM employees
WHERE id = 1;

SELECT * FROM employees_log;