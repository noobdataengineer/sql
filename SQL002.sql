USE noob_pratice_queries;
-- create new table Students
CREATE TABLE IF NOT EXISTS Students(
	RollNUMBER INT PRIMARY KEY,
    NAME VARCHAR(20) NOT NULL,
    DOB DATE,
    SEX VARCHAR(1) DEFAULT 'M',
    EDUCATIONSYSTEM VARCHAR(20),
    CHECK (EDUCATIONSYSTEM IN ('STATEBOARD','NCERT','CBSE', 'ISCE'))
    );
SHOW TABLES;
-- insert values into the table by satisfying all constraints
INSERT INTO Grades VALUES(0821, 'AKASH', '2005-12-01', 'M', 'CBSE'), 
	(0721, 'PRIYA', '2005-10-05', 'F', 'CBSE');
    
-- view the table
SELECT * FROM Students;

-- changing datatype of the existing column
ALTER TABLE Students MODIFY EDUCATIONSYSTEM VARCHAR(10);

-- create new table Students
CREATE TABLE IF NOT EXISTS Grades(
	ID INT,
    Marks INT NOT NULL,
    FOREIGN KEY (ID)
    REFERENCES Students (ROLLNUMBER)
    );
    
SELECT * FROM Grades;

-- total numbers of records/rows in the table
SELECT COUNT(*) FROM Students;
SELECT COUNT(1) FROM Students;
-- count(*) or count(1) it has no delete both execution is same and execution time also then why the * or 1 signify in the syntax: it will work as a markup so for each rows it will give markup * and count the number of *

-- nested function
SELECT COUNT(DISTINCT(NAME)) FROM Students;

-- subquery 
SELECT NAME FROM Students WHERE LENGTH(NAME) = (SELECT MIN(LENGTH(NAME)) FROM Students);

/* 
AGGREGATION fuctions are SUM, COUNT, MAX, MIN, AVG: for good pratice to use GROUP BY & HAVING clause with Aggregation function if required
*/

/*
difference between union and union all
*/
CREATE TABLE Authors(
	authors_id INT,
    authors_name VARCHAR(20)
    );
    
CREATE TABLE Books(
	book_id INT,
    book_name VARCHAR(20)
    );
    
INSERT INTO Authors VALUES(1, 'Robin Sharma'), (1, 'Robin Sharma'), (2, 'Paul Coelho'), (3, 'Joseph Murthy'), (4, 'Jeff Killer'), (5, 'Napolean Hill'), (4, 'Jeff Killer'), (5, 'Napolean Hill');
INSERT INTO Books VALUES(1, 'The Mastery Manual'), (2, 'Alchemist'), (2, 'Alchemist'), (3, 'POSM'), (4, 'AIE'), (5, 'Think & Grow Rich');
SELECT * FROM Authors;
SELECT * FROM Books;

SELECT * FROM Authors
UNION ALL
SELECT * FROM Books;

SELECT * FROM Authors
UNION 
SELECT * FROM Books;

-- how to take user input in MySQL
SET @S = 'ATHARV'; -- SET @S = '&ENTER';
SELECT @S;

-- how to see specific set of data / data sampling: LIMIT FUNCTION
SELECT * FROM Authors ORDER BY authors_id DESC LIMIT 2;

-- Conditional Opertors <,>,<=,>=,=,!=
-- Logical Operators AND, OR, NOT

-- USE of BETWEEN CLAUSE
SELECT * FROM Students WHERE DOB BETWEEN '2005-02-01' AND '2005-03-01';

-- pattern matching based filter : LIKE CLAUSE ---- _ (underscore) means 1 character % (percent) means equal to 0/ more than 0 character
SELECT * FROM Students WHERE NAME LIKE 'A%';
SELECT * FROM Students WHERE NAME LIKE '%A';
SELECT * FROM Students WHERE NAME NOT LIKE 'A%';
SELECT * FROM Students WHERE NAME LIKE 'A___';

