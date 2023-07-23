USE noob_pratice_queries;
-- WINDOWS function
SELECT *, SUM(sales_amount) OVER(PARTITION BY YEAR(sales_date)) AS 'Grand Total' FROM shop_sales_data;

SELECT *, SUM(sales_amount) OVER(PARTITION BY MONTH(sales_date)) AS 'Grand Total' FROM shop_sales_data;

SELECT *, SUM(sales_amount) OVER(PARTITION BY sales_date) AS 'Grand Total' FROM shop_sales_data;

-- PARTION BY - when in the query the statementent is like each shop, each customer, each department id
-- Ranking (ROW_NUMBER, RANK, DENSE_RANK), Value (FIRST_VALUE, LAST_VALUE, LAG, LEAD), Aggregate (SUM, MIN, MAX, COUNT)

CREATE TABLE gcoea_entc_marks(
	student_id INT,
    student_name VARCHAR(100),
    marks_obt INT
    );

INSERT INTO gcoea_entc_marks VALUES(4001, 'Vashnavi', 25), (4002, 'Rutuja', 37), (4003, 'Gaurav', 35), (4004, 'Aafaqua', 25), (4005, 'Rahil', 45);
INSERT INTO gcoea_entc_marks VALUES(4041, 'Abhijeet', 40), (4042, 'Nehal', 37), (4043, 'Pratik', 27), (4044, 'Sahil', 25), (4045, 'Veenayak', 21);
INSERT INTO gcoea_entc_marks VALUES(4011, 'Mathan', 29), (4012, 'Vallabh', 37), (4014, 'Chetan', 27), (4020, 'Rohan', 21), (4021, 'Radhika', 39);

SELECT *, ROW_NUMBER() OVER(ORDER BY marks_obt DESC) FROM gcoea_entc_marks;
SELECT *, RANK() OVER(ORDER BY marks_obt DESC) FROM gcoea_entc_marks;
SELECT *, DENSE_RANK() OVER(ORDER BY marks_obt DESC) FROM gcoea_entc_marks;

create table employees
(
    emp_id int,
    salary int,
    dept_name VARCHAR(30)
);

insert into employees values(1,10000,'Software');
insert into employees values(2,11000,'Software');
insert into employees values(3,11000,'Software');
insert into employees values(4,11000,'Software');
insert into employees values(5,15000,'Finance');
insert into employees values(6,15000,'Finance');
insert into employees values(7,15000,'IT');
insert into employees values(8,12000,'HR');
insert into employees values(9,12000,'HR');
insert into employees values(10,11000,'HR');

# Query - get one employee from each department who is getting maximum salary (employee can be random if salary is same)

SELECT tmp.* FROM 
(SELECT *, ROW_NUMBER() OVER(PARTITION BY dept_name ORDER BY salary DESC) AS rn FROM employees) tmp 
WHERE tmp.rn=1;

# Query - get one employee from each department who is getting maximum salary (employee can be random if salary is same)

select 
    tmp.*
from (select *,
        row_number() over(partition by dept_name order by salary desc) as row_num
    from employees) tmp
where tmp.row_num = 1;

# Query - get all employees from each department who are getting maximum salary
select 
    tmp.*
from (select *,
        rank() over(partition by dept_name order by salary desc) as rank_num
    from employees) tmp
where tmp.rank_num = 1;

# Query - get all top 2 ranked employees from each department who are getting maximum salary
select 
    tmp.*
from (select *,
        dense_rank() over(partition by dept_name order by salary desc) as dense_rank_num
    from employees) tmp
where tmp.dense_rank_num <= 2;

# Example for lag and lead
create table daily_sales
(
sales_date date,
sales_amount int
);


insert into daily_sales values('2022-03-11',400);
insert into daily_sales values('2022-03-12',500);
insert into daily_sales values('2022-03-13',300);
insert into daily_sales values('2022-03-14',600);
insert into daily_sales values('2022-03-15',500);
insert into daily_sales values('2022-03-16',200);

select *,
      lag(sales_amount, 1) over(order by sales_date) as pre_day_sales
from daily_sales;

select *,
      lead(sales_amount, 1) over(order by sales_date) as pre_day_sales
