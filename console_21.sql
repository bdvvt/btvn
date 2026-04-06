CREATE TABLE order_detail (
                              id SERIAL PRIMARY KEY,
                              order_id INT,
                              product_name VARCHAR(100),
                              quantity INT,
                              unit_price NUMERIC
);

INSERT INTO order_detail (order_id, product_name, quantity, unit_price) VALUES
                                                                            (1, 'Laptop', 1, 1500.00),
                                                                            (1, 'Mouse', 2, 25.00),
                                                                            (2, 'Keyboard', 1, 45.00);

CREATE OR REPLACE PROCEDURE calculate_order_total(
    order_id_input INT,
    OUT total NUMERIC
)
    LANGUAGE plpgsql
AS $$
BEGIN
    SELECT SUM(quantity * unit_price)
    INTO total
    FROM order_detail
    WHERE order_id = order_id_input;
    IF total IS NULL THEN
        total := 0;
    END IF;
END;
$$;

CALL calculate_order_total(1, NULL);