-- filter all name from Students where name length is atleast 5 character long
SELECT NAME FROM Students WHERE NAME LIKE '_____%';

CREATE TABLE ORDERS(
	order_id INT PRIMARY KEY,
    custom_id INT,
    country VARCHAR(3),
    state VARCHAR(20),
    city VARCHAR(20)
    );
    
INSERT INTO ORDERS VALUES(84563, 2001, 'USA', 'California', 'Los Angeles'),
(76563, 3001, 'JPN', 'Tokyo', 'Tokyo'),
(84564, 2006, 'USA', 'California', 'San Diego'),
(76564, 3002, 'JPN', 'Tokyo', 'Tokyo'),
(94563, 4001, 'IND', 'Maharashtra', 'Mumbai'),
(96563, 4001, 'IND', 'Karnataka', 'Bengaluru'),
(84567, 2005, 'USA', 'New York', 'New York'),
(16564, 7002, 'RUS', 'Moscow', 'Moscow'),
(44563, 9001, 'UK', 'England', 'London'),
(46563, 9002, 'UK', 'N Ireland', 'Belfast'),
(54567, 6005, 'AUS', 'New South Wales', 'Sydney'),
(26564, 1202, 'BZL', 'Amazonas', 'Manaus'),
(36564, 1002, 'GNY', 'Berlin', 'Teltow');

SELECT * FROM ORDERS;
    
CREATE TABLE CUSTOMERS(
	custom_id INT PRIMARY KEY,
    customer_number INT,
    country VARCHAR(3)
	);
    
INSERT INTO CUSTOMERS VALUES(2001, 345621, 'USA'),
(3001, 345612, 'JPN'),
(4001, 625621, 'IND'),
(9001, 346721, 'UK');

-- total orders from each country
SELECT country ,COUNT(*) FROM ORDERS GROUP BY country; 

-- IN GROUP BY what is the col_name mentioned only those you can display in final output others than this col_name you can apply the Aggregation funtion on top of that
-- always fail:-- SELECT *, COUNT(*) FROM ORDERS GROUP BY country; -- Error Code: 1055. Expression #1 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'noob_pratice_queries.ORDERS.order_id' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by

-- doing multiple aggregations + GROUP BY
 SELECT SUM(Salary) AS Total_Salary, 
	ROUND(AVG(Salary), 2) AS Average, 
    MIN(Salary) AS Minimum,
    MAX(Salary) AS Maximum,
    GENDER,
    COUNT(Salary) AS Number_Employees
FROM Employees GROUP BY GENDER;

-- WHERE CLAUSE always used before the GROUP BY  & try to follow HAVING CLAUSE AFTER GROUP BY; but the major difference between WHERE and HAVING clause is WHERE clause is used when we have to apply filter condition of particular type of cols and HAVING is used to apply filter condition on AGGREGATED results

SELECT GENDER, SUM(Salary) AS Total_Salary FROM Employees WHERE GENDER='Male' GROUP BY GENDER;
SELECT GENDER, COUNT(Salary) AS Number_Employees FROM Employees GROUP BY GENDER HAVING Number_Employees>2;

-- HAVING CLAUSE to find for which country the number of orders are less in ORDERS Table
SELECT country, COUNT(*) FROM ORDERS GROUP BY country HAVING COUNT(*)<2;

-- displaying results of non-aggregated cols, USE OF GROUP_CONCAT 
SELECT 
	country,
    GROUP_CONCAT(state) AS state_in_country
FROM ORDERS
GROUP BY country;

SELECT 
	country,
    GROUP_CONCAT(DISTINCT state) AS state_in_country
FROM ORDERS
GROUP BY country;

SELECT 
	country,
    GROUP_CONCAT(DISTINCT state ORDER BY state DESC) AS state_in_country
FROM ORDERS
GROUP BY country;

