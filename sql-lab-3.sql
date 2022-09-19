-- Lab | SQL - Lab 3.01
-- Activity 1
use sakila;
-- 1.Drop column picture from staff.
ALTER TABLE staff DROP COLUMN picture;  

-- 2.A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.
INSERT INTO staff
VALUES
(3,'Tammy','Sanders',4,'TAMMY.SANDERS@sakilacustomer.org',2,1,'Tammy',NULL,now());


-- 3.Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1.
--  You can use current date for the rental_date column in the rental table. 
-- Hint: Check the columns in the table rental and see what information you would need to add there.
-- You can query those pieces of information. 
-- For eg., you would notice that you need customer_id information as well. To get that you can use the following query:
-- select customer_id from sakila.customer
-- where first_name = 'CHARLOTTE' and last_name = 'HUNTER';
-- select * from rental;
-- select * from inventory;
-- select * from store;
-- select * from film;
-- select * from customer where first_name = 'Charlotte';
-- select * from staff where first_name = 'Mike' and last_name = 'Hillyer';

INSERT INTO rental(rental_date, inventory_id, customer_id, return_date, staff_id, last_update) 
VALUES(now(),1,130,null,1,now());



-- Lab | SQL Subqueries 3.03

-- 1.How many copies of the film Hunchback Impossible exist in the inventory system?
-- select title from film;
-- select * from film where title = "Hunchback Impossible";

-- select * from inventory where film_id = 439;


select count(inventory_id) as No_of_copies
from inventory as i
where exists (select * from film as f where title = "Hunchback Impossible" and i.film_id = f.film_id);

-- or 
 
select count(*) as No_of_Copies from(
select f.film_id, i.inventory_id from film f
join inventory i
using (film_id)
where f.title='Hunchback Impossible') sub1;

-- 2. List all films whose length is longer than the average of all the films.

-- select avg(length) from film;


SELECT film_id,length,title FROM film
WHERE length > (SELECT avg(length)
                FROM film);
-- 3.Use subqueries to display all actors who appear in the film Alone Trip.

-- select *  from film_actor where film_id = 17;
-- select * from actor where actor_id in (3,12,13,82,100,160,167,187);
-- select * from film where title = "alone Trip";


SELECT first_name, last_name
FROM actor
WHERE actor_id in
	(SELECT actor_id FROM film_actor
	WHERE film_id in 
		(SELECT film_id FROM film
		WHERE title = "Alone Trip"));


-- 4.Sales have been lagging among young families, and you wish to target all family movies for a promotion.
--  Identify all movies categorized as family films.

-- select * from category;
-- select * from film;
-- select * from film_category;

SELECT title FROM film
WHERE film_id in
	(SELECT film_id FROM film_category
	WHERE category_id in 
		(SELECT category_id FROM category
		WHERE name = "family"));


-- 5.Get name and email from customers from Canada using subqueries. 
-- Do the same with joins. Note that to create a join, you will have to identify the correct tables with 
-- their primary keys and foreign keys, 
-- that will help you get the relevant information.

-- select * from city;
-- select * from address;
-- select * from customer;
-- select * from country;

SELECT first_name, last_name, email FROM customer
WHERE address_id in
	(SELECT address_id FROM address
    WHERE city_id IN
    (SELECT city_id FROM city
    WHERE country_id IN
    (SELECT country_id FROM country
    WHERE country='CANADA')));

-- 6. Which are films starred by the most prolific actor? 
-- Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

-- SELECT actor_id, COUNT(film_id) FROM film_actor
-- GROUP by actor_id
-- ORDER by COUNT(film_id) DESC;

SELECT * FROM film
WHERE film_id IN (
SELECT film_id FROM film_actor
WHERE actor_id= '107');


-- 7.Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer
--  ie the customer that has made the largest sum of payments

-- SELECT customer_id, COUNT(payment_id) FROM payment
-- GROUP by customer_id
-- ORDER by COUNT(payment_id) DESC;

-- SELECT customer_id, SUM(amount) FROM payment
-- GROUP by customer_id
-- ORDER by SUM(amount) DESC
-- LIMIT 1; -- customer_id =526 is the most profitable

SELECT * FROM film
WHERE film_id IN (
SELECT film_id FROM inventory
WHERE inventory_id IN (
SELECT inventory_id FROM rental
WHERE customer_id='526'));

-- 8.Customers who spent more than the average payments.

-- select avg(amount) from payment;


SELECT * FROM customer
WHERE customer_id IN (
SELECT customer_id FROM payment
WHERE amount> (SELECT 
AVG(amount) FROM payment));

