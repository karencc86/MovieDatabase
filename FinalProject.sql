-- 1 Muestre todas las películas disponibles que son catalogadas con rating de ‘PG’ o ‘PG-
13’, además que su duración de renta se encuentra entre 5 a 6, y su tamaño (largo) es
mayor a 180

SELECT 
    f.film_id, 
    f.title, 
    f.rating, 
    f.rental_duration, 
    f.length
FROM 
    film f
WHERE 
    f.rating IN ('PG', 'PG-13') 
    AND f.rental_duration BETWEEN 5 AND 6
    AND f.length > 180;

-- 2 Muestre un listado de todos los clientes con su Nombre, Apellido y correo electrónico,
que rentaron videos pero deben cumplir con: El Apellido es ‘Simpson’, el inventory_id
es 2580 o bien, 596, y la tienda donde se rentó es la 1.

SELECT 
    c.first_name,
    c.last_name,
    c.email,
    i.store_id,
    i.inventory_id
FROM 
    customer c
JOIN 
    rental r ON c.customer_id = r.customer_id
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    store s ON s.store_id = i.store_id
WHERE 
    c.last_name = 'Simpson'
    AND i.inventory_id IN (2580, 596)
    AND i.store_id = 1;



-- 3 Muestre un listado de todas las películas en habla ‘English’ y cuyo título de la película
contenga ‘Egg’ en algún lado.

SELECT 
    l.name, 
    f.title
FROM 
    film f
JOIN 
    language l ON f.language_id = l.language_id
WHERE 
    l.name = 'English' 
    AND f.title ILIKE '%Egg%';


-- 4 Muestre las películas cuyo actor tiene como nombre ‘Penelope’ , la película tiene
como tasa de renta 0.99 y un tamaño (length) de 175.

SELECT 
    f.title AS Titulo,
    f.rental_duration AS Duracion_Renta,
    f.rental_rate AS Tasa_Alquiler,
    a.first_name AS Nombre_Actor,
    a.last_name AS Apellido_Actor
FROM 
    film f
JOIN 
    film_actor fa ON f.film_id = fa.film_id
JOIN 
    actor a ON fa.actor_id = a.actor_id
WHERE 
    a.first_name = 'Penelope'
    AND f.rental_rate = 0.99
    AND f.length = 175;



-- 5 Muestre un listado de todos los países en donde se tiene presencia la empresa de
Alquiler de Videos. En el mismo listado debe aparecer la cantidad de clientes en
dicho país, y las ventas totales realizadas hasta el momento.

SELECT 
    co.country AS Pais,
    COUNT(c.customer_id) AS Cantidad_Clientes,
    SUM(p.amount) AS Ventas_Totales
FROM 
    country co
JOIN 
    city ci ON co.country_id = ci.country_id
JOIN 
    address a ON ci.city_id = a.city_id
JOIN 
    customer c ON a.address_id = c.address_id
JOIN 
    payment p ON c.customer_id = p.customer_id
GROUP BY 
    co.country
ORDER BY 
    Cantidad_Clientes DESC;

-- 6 Muestre la cantidad de películas se encuentran en la categoría de “Action”, “Comedy”
o “Family”. Imprima ACCION, COMEDIA o FAMILIAR y la cantidad de películas.

SELECT 
    CASE 
        WHEN c.name = 'Action' THEN 'ACCION'
        WHEN c.name = 'Comedy' THEN 'COMEDIA'
        WHEN c.name = 'Family' THEN 'FAMILIAR'
    END AS Categoria,
    COUNT(f.film_id) AS Cantidad_Peliculas
FROM 
    film_category fc
JOIN 
    category c ON fc.category_id = c.category_id
JOIN 
    film f ON fc.film_id = f.film_id
WHERE 
    c.name IN ('Action', 'Comedy', 'Family')
GROUP BY 
    c.name;

-- 7 Muestre cuantos clientes tiene por primer nombre ‘Grace’, además cuantas actrices
tiene como primer nombre ‘Susan’ y cuantos empleados (staff) tienen como primer
nombre ‘Mike’. Todo tiene que aparecer en una sola sentencia .

SELECT 
    first_name, 
    count, 
    CASE 
        WHEN first_name = 'Susan' THEN 'Susan, la actriz'
        WHEN first_name = 'Grace' THEN 'Grace, la Cliente'
        WHEN first_name = 'Mike' THEN 'Mike, el staff'
    END AS info
FROM (
    SELECT 'Susan' AS first_name, (SELECT COUNT(*) FROM actor WHERE first_name = 'Susan') AS count
    UNION ALL
    SELECT 'Grace' AS first_name, (SELECT COUNT(*) FROM customer WHERE first_name = 'Grace') AS count
    UNION ALL
    SELECT 'Mike' AS first_name, (SELECT COUNT(*) FROM staff WHERE first_name = 'Mike') AS count
) AS counts;

-- 8 Muestre un listado de todas las películas que han sido alquiladas entre las fechas 25 de
mayo del 2005 al 26 de mayo del 2005. De este listado, mostrar el número de boleta
de alquiler, la fecha de alquiler, el nombre y apellido de la persona empleada que lo
alquiló, el titulo y la descripción de la película


SELECT 
    r.rental_id AS Numero_Boleta,
    r.rental_date AS Fecha_Alquiler,
    s.first_name AS Nombre_Empleado,
    s.last_name AS Apellido_Empleado,
    f.title AS Titulo_Pelicula,
    f.description AS Descripcion_Pelicula
FROM 
    rental r
JOIN 
    staff s ON r.staff_id = s.staff_id
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film f ON i.film_id = f.film_id
WHERE 
    r.rental_date BETWEEN '2005-05-25' AND '2005-05-26';

-- 9 Muestre todas las películas en donde posee características especiales como escenas
borradas o Detrás de las escenas.

SELECT 
    title AS Titulo, 
    description AS Descripcion, 
    special_features AS Caracteristica
FROM film
WHERE 
     EXISTS(
	     SELECT
		 FROM unnest (special_features) AS feature
		 WHERE feature LIKE '%Deleted Scenes%'  
            OR feature LIKE '%Behind the Scenes%'
   );			


-- 10 Muestre todos los clientes que compraron en la tienda 1, y muestre el Nombre,
Apellido del cliente, y la última fecha en que alquiló algo en esa tienda.


SELECT 
    c.first_name AS Nombre_Cliente, 
    c.last_name AS Apellido_Cliente, 
    MAX(r.rental_date) AS Ultima_Fecha_Alquiler
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
WHERE i.store_id = 1
GROUP BY c.first_name, c.last_name
ORDER BY Ultima_Fecha_Alquiler DESC;



	






