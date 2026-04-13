CREATE TABLE products (
                          product_id SERIAL PRIMARY KEY,
                          product_name VARCHAR(100),
                          stock INT,
                          price NUMERIC(10,2)
);

CREATE TABLE orders (
                        order_id SERIAL PRIMARY KEY,
                        customer_name VARCHAR(100),
                        total_amount NUMERIC(10,2),
                        created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE order_items (
                             order_item_id SERIAL PRIMARY KEY,
                             order_id INT REFERENCES orders(order_id),
                             product_id INT REFERENCES products(product_id),
                             quantity INT,
                             subtotal NUMERIC(10,2)
);

INSERT INTO products (product_name, stock, price) VALUES
                                                      ('Iphone', 10, 1000),
                                                      ('Samsung', 5, 800),
                                                      ('Xiaomi', 20, 500);

CREATE OR REPLACE PROCEDURE create_order(
    p_customer_name VARCHAR
)
    LANGUAGE plpgsql
AS $$
DECLARE
    v_order_id INT;
    v_price1 NUMERIC;
    v_price2 NUMERIC;
    v_stock1 INT;
    v_stock2 INT;
BEGIN
    SELECT stock, price INTO v_stock1, v_price1
    FROM products
    WHERE product_id = 1
        FOR UPDATE;

    SELECT stock, price INTO v_stock2, v_price2
    FROM products
    WHERE product_id = 2
        FOR UPDATE;

    IF v_stock1 < 2 THEN
        RAISE EXCEPTION 'Product 1 không đủ hàng';
    END IF;

    IF v_stock2 < 1 THEN
        RAISE EXCEPTION 'Product 2 không đủ hàng';
    END IF;

    INSERT INTO orders (customer_name, total_amount)
    VALUES (p_customer_name, 0)
    RETURNING order_id INTO v_order_id;


    INSERT INTO order_items (order_id, product_id, quantity, subtotal)
    VALUES
        (v_order_id, 1, 2, 2 * v_price1),
        (v_order_id, 2, 1, 1 * v_price2);

    UPDATE products SET stock = stock - 2 WHERE product_id = 1;
    UPDATE products SET stock = stock - 1 WHERE product_id = 2;

    UPDATE orders
    SET total_amount = (
        SELECT SUM(subtotal)
        FROM order_items
        WHERE order_id = v_order_id
    )
    WHERE order_id = v_order_id;
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
$$;

CALL create_order('Nguyen Van A');

SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM products;