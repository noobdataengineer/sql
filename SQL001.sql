--- Show all databases;
SHOW databases;
--- Create a new database
CREATE DATABASE noob_pratice_queries;
--- explaining sql to work on db;
USE noob_pratice_queries;
--- Creating table in the database
CREATE TABLE IF NOT EXISTS employees(
	ID INT,
    Firstname VARCHAR(20),
    Lastname VARCHAR(20),
    Salary DOUBLE,
    COUNTRYCODE VARCHAR(3),
    DOJ DATE);
   
--- view the tables in database
SHOW TABLES;

--- view the structue of table
SELECT * FROM employees;

--- Inserting values into the Tables;
INSERT INTO employees VALUES(103321, 'Arpit', 'Saxena', 1500, 'IND', '2016-03-12');
INSERT INTO employees VALUES(123321, 'Sudhir', 'Kumar', 1200, 'IND', '2020-03-08');
INSERT INTO employees VALUES(183343, 'Alysaa', 'Girald', 5000, 'USA', '2015-07-21');
INSERT INTO employees VALUES(183141, 'Justin', 'Wagner', 5100, 'USA', '2015-05-21');

INSERT INTO employees (ID, Firstname, Lastname, Salary) VALUES(143321, 'Binto', 'Davis', 7500);
INSERT INTO employees (ID, Firstname, Lastname, Salary) VALUES(163321, 'Abhay', 'Kumar', 9200);

--- Adding new columns into a existing table
ALTER TABLE employees ADD SEX VARCHAR(7);
ALTER TABLE employees ADD emailaddress VARCHAR(50);
ALTER TABLE employees ADD CONSTRAINT emailaddress UNIQUE (emailaddress), ADD CONSTRAINT ID PRIMARY KEY (ID);
--- INTEGRITY CONSTRAINT - check that date of joining must be less than current date
ALTER TABLE employees ADD CONSTRAINT CHECK (DOJ < CURRENT_DATE);

--- INTEGRITY CONSTRAINT
CREATE TABLE IF NOT EXISTS projects(
	ID INT PRIMARY KEY,
    Project VARCHAR(40),
    PROJECTCODE VARCHAR(3),
    ProjectDate DATE DEFAULT '2024-01-01',
    Duration INT,
    Stipend DOUBLE,
    skill VARCHAR(250),
    UNIQUE (PROJECTCODE),
    CHECK (Stipend > 500));



--- ADD VALUES FOR NEW COLUMN IN EXISTING TABLE AS PER THE SEQUENCE;
INSERT INTO employees (SEX) VALUES('Male'); --- WRONG CREATES A NEW RECORD
--- DELETE THE WRONGLY CREATED RECORD
DELETE FROM employees WHERE SEX='Male';
--- Error Code: 1175. --EDIT>>PREFERENCE>>UN-CHECK THE SAFE UPDATE MODE
--- CORRECT WAY TO UPDATE
UPDATE employees SET SEX='Male' WHERE Firstname='Arpit' OR Firstname='Vijay' OR Firstname='Viraj' OR Firstname='Sudhir'
OR Firstname='Aditya' OR Firstname='Binto' OR Firstname='Abhay' OR Firstname='Hiroshokki' OR Firstname='Justin';

UPDATE employees SET SEX='Female' WHERE Firstname='Alyssa' OR Firstname='Joyce' OR Firstname='Ru' OR Firstname='In' OR Firstname='Shraddha';

--- CORRECTION IN RECORD
UPDATE employees SET Firstname='Alyssa' WHERE Firstname='Alysaa';

--- DELETION OF COLUMN
ALTER TABLE employees DROP emailaddress; 

--- deletioN OF CONSTRAINT
ALTER TABLE employees DROP CONSTRAINT emailaddress;

--- RENAME OF COLUMN
ALTER TABLE employees RENAME COLUMN SEX TO Gender;

--- CREATION OF NEW TABLE
CREATE TABLE IF NOT EXISTS skill(
	EID INT,
    TECHNOLOGY VARCHAR(25));
    
SELECT * FROM skill ORDER BY EID;

INSERT INTO skill VALUES(103321, 'Agiloft'), (103321, 'SQL'), (123321, 'SQL'), (123321, 'Agiloft'), (123321, 'Python'), (123321, 'AWS');
INSERT INTO skill VALUES(183343, 'Python'), (183141, 'Python'), 
	(183343, 'SQL'), (183141, 'SQL'), 
    (183343, 'R'), (183141, 'MS-EXCEL'), 
    (183343, 'Power BI'), (183141, 'Tableau');
    
--- See Table Defination
SHOW CREATE TABLE skill;
    
--- RETURN THE NAME OF EMPLOYEES WITH ID HAVING PROFICIENCY IN Python, SQL, Power BI 
/*
SELECT ID, CONCAT(Firstname, ' ', Lastname) AS Fullname FROM employees;
SELECT EID FROM skill GROUP BY EID;

SELECT ID, CONCAT(Firstname, ' ', Lastname) AS Fullname FROM employees AS e
	INNER JOIN skill AS s
    ON s.EID=e.ID 
    WHERE 
	TECHNOLOGY='Python'; 
*/
    
--- RETURN THE PAGES IDs OF FACEBOOK PAGES CONDITION WITHOUT ANY LIKES IN ASCENDING ORDER
SELECT page_id FROM pages WHERE page_id NOT IN (SELECT DISTINCT(page_id) FROM pages_likes);

--- 2ND WAY
SELECT page_id FROM pages LEFT JOIN pages_likes AS p
	ON pages.page_id=p.page_id WHERE
    liked_date = NULL;
