CREATE TABLE inventory (
                           product_id SERIAL PRIMARY KEY,
                           product_name VARCHAR(100),
                           quantity INT DEFAULT 0
);

INSERT INTO inventory (product_name, quantity) VALUES
                                                   ('iPhone 15', 10),
                                                   ('Samsung S24', 5),
                                                   ('Sony Headphones', 2);

CREATE OR REPLACE PROCEDURE check_stock(p_id INT, p_qty INT)
    LANGUAGE plpgsql
AS $$
DECLARE
    v_inventory_qty INT;
BEGIN
    SELECT quantity INTO v_inventory_qty
    FROM inventory
    WHERE product_id = p_id;
    IF v_inventory_qty < p_qty THEN
        RAISE EXCEPTION 'Không đủ hàng trong kho';
    ELSE
        RAISE NOTICE 'Sản phẩm ID % đủ hàng (Tồn: %, Yêu cầu: %)', p_id, v_inventory_qty, p_qty;
    END IF;
END;
$$;

CALL check_stock(1, 5);

CALL check_stock(1, 20);


