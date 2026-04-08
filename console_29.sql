create schema ss9c4

CREATE TABLE products (
                          id SERIAL PRIMARY KEY,
                          name VARCHAR(100),
                          stock INT
);

CREATE TABLE orders (
                        id SERIAL PRIMARY KEY,
                        product_id INT REFERENCES products(id),
                        quantity INT,
                        status VARCHAR(20) DEFAULT 'ACTIVE'
);

INSERT INTO products(name, stock) VALUES
                                      ('Iphone', 10),
                                      ('Samsung', 20);

CREATE OR REPLACE FUNCTION trg_order_insert_func()
    RETURNS TRIGGER AS $$
DECLARE
    v_stock INT;
BEGIN
    SELECT stock INTO v_stock
    FROM products
    WHERE id = NEW.product_id;

    IF v_stock < NEW.quantity THEN
        RAISE EXCEPTION 'Khong du hang';
    END IF;

    UPDATE products
    SET stock = stock - NEW.quantity
    WHERE id = NEW.product_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_order_insert
    AFTER INSERT ON orders
    FOR EACH ROW
EXECUTE FUNCTION trg_order_insert_func();

CREATE OR REPLACE FUNCTION trg_order_update_func()
    RETURNS TRIGGER AS $$
DECLARE
    v_stock INT;
    v_change INT;
BEGIN
    IF NEW.product_id <> OLD.product_id THEN

        UPDATE products
        SET stock = stock + OLD.quantity
        WHERE id = OLD.product_id;

        SELECT stock INTO v_stock
        FROM products
        WHERE id = NEW.product_id;

        IF v_stock < NEW.quantity THEN
            RAISE EXCEPTION 'Khong du hang khi doi san pham';
        END IF;

        UPDATE products
        SET stock = stock - NEW.quantity
        WHERE id = NEW.product_id;

    ELSE
        v_change := NEW.quantity - OLD.quantity;

        IF v_change > 0 THEN
            SELECT stock INTO v_stock FROM products WHERE id = NEW.product_id;

            IF v_stock < v_change THEN
                RAISE EXCEPTION 'Khong du hang';
            END IF;

            UPDATE products
            SET stock = stock - v_change
            WHERE id = NEW.product_id;

        ELSIF v_change < 0 THEN
            UPDATE products
            SET stock = stock + ABS(v_change)
            WHERE id = NEW.product_id;
        END IF;
    END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_order_update
    AFTER UPDATE ON orders
    FOR EACH ROW
EXECUTE FUNCTION trg_order_update_func();

CREATE OR REPLACE FUNCTION trg_order_delete_func()
    RETURNS TRIGGER AS $$
BEGIN
    UPDATE products
    SET stock = stock + OLD.quantity
    WHERE id = OLD.product_id;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_order_delete
    AFTER DELETE ON orders
    FOR EACH ROW
EXECUTE FUNCTION trg_order_delete_func();

INSERT INTO orders(product_id, quantity)
VALUES (1, 3);

UPDATE orders
SET quantity = 8
WHERE id = 1;

UPDATE orders
SET quantity = 2
WHERE id = 1;

DELETE FROM orders
WHERE id = 1;

SELECT * FROM products;