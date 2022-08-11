-- create a customer table 
CREATE TABLE customer(
	customer_id SERIAL PRIMARY KEY,
	first_name varchar(25), 
	last_name varchar(25),
	email varchar(25),
	address varchar(100),
	city varchar(30),
	state varchar(2),
	zipcode varchar(5)
);

SELECT * FROM customer;




-- create an order table
CREATE TABLE order_(
	order_id SERIAL PRIMARY KEY,
	order_date timestamp DEFAULT current_timestamp,
	amount numeric(5, 2),
	customer_id integer, -- this IS not NOT NULL bc customer_id can be zero OR many
	FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

SELECT * FROM order_;


-- alter customer email column to varchar(50)
ALTER TABLE customer 
ALTER COLUMN email TYPE varchar(50);




--DML - inserting data into the customer table
INSERT INTO customer(first_name, last_name, email, address, city, state, zipcode)
VALUES('George', 'Washington', 'firstpres@usa.gov', '3200 Mt. Vernon Way', 'Mt. Vernon', 'VA', '87522'),
('John', 'Adams', 'jadams@whitehouse.org', '1234 W Presidential Place', 'Quincy', 'MA', '43592'),
('Thomas', 'Jefferson', 'iwrotethedeclaration@freeamerica.org', '555 Independence Drive', 'Charleston', 'VA', '34532'),
('James', 'Madison', 'fatherofconstitution@prez.io', '8345 E Eastern Ave', 'Richmond', 'VA', '43538'),
('James', 'Monroe', 'jmonroe@usa.gov', '3682 N Monroe Parkway', 'Chicago', 'IL', '60623');

SELECT * FROM customer;




-- insert order data
INSERT INTO order_ (amount, customer_id)
VALUES (99.99, 1);

SELECT * FROM order_ ;



INSERT INTO order_ (amount, customer_id)
VALUES (33.54, 1);


INSERT INTO order_ (amount, customer_id)
VALUES (18.45, 1);


INSERT INTO order_ (amount, customer_id)
VALUES (62.38, 1);


INSERT INTO order_ (amount, customer_id)
VALUES (51.21, 1);


INSERT INTO order_ (amount, customer_id)
VALUES (43.34, 1);

SELECT * FROM order_ ;
SELECT * FROM customer ;



SELECT first_name, last_name, email
FROM customer 
WHERE customer_id = 1;

SELECT order_date, amount
FROM order_ 
WHERE customer_id = 1;


-- Join these two tables together using a join and common fields
--SELECT col1,  col2, etc (can be FROM either table)
--FROM table_name_1 (IS considered the LEFT table)
--JOIN table_name_2 (IS considered the RIGHT table)
--ON table_name_1.column_name = table_name_2.column_name (WHERE column_name IS a FOREIGN KEY TO the other column_name)

SELECT first_name, last_name, email, order_date, amount
FROM customer 
JOIN order_ -- JOIN and INNER JOIN ARE the same thing
ON customer.customer_id = order_.order_id ;

-- outer join
SELECT first_name, last_name, email, order_date, amount
FROM customer 
FULL JOIN order_ 
ON customer.customer_id = order_.customer_id ;

-- left join
SELECT *
FROM customer -- this is the LEFT TABLE bc it is mentioned FIRST
LEFT JOIN order_ -- RIGHT table
ON customer.customer_id = order_.customer_id  ;

-- right join
SELECT *
FROM customer -- this is the LEFT TABLE bc it is mentioned FIRST
RIGHT JOIN order_ -- RIGHT table
ON customer.customer_id = order_.customer_id  ;


--a LEFT JOIN w table_a FIRST will SHOW the same DATA AS a RIGHT JOIN w table_a second
SELECT *
FROM order_  -- this is the LEFT TABLE bc it is mentioned FIRST
LEFT JOIN customer  -- RIGHT table
ON customer.customer_id = order_.customer_id  ;

SELECT *
FROM customer  -- this is the LEFT TABLE bc it is mentioned FIRST
RIGHT JOIN order_  -- RIGHT table
ON customer.customer_id = order_.customer_id  ;




--joins WITH DQL
SELECT state, count(*)
FROM customer 
JOIN order_ 
ON customer.customer_id = order_.customer_id 
WHERE amount > 15 
GROUP BY state 
HAVING count(*) > 2;



-- Alias table names 
SELECT c.customer_id, c.first_name, c.last_name, o.amount
FROM customer c 
JOIN order_ o 
ON c.customer_id = o.customer_id ;









