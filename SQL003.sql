SHOW DATABASES;
CREATE SCHEMA noob_pratice_queries;
USE noob_pratice_queries;
/*
PRIMARY KEY(pk):
charactertistics. Uniqueness, Immutable, Simplicity, Indexed, Non-Intelligent(shouldn't content meangingful information), Referential Integrity, Data Type(commonly used are int or string)
FORIEGN KEY(fk):
charactertistics. Referential Integrity (Matched pk., Ensure Relationships), Nullable(fk. can contains null values unless specially restricted), No Uniqueness

One table can have one or more fk. but can have only one pk.
*/
CREATE TABLE IF NOT EXISTS flipkart_customers(
c_id int,
    c_name varchar(20),
    PRIMARY KEY(c_id)
    );
   
CREATE TABLE IF NOT EXISTS flipkart_orders(
o_id int,
    c_id int,
    PRIMARY KEY(o_id),
    FOREIGN KEY(c_id) REFERENCES flipkart_customers(c_id)
    );
   
INSERT INTO flipkart_customers VALUES(1, 'Arun'),(2, 'Sakshi'),(3, 'Priya'),(4,'Sumit');
INSERT INTO flipkart_orders VALUES(604, 2),(606, 2),(502, 4),(507, 3), (504, 3);

SELECT * FROM flipkart_customers;
SELECT * FROM flipkart_orders;

--- FAILING CONSTRAINTS
INSERT INTO flipkart_orders VALUE(608, 5);

/*
DELETE - DELETE THE PARTICULAR RECORD FROM THE TABLE - selective deletion of record >> DELETE THE SPECIFIED DATA
DROP - DELETE THE STRUCTURE OR COMPLETE TABLE >> DELETE TABLE STRUCTURE
TRUNCATE - DELETE ALL THE RECORDS OR DATA PRESENT IN THE TABLE >> DELETE COMPLETE DATA IN TABLE
*/

DELETE FROM flipkart_orders WHERE o_id=502;
TRUNCATE TABLE flipkart_customers;
DROP TABLE flipkart_customers;
DROP TABLE flipkart_orders;

/*
as per the transaction control
DELETE - can be ROLLBACK
DROP & TRUNCATE - cannot be ROLLBACK
In transitional db - data moves from EDIT LOGS to MEMORY - ACID Property so we cn get back the data using COMMIT or ROLLBACK command
*/

/*
CROSS JOIN
*/
SELECT * FROM flipkart_customers
CROSS JOIN flipkart_orders;

/*
SELF JOIN
*/
CREATE TABLE tcs_employees(
	id INT,
    FullName VARCHAR(25),
    salary DOUBLE,
    manager_id INT,
    PRIMARY KEY(id)
    );
    
INSERT INTO tcs_employees VALUES(1, 'John Smith', 10000, 3), (2, 'Jade Anderson', 12000, 3), (3, 'Tom Lanon', 15000, 4), (4, 'Anne Connor' , 200000, NULL), (5, 'Jeremy York', 9000, 2); 

SELECT * FROM tcs_employees;

SELECT e.*, m.FullName FROM tcs_employees e JOIN tcs_employees m WHERE e.manager_id=m.id;

CREATE TABLE payment (payment_amount decimal(8,2), 
payment_date date, 
store_id int);
 
INSERT INTO payment
VALUES
(1200.99, '2018-01-18', 1),
(189.23, '2018-02-15', 1),
(33.43, '2018-03-03', 3),
(7382.10, '2019-01-11', 2),
(382.92, '2019-02-18', 1),
(322.34, '2019-03-29', 2),
(2929.14, '2020-01-03', 2),
(499.02, '2020-02-19', 3),
(994.11, '2020-03-14', 1),
(394.93, '2021-01-22', 2),
(3332.23, '2021-02-23', 3),
(9499.49, '2021-03-10', 3),
(3002.43, '2018-02-25', 2),
(100.99, '2019-03-07', 1),
(211.65, '2020-02-02', 1),
(500.73, '2021-01-06', 3);

SELECT SUM(payment_amount), YEAR(payment_date) FROM payment GROUP BY YEAR(payment_date) ORDER BY YEAR(payment_date);

SELECT SUM(payment_amount), YEAR(payment_date), store_id FROM payment GROUP BY YEAR(payment_date), store_id WITH ROLLUP 
ORDER BY YEAR(payment_date);
/*
WITH ROLLUP-
the first row 30975.73 = sum of all the column revenue
the row with value 4426.08 = sum of all column revenue where year is 2018
WITH ROLLUP - we will get three level of information 1-overall, 2-year wise, 3-store wise
*/

CREATE TABLE meesho_orders(
	order_id INT,
    product_id INT,
    order_quantity INT,
    PRIMARY KEY(order_id)
    );

CREATE TABLE meesho_products(
    product_id INT,
    p_name VARCHAR(20),
    price DECIMAL(4, 2),
    PRIMARY KEY(product_id)
    );
    
INSERT INTO meesho_orders VALUES (6001, 1, 5),
	(6010, 2, 1),
    (6011, 1, 2),
    (6100, 4, 1),
    (6101, 5, 4),
    (6111, 3, 3),
    (6000, 6, 2);
    
INSERT INTO meesho_products VALUES (1, 'M T-Shirts', 30.00),
	(2, 'L Sarees', 50.00),
    (3, 'Kids Fashions', 25.00),
    (4, 'L Kurtis', 35.15),
	(5, 'M Jeans', 30.75),
    (6, 'L Lehanga', 45.15),
    (7, 'M Belts', 20.75),
    (8, 'L Scarf', 25.45);
    
    
-- write a SQL query to get total revenue (price*quantity_sold) for each product include product name and sort the result by revenue in descending order

SELECT p.p_name, COALESCE((SELECT SUM(o.order_quantity)*p.price FROM meesho_orders o WHERE o.product_id=p.product_id), 0) AS 'Total Revenue' FROM meesho_products p 
LEFT JOIN meesho_orders o ON p.product_id=o.product_id
GROUP BY p.product_id, p.p_name;