from daily_sales;

select *,
      lag(sales_amount, 2) over(order by sales_date) as pre_day_sales
from daily_sales;

-- Syntax Lag(col_name, step, defaultvalue) same for Lead
select *,
      lag(sales_amount, 2, 0) over(order by sales_date) as pre_day_sales
from daily_sales;

# we can use this to replace null with defualt value like 0
select *,
  coalesce(lag(sales_amount,1) over(order by sales_date), 0) as prev_sales
from daily_sales;


-- FRAME Clause
-- Frame: the subset of rows(frames) -- ROWS; RANGE

-- from upward/start [UNBOUNDED PRECEDING]; [N PRECEDING]; [CURRENT ROW]
-- from downward/end [UNBOUNDED FOLLOWING]; [N FOLLOWING]; [CURRENT ROW]

CREATE TABLE prd_mamaearth_sales(
	id INT,
    sales_date DATE,
    revenue DOUBLE
);

INSERT INTO prd_mamaearth_sales VALUES(1, '2021-01-02', 3451),
(5, '2021-03-01', 3214),
(2, '2021-04-01', 1147),
(3, '2021-09-10', 8556),
(6, '2021-01-07', 2324);

SELECT sales_date, revenue, SUM(revenue) OVER(ORDER BY sales_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) RunningTOTAL 
FROM prd_mamaearth_sales;
-- N PRECEDING
SELECT sales_date, revenue, SUM(revenue) OVER(ORDER BY sales_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) RunningTOTAL 
FROM prd_mamaearth_sales;

# Query - Calculate the differnce of sales with previous day sales
# Here null will be derived
select sales_date,
       sales_amount as curr_day_sales,
       lag(sales_amount, 1) over(order by sales_date) as prev_day_sales,
       sales_amount - lag(sales_amount, 1) over(order by sales_date) as sales_diff
from daily_sales;

# Here we can replace null with 0
select sales_date,
       sales_amount as curr_day_sales,
       lag(sales_amount, 1, 0) over(order by sales_date) as prev_day_sales,
       sales_amount - lag(sales_amount, 1, 0) over(order by sales_date) as sales_diff
from daily_sales;

# Diff between lead and lag
select *,
      lag(sales_amount, 1) over(order by sales_date) as pre_day_sales
from daily_sales;

select *,
      lead(sales_amount, 1) over(order by sales_date) as next_day_sales
from daily_sales;

create table employee(
  emp_id int,
  emp_name varchar(50),
  mobile BIGINT,
  dept_name varchar(50),
  salary int 
);

insert into employee values(1,'Shashank',778768768,'Software',1000);
insert into employee values(2,'Rahul',876778877,'IT',2000);
insert into employee values(3,'Amit',098798998,'HR',5000);
insert into employee values(4,'Nikhil',67766767,'IT',3000);

SELECT * FROM EMPLOYEE;
--- Create views in SQL
create view employee_data_for_finance as select emp_id, emp_name,salary from employee;

select * from employee_data_for_finance;

--- Create logic for department wise salary sum
create view department_wise_salary as select dept_name, sum(salary) from employees group by dept_name;

drop view department_wise_salary;

create view department_wise_salary as select dept_name, sum(salary) as total_salary from employees group by dept_name;

select * from department_wise_salary;

# How to use Frame Clause - Rows BETWEEN
select * from daily_sales;

select *,
      sum(sales_amount) over(order by sales_date rows between 1 preceding and 1 following) as prev_plus_next_sales_sum
from daily_sales;

select *,
      sum(sales_amount) over(order by sales_date rows between 1 preceding and current row) as prev_plus_next_sales_sum
from daily_sales;

select *,
      sum(sales_amount) over(order by sales_date rows between current row and 1 following) as prev_plus_next_sales_sum
from daily_sales;

select *,
      sum(sales_amount) over(order by sales_date rows between 2 preceding and 1 following) as prev_plus_next_sales_sum
from daily_sales;

select *,
      sum(sales_amount) over(order by sales_date rows between unbounded preceding and current row) as prev_plus_next_sales_sum
from daily_sales;

select *,
      sum(sales_amount) over(order by sales_date rows between current row and unbounded following) as prev_plus_next_sales_sum
