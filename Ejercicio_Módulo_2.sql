USE Sakila; 

/* 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados. */

SELECT DISTINCT
    title AS Film_Titles
FROM
    film;

/* 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13". */

SELECT DISTINCT
    title AS Film_titles_rating_PG_13
FROM
    film
WHERE
    rating = 'PG-13';

/* 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en
su descripción. */

SELECT 
    title AS Film_Title,
    `description` AS Amazing_Films_Description
FROM
    film
WHERE
    `description` LIKE '%amazing%';

/* 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos. */

SELECT 
    title AS Film_Titles_over_120_long
FROM
    film
WHERE
    length > 120;

/* 5. Encuentra los nombres de todos los actores, muestralos en una sola columna que se llame
nombre_actor y contenga nombre y apellido. */

SELECT 
    CONCAT(first_name, ' ', last_name) AS Actor_Name
FROM
    actor;

/* 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido. */

SELECT 
    CONCAT(first_name, ' ', last_name) AS Actor_Last_Name_Gibson
FROM
    actor
WHERE
    last_name LIKE '%Gibson%';

/* 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20. */

SELECT 
    CONCAT(first_name, ' ', last_name) AS Actor_Name
FROM
    actor
WHERE
    actor_id BETWEEN 10 AND 20;

/* 8. Encuentra el título de las películas en la tabla film que no tengan clasificacion "R" ni "PG-13. */

SELECT 
    title AS Film_Title
FROM
    film
WHERE
    rating NOT IN ('R' , 'PG-13');

/* 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la
clasificación junto con el recuento. */

SELECT 
    rating AS Rating,
    COUNT(film_id) AS 'Number of films by rating'
FROM
    film
GROUP BY rating
ORDER BY COUNT(film_id) DESC;

/* 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su
nombre y apellido junto con la cantidad de películas alquiladas. */ 

-- WITHOUT CTE's

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS Total_Films_Rented
FROM
    customer c
        LEFT JOIN
    rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id
ORDER BY Total_Films_Rented DESC;

-- WITH CTE's

WITH customer_rentals AS (
	SELECT r.customer_id, 
        COUNT(r.rental_id) AS Total_Rentals
    FROM rental r
    GROUP BY r.customer_id)
SELECT 
c.customer_id,
c.first_name,
c.last_name,
cr.Total_Rentals
FROM customer c
LEFT JOIN customer_rentals cr
ON c.customer_id = cr.customer_id
ORDER BY cr.Total_Rentals DESC;

/*11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la
categoría junto con el recuento de alquileres. */

SELECT 
    c.name AS Name_Category,
    COUNT(r.rental_id) AS Total_Films_Rented
FROM
    category c
        INNER JOIN
    film_category fc ON c.category_id = fc.category_id
        INNER JOIN
    inventory i ON fc.film_id = i.film_id
        INNER JOIN
    rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY Total_Films_Rented DESC;

/*12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y
muestra la clasificación junto con el promedio de duración. */

SELECT 
    rating AS Film_Rating,
    AVG(length) AS Average_Length
FROM
    film
GROUP BY Film_Rating
ORDER BY Average_Length DESC;

/* 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love". */

-- WITH INNER JOIN

SELECT 
    a.first_name AS Actor_First_Name_Indian_Love,
    a.last_name AS Actor_Last_Name_Indian_Love
FROM
    actor a
        INNER JOIN
    film_actor fa ON a.actor_id = fa.actor_id
        INNER JOIN
    film f ON fa.film_id = f.film_id
WHERE
    f.title = 'Indian Love';

-- WITH SUBQUERY

SELECT 
    first_name AS Actor_First_Name_Indian_Love,
    last_name AS Actor_Last_Name_Indian_Love
FROM
    actor
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            film_actor
        WHERE
            film_id = (SELECT 
                    film_id
                FROM
                    film
                WHERE
                    title = 'Indian Love'));

/* 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción. */

-- WITH LIKE

SELECT 
    title AS Film_Title
FROM
    film
WHERE
    `description` LIKE '%dog%'
        OR `description` LIKE '%cat%';
        
-- WITH REGEXP

SELECT 
    title AS Film_Title
FROM
    film
WHERE
    `description` REGEXP 'dog|cat';
    
/* 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor. */

SELECT 
    a.actor_id, a.first_name, a.last_name
FROM
    actor a
        LEFT JOIN
    film_actor fa ON a.actor_id = fa.actor_id
WHERE
    fa.film_id IS NULL;

-- Respuesta: No, no hay ningún actor o actriz que no aparezca en ninguna película. Todos aparecen en al menos una película.

