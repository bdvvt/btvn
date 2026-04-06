CREATE TABLE products (
                          id SERIAL PRIMARY KEY,
                          name VARCHAR(100),
                          price NUMERIC,
                          discount_percent INT
);

INSERT INTO products (name, price, discount_percent) VALUES
                                                         ('Bàn làm việc', 1000, 20),
                                                         ('Ghế xoay', 500, 60),
                                                         ('Đèn học', 200, 10);



CREATE OR REPLACE PROCEDURE calculate_discount(
    p_id INT,
    OUT p_final_price NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_price NUMERIC;
    v_discount INT;
BEGIN
    SELECT price, discount_percent INTO v_price, v_discount
    FROM products
    WHERE id = p_id;
    IF NOT FOUND THEN
        p_id := 0;
    END IF;
    p_final_price := v_price - (v_price * v_discount / 100);
    IF  v_discount > 50 THEN
        v_discount := 50;
    end if;
    UPDATE products
    SET price = p_final_price
    WHERE id = p_id;
END;
$$;

DO $$
    DECLARE
        p_final_price NUMERIC;
    BEGIN
        CALL calculate_discount(2, p_final_price);
        RAISE NOTICE 'p_final_price = %', p_final_price;
    END $$;