SELECT 
	country,
    GROUP_CONCAT(DISTINCT state ORDER BY state DESC SEPARATOR '| ') AS state_in_country
FROM ORDERS
GROUP BY country;

SELECT 
	country,
    GROUP_CONCAT(DISTINCT state ORDER BY state DESC SEPARATOR '<--> ') AS state_in_country
FROM ORDERS
GROUP BY country;

-- implementation of CASE-WHEN statement in SQL
SELECT Firstname, Salary, Gender,
	CASE 
    WHEN Salary>=7000 THEN 'A'
    WHEN Salary>=5000 THEN 'B'
    WHEN Salary>=2500 THEN 'C'
    ELSE 'D'
    END AS Rating
FROM employees;


INSERT INTO CUSTOMERS VALUES(2006, 346521, 'USA'),
(3002, 345614, 'JPN'),
(9002, 346271, 'UK'),
(1002, 116271, 'GNY');


-- JOINS - refernce from JOIN.png
/*
INNER JOIN/JOIN --- only those record where the common_col values are matched
*/
SELECT o.order_id, o.custom_id, o.country FROM Orders o
INNER JOIN Customers c ON o.custom_id=c.custom_id;

SELECT o.order_id, o.custom_id, o.country FROM Orders o
LEFT JOIN Customers c ON o.custom_id=c.custom_id;

-- LEFT JOIN EXCLUDING INNER JOIN means LEFT OUTER JOIN
SELECT o.order_id, o.custom_id, o.country FROM Orders o
LEFT OUTER JOIN Customers c ON o.custom_id=c.custom_id;

SELECT o.order_id, o.custom_id, o.country FROM Orders o
RIGHT JOIN Customers c ON o.custom_id=c.custom_id;

-- RIGHT JOIN EXCLUDING INNER JOIN means RIGHT OUTER JOIN 
SELECT o.*, c.* FROM Orders o
RIGHT OUTER JOIN Customers c ON o.custom_id=c.custom_id;

-- FULL JOIN
SELECT o.*, c.* FROM Orders o
FULL JOIN Customers c ON o.custom_id=c.custom_id;

SELECT o.*, c.* FROM Orders o
FULL OUTER JOIN Customers c ON o.custom_id=c.custom_id;

-- JOIN ON more than 2 tables
CREATE TABLE shippers(
	 shipper_id INT PRIMARY KEY,
     order_id INT,
     shipper_name VARCHAR(10)
     );
     
INSERT INTO shippers VALUE(001, 36564, 'J-ARRIVED'),(002, 84563, 'F-KART'),(003, 84564, 'J-CART'),(004, 96563, 'eKART'),(005, 94563, 'Bluekart');

SELECT o.order_id, o.custom_id, c.custom_id, c.customer_number, s.shipper_name FROM ORDERS o
INNER JOIN Customers c ON o.custom_id=c.custom_id
INNER JOIN shippers s ON o.order_id=s.order_id;


SELECT o.order_id, o.custom_id, c.custom_id, c.customer_number, s.shipper_name FROM ORDERS o
INNER JOIN Customers c ON o.custom_id=c.custom_id
LEFT JOIN shippers s ON o.order_id=s.order_id;


SELECT o.order_id, o.custom_id, c.custom_id, c.customer_number, s.shipper_name FROM ORDERS o
INNER JOIN Customers c ON o.custom_id=c.custom_id
RIGHT JOIN shippers s ON o.order_id=s.order_id;

SELECT o.order_id, o.custom_id, c.custom_id, c.customer_number, s.shipper_name FROM ORDERS o
RIGHT JOIN Customers c ON o.custom_id=c.custom_id
LEFT JOIN shippers s ON o.order_id=s.order_id;

SELECT o.order_id, o.custom_id, c.custom_id, c.customer_number, s.shipper_name FROM ORDERS o
LEFT JOIN Customers c ON o.custom_id=c.custom_id
LEFT JOIN shippers s ON o.order_id=s.order_id;

