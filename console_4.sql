CREATE SCHEMA sales;
SET search_path TO sales;

CREATE TABLE sales.Products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price NUMERIC(10,2),
    stock_quantity INT
);

CREATE TABLE sales.Orders (
    order_id SERIAL PRIMARY KEY,
    order_date DATE DEFAULT CURRENT_DATE,
    member_id INT,
    FOREIGN KEY (member_id) REFERENCES library.Members(member_id)
);

CREATE TABLE sales.OrderDetails (
    order_detail_id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES sales.Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES sales.Products(product_id)
);

