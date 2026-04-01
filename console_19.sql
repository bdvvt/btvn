CREATE TABLE customer (
                          customer_id SERIAL PRIMARY KEY,
                          full_name VARCHAR(100),
                          email VARCHAR(100),
                          phone VARCHAR(15)
);

CREATE TABLE orders (
                        order_id SERIAL PRIMARY KEY,
                        customer_id INT REFERENCES customer(customer_id),
                        total_amount DECIMAL(10,2),
                        order_date DATE
);

INSERT INTO customer (full_name, email, phone) VALUES
                                                   ('Nguyen Van A','vana@gmail.com','0901234567'),
                                                   ('Tran Thi B','thib@gmail.com','0912345678'),
                                                   ('Le Van C','vanc@gmail.com','0923456789'),
                                                   ('Pham Thi D','thid@gmail.com','0934567890'),
                                                   ('Hoang Van E','vane@gmail.com','0945678901');

INSERT INTO orders (customer_id, total_amount, order_date) VALUES
                                                               (1, 500000, '2024-01-10'),
                                                               (1, 1500000, '2024-02-15'),
                                                               (2, 2000000, '2024-02-20'),
                                                               (3, 750000, '2024-03-05'),
                                                               (4, 3000000, '2024-03-18'),
                                                               (5, 1200000, '2024-04-01'),
                                                               (2, 950000, '2024-04-12'),
                                                               (3, 2200000, '2024-05-09');

CREATE VIEW v_order_summary AS
SELECT c.full_name, o.total_amount, o.order_date
FROM customer c JOIN orders o ON c.customer_id = o.customer_id;

SELECT * FROM v_order_summary;

CREATE VIEW v_high_orders AS
SELECT c.full_name, o.total_amount, o.order_date
FROM customer c JOIN orders o ON c.customer_id = o.customer_id
WHERE o.total_amount >= 1000000;

UPDATE orders
SET total_amount = 1500000
WHERE order_id = 1;

SELECT * FROM v_high_orders;

CREATE VIEW v_sales AS
SELECT DATE_TRUNC('month', order_date) AS month,
       SUM(total_amount) AS total_revenue
FROM orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;

SELECT * FROM v_sales;

DROP VIEW v_order_summary;