CREATE SCHEMA sales;
SET search_path TO sales;

CREATE TABLE sales.Customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20)
);

CREATE TABLE sales.Products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price REAL NOT NULL CHECK (price > 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0)
);

CREATE TABLE sales.Orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES sales.Customers(customer_id) ON DELETE CASCADE

);

CREATE TABLE sales.OrderItems (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity >= 1),
    FOREIGN KEY (order_id) REFERENCES sales.Orders (order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES sales.Products (product_id)
);



