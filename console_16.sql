CREATE TABLE customers (
                           customer_id INT PRIMARY KEY,
                           customer_name VARCHAR(100),
                           city VARCHAR(50)
);

CREATE TABLE orders (
                        order_id INT PRIMARY KEY,
                        customer_id INT,
                        order_date DATE,
                        total_price INT,
                        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
                             item_id INT PRIMARY KEY,
                             order_id INT,
                             product_id INT,
                             quantity INT,
                             price INT,
                             FOREIGN KEY (order_id) REFERENCES orders(order_id)
);


INSERT INTO customers VALUES
                          (1,'Nguyen Van A','Ha Noi'),
                          (2,'Tran Thi B','Da Nang'),
                          (3,'Le Van C','Ho Chi Minh'),
                          (4,'Pham Thi D','Ha Noi');

INSERT INTO orders VALUES
                       (101,1,'2024-12-20',3000),
                       (102,2,'2025-01-05',1500),
                       (103,1,'2025-02-10',2500),
                       (104,3,'2025-02-15',4000),
                       (105,4,'2025-03-01',800);

INSERT INTO order_items VALUES
                            (1,101,1,2,1500),
                            (2,102,2,1,1500),
                            (3,103,3,5,500),
                            (4,104,2,4,1000);

SELECT c.customer_name, SUM(o.total_price) AS total_revenue, COUNT(o.order_id) AS order_count
FROM customers c JOIN orders o ON c.customer_id=o.customer_id
GROUP BY c.customer_name
HAVING SUM(o.total_price) > 2000;

SELECT c.customer_name, SUM(o.total_price) AS total_revenue
FROM customers c JOIN orders o ON c.customer_id=o.customer_id
GROUP BY c.customer_name
HAVING SUM(o.total_price) >
       (
           SELECT AVG(total_rev)
           FROM(
                   SELECT SUM(total_price) total_rev
                   FROM orders
                   GROUP BY customer_id
               ) t
       );

SELECT c.city, SUM(o.total_price) total_revenue
FROM customers c JOIN orders o ON c.customer_id=o.customer_id
GROUP BY c.city
HAVING SUM(o.total_price)=
       (
           SELECT MAX(city_rev)
           FROM(
                   SELECT SUM(o.total_price) city_rev
                   FROM customers c
                            JOIN orders o
                                 ON c.customer_id=o.customer_id
                   GROUP BY c.city
               ) x
       );

SELECT c.customer_name, c.city, SUM(oi.quantity) total_products, SUM(oi.quantity*oi.price) total_spent
FROM customers c
INNER JOIN orders o ON c.customer_id=o.customer_id
INNER JOIN order_items oi ON o.order_id=oi.order_id
GROUP BY c.customer_name,c.city;

