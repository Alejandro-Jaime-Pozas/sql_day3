--Please use the dvd_rental database from class to answer the 9 questions
--in the attached PDF. Once finished, please save your queries to a .sql file 
--and then commit and push to GitHub. Then upload your repository here

SELECT * FROM actor ;
SELECT * FROM address ;
SELECT * FROM category ;
SELECT * FROM city ;
SELECT * FROM country  ;
SELECT * FROM customer ;
SELECT * FROM film  ;
SELECT * FROM film_actor ;
SELECT * FROM film_category ;
SELECT * FROM inventory ;
SELECT * FROM language ;
SELECT * FROM payment ;
SELECT * FROM rental ;
SELECT * FROM staff  ;

--1. List all customers who live in Texas (use JOINs)
-- looking for a table w columns: customer_id, customer name/last name, district(texas)
-- use join fn, simple join or inner join is the same thing to get only intersection of tables
-- customer and address tables BOTH HAVE address_id in common, use that

--address_id OF customers who live IN Texas
--10		Dorothy	Taylor   vs Jennifer Davis
--310		
--567		
--122		
--405		

-- need to join address_id and district 'Texas' from table address to table customer col: customer_id, first name, last name
SELECT customer_id, first_name, last_name, address_id 
FROM customer c 
WHERE address_id IN (10, 310, 567, 122, 405);

SELECT district , address_id 
FROM address 
WHERE district ILIKE 'texas'
;

SELECT * FROM address ;
SELECT * FROM customer ORDER BY address_id ;

SELECT c.customer_id , c.address_id , a.address_id , first_name , last_name 
FROM customer c
JOIN address a
ON c.address_id  = a.address_id 
WHERE district ILIKE 'texas'
ORDER BY district DESC ;

-- ASK WHY IF I INPUT PRIMARY KEY/FOREIGN KEY PAIR WHY I STILL GET RESULTS BUT THE DATA IS WRONG...


--2. Get all payments above $6.99 with the Customer’s full name
--
SELECT customer_id , count(*) FROM payment GROUP BY customer_id ORDER BY count(*) DESC ;
SELECT * FROM payment ;
SELECT * FROM customer ;

SELECT c.customer_id, p.customer_id, first_name, last_name, amount
FROM payment p
JOIN customer c
ON p.customer_id  = c.customer_id 
WHERE amount > 6.99;



--3. Show all customer names who have made payments over $175 (use subqueries)
--
SELECT * FROM payment ;
SELECT * FROM customer ;


SELECT first_name, last_name
FROM customer c
WHERE customer_id IN (
	SELECT customer_id 
	FROM payment p 
	GROUP BY customer_id 
	HAVING sum(amount) > 175
	ORDER BY sum(amount) DESC
);


SELECT c.customer_id , first_name, last_name, sum(amount)
FROM payment p 
JOIN customer c 
ON p.customer_id = c.customer_id 
GROUP BY c.customer_id 
HAVING sum(amount) > 175
;


SELECT customer_id , sum(amount)
FROM payment p 
GROUP BY customer_id 
HAVING sum(amount) > 175
ORDER BY sum(amount) DESC


--4. List all customers that live in Argentina (use the city table)

--get customer_id
SELECT customer_id, first_name, last_name, address_id 
FROM customer c 
WHERE address_id IN (
	SELECT address_id
	FROM address a 
	WHERE city_id IN (
		SELECT city_id
		FROM city c 
		WHERE country_id = (
			SELECT country_id 
			FROM country 
			WHERE country = 'Argentina'
		)
	)
)
ORDER BY customer_id ;


--
SELECT * FROM city WHERE country_id = 6;
SELECT * FROM country WHERE country = 'Argentina' ;
SELECT * FROM city ;
SELECT * FROM country  ;
SELECT * FROM customer ;
SELECT * FROM address ;

-- city table has country_id/city_id, address table has city_id/address_id, customer table has address_id/customer_id

--get country_id
SELECT country_id 
FROM country 
WHERE country = 'Argentina' ; 
-- 6

-- get city_id
SELECT city_id
FROM city c 
WHERE country_id = 6;
--20
--43
--45
--128
--161
--165
--289
--334
--424
--454
--457
--524
--567

-- get address_id
SELECT address_id
FROM address a 
WHERE city_id IN (
	SELECT city_id
	FROM city c 
	WHERE country_id = (
		SELECT country_id 
		FROM country 
		WHERE country = 'Argentina'
	)
);
--28
--93
--111
--223
--247
--327
--336
--364
--410
--450
--536
--566
--591

--get customer_id
SELECT customer_id, first_name, last_name, address_id 
FROM customer c 
WHERE address_id IN (
	SELECT address_id
	FROM address a 
	WHERE city_id IN (
		SELECT city_id
		FROM city c 
		WHERE country_id = (
			SELECT country_id 
			FROM country 
			WHERE country = 'Argentina'
		)
	)
)
ORDER BY customer_id ;



--5. Which film category has the most movies in it (show with the count)?
--
SELECT *
FROM category c 
WHERE category_id = (
	SELECT category_id
	FROM film_category fc 
	GROUP BY category_id 
	ORDER BY count(*) DESC 
	LIMIT 1
);



--6. What film had the most actors in it (show film info)?
--
SELECT * FROM actor ;
SELECT * FROM film_actor ORDER BY film_id  DESC ;
SELECT * FROM film  ;

SELECT * 
FROM film f 
WHERE film_id = (
	SELECT film_id
	FROM film_actor fa 
	GROUP BY film_id
	ORDER BY count(*) DESC
	LIMIT 1
);

SELECT film_id
FROM film_actor fa 
GROUP BY film_id
ORDER BY count(*) DESC
LIMIT 1;



--7. Which actor has been in the least movies?
--
SELECT * FROM actor ;
SELECT * FROM film_actor ;
SELECT * FROM film  ;

SELECT *
FROM actor a 
WHERE actor_id = (
	SELECT actor_id 
	FROM film_actor 
	GROUP BY actor_id 
	ORDER BY count(*) 
	LIMIT 1
);

SELECT actor_id 
FROM film_actor 
GROUP BY actor_id 
ORDER BY count(*) 
LIMIT 1;


--8. Which country has the most cities?
--
SELECT * FROM city ;
SELECT * FROM country  ;

SELECT country
FROM country c 
WHERE country_id = (
	SELECT country_id 
	FROM city 
	GROUP BY country_id 
	ORDER BY count(*) DESC 
	LIMIT 1
);


SELECT country_id 
FROM city 
GROUP BY country_id 
ORDER BY count(*) DESC 
LIMIT 1;

--9. List the actors who have been in more than 3 films but less than 6.

SELECT * FROM actor ;
SELECT * FROM film_actor ;
SELECT * FROM film  ;

SELECT actor_id , count(*)
FROM film_actor 
GROUP BY actor_id 
ORDER BY count(*) 
LIMIT 1;
-- the actor with the fewest movies has 14 as shown above, so no actors bw 3 and 6 films exist....



