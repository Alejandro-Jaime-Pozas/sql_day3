SELECT * FROM actor;

SELECT * FROM film;

SELECT * FROM film_actor ;




-- Join the actor table to the film_actor table
SELECT *
FROM actor 
JOIN film_actor 
ON actor.actor_id = film_actor.actor_id ;


-- Join the film table to the film_actor table
SELECT *
FROM film 
JOIN film_actor 
ON film.film_id = film_actor.film_id 
ORDER BY film.film_id ;


-- MULTIPLE JOINS
-- Join the film table to actor table through film_actor
SELECT f.title, f.description, f.film_id, fa.film_id, fa.actor_id, a.actor_id , a.first_name, a.last_name -- you dont need fa... they ARE just TO SHOW relation
FROM film f 
JOIN film_actor fa 
ON f.film_id = fa.film_id 
JOIN actor a 
ON a.actor_id = fa.actor_id ;





-- SUBQUERIES**********

-- Which category has the most films in it 

SELECT * FROM film_category fc 
ORDER BY film_id ;

-- step 1. get the category_id of the category that has the most films associated with it
SELECT category_id, count(*) AS num_films
FROM film_category fc 
GROUP BY category_id 
ORDER BY num_films DESC 
;

SELECT category_id
FROM film_category fc 
GROUP BY category_id 
ORDER BY count(*) DESC 
LIMIT 1;
-- category 15 has the most

-- step 2. get the category from the category table using the id from step 1
SELECT *
FROM category c 
WHERE category_id = 15;
-- the category of Sports has the most films


-- combine the two steps into one subquery. the query you want to run first is the subquery
-- ***Subquery MUST return only ONE column*   *unless used in a FROM

SELECT *
FROM category c 
WHERE category_id = (
	SELECT category_id
	FROM film_category fc 
	GROUP BY category_id 
	ORDER BY count(*) DESC 
	LIMIT 1
);


-- Have a subquery return ONE column w MULTIPLE rows
-- list the categories that have more than 60 films in that category
SELECT category_id  --count(*)
FROM film_category fc 
GROUP BY category_id 
HAVING count(*) > 60
ORDER BY count(*) DESC ;


--15
--9
--8
--6
--2
--1
--13
--7
--14
--10

SELECT * 
FROM category 
WHERE category_id IN (15, 9, 8, 6, 2, 1, 13, 7, 14, 10);


-- IN ONE SUBQUERY
SELECT * 
FROM category 
WHERE category_id IN (
	SELECT category_id -- count(*)
	FROM film_category fc 
	GROUP BY category_id 
	HAVING count(*) > 60
	ORDER BY count(*) DESC
);



-- Use subquery for calculation

-- List all of the pmts that are more than the avg customer pay
SELECT avg(amount)
FROM payment p ;

SELECT *
FROM payment p 
WHERE amount > (
	SELECT avg(amount)
	FROM payment p 
);


-- subqueries w a FROM clause 
-- **subqueries w a FROM must have an alias, and can have multiple columns within subquery


-- List customers who have more rentals than the avg customer
SELECT *
FROM rental;

-- get the customer's rental counts
SELECT customer_id, count(*) AS num_rentals
FROM rental 
GROUP BY customer_id ;


-- find the avg rental number from the customer rental
SELECT avg(num_rentals)
FROM (
SELECT customer_id, count(*) AS num_rentals
FROM rental 
GROUP BY customer_id 
); -- ************gives errror bc NEED ALIAS WHEN useing subquery IN FROM clause 

SELECT avg(num_rentals)
FROM (
	SELECT customer_id, count(*) AS num_rentals
	FROM rental 
	GROUP BY customer_id 
) AS customer_rentals;


-- Find the customers by ID who have more rentals than the avg
SELECT customer_id
FROM rental r 
GROUP BY customer_id 
HAVING count(*) > (
	SELECT avg(num_rentals)
	FROM (
		SELECT customer_id, count(*) AS num_rentals
		FROM rental 
		GROUP BY customer_id 
	) AS customer_rentals
);


-- List the customers who have more rentals than the avg customer using customer IDs

SELECT * -- THIS QUERY GIVES YOU ALL COLUMNS FROM CUSTOMER TABLE
FROM customer c 
WHERE customer_id IN (
	SELECT customer_id -- THIS QUERY GIVES YOU COLUMN OF CUSTOMERS WHO HAVE RENTALS > AVG CUSTOMER RENTALS
	FROM rental r 
	GROUP BY customer_id 
	HAVING count(*) > (
		SELECT avg(num_rentals) -- THIS QUERY GIVES YOU AN AVG
		FROM ( -- THIS QUERY GIVES YOU A 2 COLUMN TABLE WITH rental count BY customer FOR ALL customers
			SELECT customer_id, count(*) AS num_rentals
			FROM rental 
			GROUP BY customer_id 
		) AS customer_rentals
)
);



-- Use subqueries in DML stmts
SELECT *
FROM customer;
-- create a column on customer called loyalty_member and set everyone to FALSE 
ALTER TABLE customer 
ADD COLUMN loyalty_member boolean DEFAULT FALSE;

SELECT * FROM customer;

-- set all customers who have made 25 or more rentals to be a loyalty_member

-- step 1. find all of the customers who have made more than 25 rentals

SELECT customer_id
FROM rental r 
GROUP BY customer_id 
HAVING count(*) > 25;


-- step 2. update the customer table to set loyalty_member = True if customer in list of  IDs
UPDATE customer 
SET loyalty_member = TRUE 
WHERE customer_id IN (
	SELECT customer_id 
	FROM rental 
	GROUP BY customer_id 
	HAVING count(*) > 25
);

SELECT first_name, last_name, loyalty_member
FROM customer c 
ORDER BY customer_id DESC ;




-- Joins and Subqueries
SELECT c.customer_id, first_name, last_name, rental_id, rental_date
FROM customer c 
JOIN rental r 
ON c.customer_id = r.customer_id 
WHERE c.customer_id IN (
	SELECT customer_id 
	FROM rental 
	GROUP BY customer_id 
	HAVING count(*) > 25
)
ORDER BY customer_id ;

SELECT * FROM customer c ;







