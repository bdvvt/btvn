CREATE TABLE customers (
                           id SERIAL PRIMARY KEY,
                           name VARCHAR(255),
                           credit_limit NUMERIC(12,2)
);

CREATE TABLE orders (
                        id SERIAL PRIMARY KEY,
                        customer_id INT,
                        order_amount NUMERIC(12,2),
                        FOREIGN KEY (customer_id) REFERENCES customers(id)
);

INSERT INTO customers (name, credit_limit)
VALUES
    ('Nguyen Van A', 5000),
    ('Tran Thi B', 10000);

create or replace function check_credit_limit()
    RETURNS TRIGGER AS $$
DECLARE
     total_order numeric(12,2);
    credit numeric(12,2);
BEGIN
    SELECT credit_limit INTO credit
    FROM customers
    WHERE id = NEW.customer_id;

    SELECT  COALESCE(SUM(order_amount),0)
        INTO  total_order
    from orders
    WHERE id = NEW.customer_id;

    IF (total_order + NEW.order_amount) > credit THEN
        RAISE EXCEPTION 'Vuot han muc tin dung! Tong: %, Han muc: %',
            total_order + NEW.order_amount, credit;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_credit
    BEFORE INSERT ON orders
    FOR EACH ROW
EXECUTE FUNCTION check_credit_limit();

INSERT INTO orders (customer_id, order_amount)
VALUES (1, 3000);

INSERT INTO orders (customer_id, order_amount)
VALUES (1, 7000);

SELECT * FROM orders;