from daily_sales;

select *,
      sum(sales_amount) over(order by sales_date rows between unbounded preceding and unbounded following) as prev_plus_next_sales_sum
from daily_sales;

# Alternate way to exclude computation of current row
select *,
      sum(sales_amount) over(order by sales_date rows between unbounded preceding and unbounded following) - sales_amount as prev_plus_next_sales_sum
from daily_sales;

# How to work with Range Between

select *,
      sum(sales_amount) over(order by sales_amount range between 100 preceding and 200 following) as prev_plus_next_sales_sum
from daily_sales;

# Calculate the running sum for a week
# Calculate the running sum for a month
insert into daily_sales values('2022-03-20',900);
insert into daily_sales values('2022-03-23',200);
insert into daily_sales values('2022-03-25',300);
insert into daily_sales values('2022-03-29',250);

select * from daily_sales;

select *,
       sum(sales_amount) over(order by sales_date range between interval '6' day preceding and current row) as running_weekly_sum
from daily_sales;

-- interval '7' for weekly data; '30' for monthly data; '365' for yearly data

-- common table expression CTE
create table amazon_employees(
    emp_id int,
    emp_name varchar(20),
    dept_id int,
    salary int
);

 insert into amazon_employees values(1,'Shashank', 100, 10000);
 insert into amazon_employees values(2,'Rahul', 100, 20000);
 insert into amazon_employees values(3,'Amit', 101, 15000);
 insert into amazon_employees values(4,'Mohit', 101, 17000);
 insert into amazon_employees values(5,'Nikhil', 102, 30000);
 
create table department
 (
    dept_id int,
    dept_name varchar(20) 
  );

insert into department values(100, 'Software');
insert into department values(101, 'HR');
insert into department values(102, 'IT');
insert into department values(103, 'Finance');

-- Write a query to print the name of department along with the total salary paid in each department
-- Normal approach
select d.dept_name, tmp.total_salary
from (select dept_id , sum(salary) as total_salary from amazon_employees group by dept_id) tmp
inner join department d on tmp.dept_id = d.dept_id;

-- how to do it using with clause?? (ITERATIVE)
with dept_wise_salary as (select dept_id , sum(salary) as total_salary from amazon_employees group by dept_id)
select d.dept_name, tmp.total_salary
from dept_wise_salary tmp
inner join department d on tmp.dept_id = d.dept_id;

-- CTE - ITERATIVE; RECURSIVE
-- (RECURSIVE)
WITH RECURSIVE numbers AS(
	SELECT 1 AS N
    UNION
    SELECT N+1 FROM numbers
    WHERE N<20
)
SELECT * FROM numbers;

create table emp_mgr
(
id int,
name varchar(50),
manager_id int,
designation varchar(50),
primary key (id)
);


insert into emp_mgr values(1,'Shripath',null,'CEO');
insert into emp_mgr values(2,'Satya',5,'SDE');
insert into emp_mgr values(3,'Jia',5,'DA');
insert into emp_mgr values(4,'David',5,'DS');
insert into emp_mgr values(5,'Michael',7,'Manager');
insert into emp_mgr values(6,'Arvind',7,'Architect');
insert into emp_mgr values(7,'Asha',1,'CTO');
insert into emp_mgr values(8,'Maryam',1,'Manager');

select * from emp_mgr;
with recursive emp_hir as  
(
   select id, name, manager_id, designation from emp_mgr where name='Asha'
   UNION
   select em.id, em.name, em.manager_id, em.designation from emp_hir eh inner join emp_mgr em on eh.id = em.manager_id
)
select * from emp_hir;

with recursive emp_hir as  
(
   select id, name, manager_id, designation, 1 as lvl from emp_mgr where name='Asha'
   UNION
   select em.id, em.name, em.manager_id, em.designation, eh.lvl + 1 as lvl from emp_hir eh inner join emp_mgr em on eh.id = em.manager_id
)
select * from emp_hir;

-- CLAUSES - IN; NOT IN; ANY; ALL; EXISTS; NOT EXISTS
SELECT salary FROM employee WHERE salary IN (SELECT MAX(salary) FROM employee);

