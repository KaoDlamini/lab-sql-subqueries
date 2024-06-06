-- How many copies of the film Hunchback Impossible exist in the inventory system?
select title, count(film_id) from sakila.film
join sakila.inventory  using (film_id)
where title ='Hunchback Impossible'


-- List all films whose length is longer than the average of all the films.
select title,length from sakila.film
where length > ( select avg(length) from sakila.film)


-- Use subqueries to display all actors who appear in the film Alone Trip.
select first_name, last_name  from actor
where actor_id in 
	(select actor_id 
	from sakila.film_actor
	where film_id= (select film_id from film
				where title= 'Alone Trip'))

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select  title, rating from sakila.film
where rating = 'G'

-- Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.


select first_name, last_name, email from sakila.customer
where address_id in 
( select address_id from sakila.address
where city_id in (select city_id from sakila.city
where country_id in (select country_id from sakila.country 
where country='Canada')))


select first_name, last_name, email,country from sakila.customer
join sakila.address using (address_id)
join sakila.city using (city_id)
join sakila.country using (country_id)
where country= 'Canada'



-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
select distinct(film_id) from sakila.film_actor
where actor_id in (select actor_id from (
select actor_id from film_actor
group by actor_id
order by count(film_id) desc
limit 10) a)



-- Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
select inventory_id  from sakila.rental
where customer_id in (select customer_id from sakila.payment
group by customer_id
order by sum(amount) desc)
limit 10

-- Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
select customer_id, sum(amount) as t from sakila.payment
where amount > ( select avg(amount) from sakila.payment)
group by customer_id