/* 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010. */

SELECT 
    title AS Film_Title
FROM
    film
WHERE
    release_year BETWEEN 2005 AND 2010;

/* 17. Encuentra el título de todas las películas que son de la misma categoría que "Family". */

-- WITH INNER JOIN

SELECT 
    f.title AS Family_Film
FROM
    film f
        INNER JOIN
    film_category fc ON f.film_id = fc.film_id
        INNER JOIN
    category c ON fc.category_id = c.category_id
WHERE
    c.name = 'family';

 -- WITH SUBQUERY
   
SELECT 
    title AS Family_Film
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film_category
        WHERE
            category_id = (SELECT 
                    category_id
                FROM
                    category
                WHERE
                    name = 'family'));
        
  /* 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas. */
  
  SELECT 
    a.first_name, a.last_name
FROM
    actor a
        INNER JOIN
    film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.first_name, a.last_name
HAVING COUNT(fa.film_id) > 10;
  
  /* 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la
tabla film. */

SELECT 
    title AS 'Film Title with rating R and over 120 long'
FROM
    film
WHERE
    rating = 'R' AND length > 120;

 /* 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120
minutos y muestra el nombre de la categoría junto con el promedio de duración. */

SELECT 
    c.name AS Category_Films, AVG(f.length) AS Average_length
FROM
    category c
        INNER JOIN
    film_category fc ON c.category_id = fc.category_id
        INNER JOIN
    film f ON fc.film_id = f.film_id
GROUP BY Category_Films
HAVING Average_length > 120
ORDER BY Average_length ASC;

/* 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor
junto con la cantidad de películas en las que han actuado. */

SELECT 
    CONCAT(a.first_name, ' ', a.last_name) AS Name_Actor,
    COUNT(fa.film_id) AS Total_Films
FROM
    actor a
        INNER JOIN
    film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING Total_Films >= 5
ORDER BY Total_Films DESC , Name_Actor ASC;

/* 22. Encuentra el título de todas las películas que fueron alquiladas durante más de 5 días. Utiliza una
subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona
las películas correspondientes. Pista: Usamos DATEDIFF para calcular la diferencia entre una
fecha y otra, ej: DATEDIFF(fecha_inicial, fecha_final). */

SELECT DISTINCT
    f.title AS 'Film titles with more than 5 days of rental'
FROM
    film f
        INNER JOIN
    inventory i ON f.film_id = i.film_id
WHERE
    inventory_id IN (SELECT 
            inventory_id
        FROM
            rental
        WHERE
            DATEDIFF(return_date, rental_date) > 5);
      
  /* 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la
categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en
películas de la categoría "Horror" y luego exclúyelos de la lista de actores. */

SELECT 
    CONCAT(first_name, ' ', last_name) AS 'Actors name without Horror Films'
FROM
    actor
WHERE
    actor_id NOT IN (SELECT 
            fa.actor_id
        FROM
            film_actor fa
                INNER JOIN
            film_category fc ON fa.film_id = fc.film_id
                INNER JOIN
            category c ON fc.category_id = c.category_id
        WHERE
            c.name = 'Horror');
    
/* 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180
minutos en la tabla film con subconsultas. */

SELECT 
    title
FROM
    film
WHERE
    length > 180
        AND film_id IN (SELECT 
            film_id
        FROM
            film_category
        WHERE
            category_id = (SELECT 
                    category_id
                FROM
                    category
                WHERE
                    `name` = 'Comedy'));

/* 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La
consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que
han actuado juntos. Pista: Podemos hacer un JOIN de una tabla consigo misma, poniendole un
alias diferente. */

SELECT 
    CONCAT(a.first_name, ' ', a.last_name) AS Name_ActorA,
    CONCAT(b.first_name, ' ', b.last_name) AS Name_ActorB,
    COUNT(faa.film_id) AS Films_Together
FROM
    actor a
        INNER JOIN
    film_actor faa ON a.actor_id = faa.actor_id
        INNER JOIN
    film_actor fab ON faa.film_id = fab.film_id
        INNER JOIN
    actor b ON b.actor_id = fab.actor_id
WHERE
    a.actor_id < b.actor_id
GROUP BY a.actor_id , b.actor_id
ORDER BY Films_Together DESC;

 
-- Executing queries on tables

SELECT *
FROM film;
SELECT *
FROM category;
SELECT *
FROM film_category;
SELECT *
FROM customer;
SELECT *
FROM rental;
SELECT *
FROM inventory;
SELECT *
FROM payment;
SELECT *
FROM film_actor;
SELECT *
FROM actor;