SELECT salary FROM employee WHERE salary  NOT IN (SELECT MAX(salary) FROM employee);

CREATE TABLE Orders (
    OrderID INT,
    ProductID INT,
    ProductName VARCHAR(255),
    Quantity INT
);

INSERT INTO Orders VALUES 
(1, 101, 'Apple', 10),
(2, 102, 'Banana', 20),
(3, 103, 'Cherry', 30),
(4, 104, 'Date', 40),
(5, 105, 'Elderberry', 50);

SELECT * FROM Orders WHERE ProductName IN ('Apple', 'Banana');


SELECT * FROM Orders WHERE ProductName NOT IN ('Apple', 'Banana');

# Any Operation 


CREATE TABLE Students (
    StudentID INT,
    StudentName VARCHAR(50)
);

INSERT INTO Students VALUES 
(1, 'John'),
(2, 'Alice'),
(3, 'Bob');

CREATE TABLE Courses (
    CourseID INT,
    CourseName VARCHAR(50)
);

INSERT INTO Courses VALUES 
(100, 'Math'),
(101, 'English'),
(102, 'Science');

CREATE TABLE Enrollments (
    StudentID INT,
    CourseID INT
);

INSERT INTO Enrollments VALUES 
(1, 100),
(1, 101),
(2, 101),
(2, 102),
(3, 100),
(3, 102);


# Example: Let's find the students who are enrolled in any course taken by 'John':

SELECT DISTINCT s.StudentName
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.CourseID = ANY (
    SELECT e2.CourseID
    FROM Enrollments e2
    INNER JOIN Students s2 ON e2.StudentID = s2.StudentID
    WHERE s2.StudentName = 'John'
);


# All

CREATE TABLE Products (
    ProductID INT,
    ProductName VARCHAR(50),
    Price DECIMAL(5,2)
);

INSERT INTO Products VALUES 
(1, 'Apple', 1.20),
(2, 'Banana', 0.50),
(3, 'Cherry', 2.00),
(4, 'Date', 1.50),
(5, 'Elderberry', 3.00);


CREATE TABLE Orders (
    OrderID INT,
    ProductID INT,
    Quantity INT
);

INSERT INTO Orders VALUES 
(1001, 1, 10),
(1002, 2, 20),
(1003, 3, 30),
(1004, 1, 5),
(1005, 4, 25),
(1006, 5, 15);

# Now, suppose we want to find the products that have a price less than the price of all products ordered in order 1001:

SELECT p.ProductName
FROM Products p
WHERE p.Price < ALL (
    SELECT pr.Price
    FROM Products pr
    INNER JOIN Orders o ON pr.ProductID = o.ProductID
    WHERE o.OrderID = 1001
);

# EXISTS; NOT EXISTS
CREATE TABLE exists_customers (
    CustomerID INT,
    CustomerName VARCHAR(50)
);

INSERT INTO exists_customers VALUES 
(1, 'John Doe'),
(2, 'Alice Smith'),
(3, 'Bob Johnson'),
(4, 'Charlie Brown'),
(5, 'David Williams');

CREATE TABLE exists_orders (
    OrderID INT,
    CustomerID INT,
    OrderDate DATE
);

INSERT INTO exists_orders VALUES 
(1001, 1, '2023-01-01'),
(1002, 2, '2023-02-01'),
(1003, 1, '2023-03-01'),
(1004, 3, '2023-04-01'),
(1005, 5, '2023-05-01');
-- LETS FIND THE CUSTOMER WHO PLACED AT LEAST ONE ORDER
SELECT c.CustomerName
FROM exists_customers c
WHERE EXISTS (
    SELECT 1
    FROM exists_orders o
    WHERE o.CustomerID = c.CustomerID
);
-- LETS FIND THE CUSTOMER WHO HAVEN'T PLACED A ORDER
SELECT c.CustomerName
FROM exists_customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM exists_orders o
    WHERE o.CustomerID = c.CustomerID
);

SELECT o.*, c.* FROM exists_orders o 
RIGHT JOIN exists_customers c
ON o.CustomerID = c.CustomerID;

SELECT o.*, c.* FROM exists_orders o 
LEFT JOIN exists_customers c
ON o.CustomerID = c.CustomerID;