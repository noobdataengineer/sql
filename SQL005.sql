USE noob_interview_questions;
-- remove the duplicate order pair from the table
CREATE TABLE number_pairs(
  A INT,
  B INT 
);

INSERT INTO number_pairs VALUES(1, 2), (2, 3), (3, 4), (2, 4), (5, 1), (2, 1), (4, 2), (1, 5);

SELECT n1.A, n1.B FROM number_pairs n1
LEFT JOIN number_pairs n2 ON n1.A=n2.B AND n1.B=n2.A 
WHERE n2.A IS NULL OR n1.A<n2.A;

SELECT n1.A, n1.B FROM number_pairs n1
WHERE NOT EXISTS (SELECT * FROM number_pairs n2 WHERE n1.A=n2.B AND n1.B=n2.A AND n1.A>n2.A);

-- NULL SAFE JOIN - Please do the inner join on the table A and table B
CREATE TABLE tableA(
	coln_A INT 
);

CREATE TABLE tableB(
	coln_B INT 
);

INSERT INTO tableA VALUES(1), (2), (2), (5), (NULL);
INSERT INTO tableB VALUES(2), (5), (5), (NULL), (NULL);

SELECT tableA.coln_A FROM tableA 
INNER JOIN tableB ON tableA.coln_A=tableB.coln_B;

SELECT tableA.coln_A FROM tableA 
INNER JOIN tableB ON tableA.coln_A<=>tableB.coln_B;

--
CREATE TABLE payments_data(
	trx_date DATE,
    merchant VARCHAR(10),
    amount INT,
    payment_mode VARCHAR(10)
    );
    
INSERT INTO payments_data VALUES('2022-02-04', 'M1', 150, 'CASH'),
('2022-02-04', 'M1', 500, 'ONLINE'),
('2022-02-03', 'M2', 450, 'ONLINE'),
('2022-02-03', 'M1', 150, 'CASH'),
('2022-02-03', 'M3', 600, 'CASH'),
('2022-02-05', 'M5', 200, 'ONLINE'),
('2022-02-05', 'M2', 100, 'ONLINE');

-- Write a SQL query to find the total amount received by each merchant by CASH & ONLINE mode
SELECT merchant, 
	SUM(CASE WHEN payment_mode='CASH' THEN amount ELSE 0
    END) AS 'cash_amount',
    SUM(CASE WHEN payment_mode='ONLINE' THEN amount ELSE 0
    END) AS 'online_amount'
FROM payments_data
GROUP BY merchant;