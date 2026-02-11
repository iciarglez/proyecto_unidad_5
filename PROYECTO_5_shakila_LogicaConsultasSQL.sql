-- PROYECTO 5
-- DataProject: LógicaConsultasSQL

-- 1. Crea el esquema de la BBDD.

/* Para crear el esquema de BBDD, importamos el fichero de la práctica y lo ejecutamos. Al refrescar ("Renovar" shakila), ya aparecen las tablas.
 * Para ver el diagrama, la relación entre las tablas, vamos a shakila > Esquemas > public
 Botón derecho y seleccionamos View Diagram. Lo descargamos en formato png (adjunto)*/



-- 2. Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.

select title 
from film
where rating = 'R';


-- 3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.

select actor_id, concat(first_name, ' ', last_name)
from actor
where actor_id between 30 and 40;



-- 4. Obtén las películas cuyo idioma coincide con el idioma original.

select * 
from film
where language_id = original_language_id;

/* Todas las películas tienen en el campo idioma, 1 = Inglés, y el campo "original_language_id" está vacío.
 * Por tanto, la consulta sale vacía */

/* Comprobaciones */

select distinct(language_id)  from film f;
select distinct(original_language_id) from film f;

select * from language;


-- 5. Ordena las películas por duración de forma ascendente.

select film_id, length 
from film
order by length; -- por defecto se ordenan de forma ascendente, por eso no hace falta ASC


-- 6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.

select first_name, last_name
from actor
where last_name like '%ALLEN%'; -- pongo %ALLEN% porque supongo que quiere decir que contienen "ALLEN", aunque solo hay 3 con este apellido literal.


-- 7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento.

select rating, count(*)
from film
group by rating;


-- 8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.

select title, rating, length
from film
where rating = 'PG-13' or length > 180; -- seleccionamos aquellas que son PG-13 o que duran más de 3h (180min)


-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.

select variance(replacement_cost)
from film;


-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.

select max(length) as max_length, min(length) as min_length 
from film;


-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.

select r.rental_id, r.rental_date, p.amount from rental r
join payment p
on r.rental_id = p.rental_id
order by r.rental_date desc -- las ordenamos así para que sea más sencillo: la primera fila es el último, la segunda el penúltimo y la tercera el antepenúltimo.
limit 1 offset 2; -- seleccionamos una, después de omitir las dos primeras, esto es, escogemos la antepenúltima (porque recordemos que lo hemos ordenado al revés)


-- 12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC-17’ ni ‘G’ en cuanto a su clasificación.

select title, rating
from film f
where rating not in ('NC-17', 'G');


-- 13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

select rating, round(avg(length), 2) as "promedio_redondeado"
from film
group by rating;


-- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.

select title, length
from film
where length > 180; -- podríamos quitar la columna "length" del select, pero la dejamos para probar que son las que tienen duración mayor de 180min.


-- 15. ¿Cuánto dinero ha generado en total la empresa?

select sum(amount) as "ganancias"
from payment;


-- 16. Muestra los 10 clientes con mayor valor de id.

select * 
from customer c
order by customer_id desc -- ordenamos los clientes por el id de forma descendente y seleccionamos los 10 primeros (que por valor de id son los mayores)
limit 10; 


-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.

select a.first_name, a.last_name   
from film f
join film_actor fa 
on f.film_id = fa.film_id 
join actor a 
on fa.actor_id = a.actor_id 
where f.title = 'EGG IGBY'; -- lo ponemos en mayúsculas porque postgres distingue entre mayúsculas y minúsculas

-- Lo podemos comprobar ejecuntando las siguientes líneas (es más eficiente la consulta anterior con los join)
select film_id from film where title = 'EGG IGBY';
select * from film_actor where film_id = '274';
select first_name, last_name from actor where actor_id in ('20', '38', '50', '154', '162');


-- 18. Selecciona todos los nombres de las películas únicos.

select distinct(title) from film;


/* Vemos con la primera consulta que hay 1000 películas y con la segunda, que todas son únicas*/
select count(*) from film;
select count(distinct(title)) from film;



-- 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.

/* Analizamos cómo son las tablas que vamos a consultar, además de film (nos fijamos también en las relaciones entre tablas en el diagrama de la BBDD)*/
select * from category;
select * from film_category fc;


select f.title, f.length, fc.category_id  -- Obtenemos también las columnas de duración y el id de categoría para confirmar que es correcto el resultado 
from film f
join film_category fc 
on f.film_id = fc.film_id
where f.length > 180 and fc.category_id in (
	select category_id 
	from category c
	where name = 'Comedy');

-- Solo hay 3 películas con estas condiciones



-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.

select c.name, round(avg(f.length),2) as "promedio_duracion"  -- seleccionamos las columnas del nombre de las categorías y el promedio en la duración de las películas de esa categoría
from category c    -- vamos a hacer dos join para agregar a la tabla de categorías los datos de las películas, para poder agrupar y calcular el promedio de la duración
join film_category fc 
on fc.category_id = c.category_id
join film f
on f.film_id = fc.film_id
group by c.name -- agrupamos por categoría
having round(avg(f.length),2) > 110 -- filtramos con having porque estamos agregando (función AVG)
;


-- 21. ¿Cuál es la media de duración del alquiler de las películas?

select avg(r.return_date - r.rental_date) as duracion_media
from rental r;

/* El resultado no me convence, porque son 4 days 24:36:28.541706, lo que implica que son 5 días y pico.
 Intento mejorar la consulta */

select 
    round(avg(extract(epoch from (return_date - rental_date)) / 86400),3) as dias_promedio
from rental;

/* EXTRACT(EPOCH FROM intervalo) lo pasa a segundos, y diviendo entre 86400 lo pasamos a decimales
 * (86400 son los segundos que tiene un día)
 */



-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices.

select concat(first_name, ' ', last_name) as "nombre_completo"
from actor;


-- 23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.

select rental_date::date as dia, count(*) as total_alquiler  -- utilizamos "::date" para quedarnos con el día, sin tener en cuenta las horas
from rental
group by dia
order by total_alquiler desc;


-- 24. Encuentra las películas con una duración superior al promedio.

-- Usamos CTE para calcular la media solo una vez, por si tuviéramos que reutilizar el valor
with avg_length as (  
    select avg(length) as promedio_duracion
    from film
)
select film_id, title, length  -- Seleccionamos solo las columnas de interés, para que la consulta sea más eficiente
from film, avg_length
where film.length > avg_length.promedio_duracion;



-- 25. Averigua el número de alquileres registrados por mes.

select extract(month from rental_date) as mes, count(*) as total_alquileres -- utilizamos la función "EXTRACT" par obtener el mes de la fecha de alquiler
from rental
group by mes
order by mes;


-- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado.

select round(avg(amount),2) as promedio, round(stddev(amount),2) as destandar, round(variance(amount),2) as varianza 
from payment;


-- 27. ¿Qué películas se alquilan por encima del precio medio?

select f.film_id, f.title, p.amount 
from film f
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
join payment p on r.rental_id = p.rental_id
where p.amount > (select avg(amount) from payment)
order by p.amount asc;



-- 28. Muestra el id de los actores que hayan participado en más de 40 películas.

select fa.actor_id, count(film_id) as total_peliculas 
from film_actor fa 
group by fa.actor_id
having count(film_id) > 40;



-- 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.

select f.film_id, f.title, count(i.inventory_id) as cantidad_inventario
from film f 
left join inventory i on f.film_id = i.film_id 
group by f.film_id
order by cantidad_inventario desc; 

/* Con LEFT JOIN nos aseguramos que estén todas las películas, y con el conteo por group by vemos cuántas copias hay.
Incluso aparecen las que no tienen copias en el inventario, con un 0 en la columna "cantidad_inventario"
*/


-- 30. Obtener los actores y el número de películas en las que ha actuado.

select fa.actor_id, concat(a.first_name, ' ', a.last_name) as nombre_completo, count(film_id) as total_peliculas 
from film_actor fa 
join actor a 
on fa.actor_id = a.actor_id 
group by fa.actor_id, a.first_name, a.last_name; 

/* Añadimos a.first_name y a.last_name porque al usar GROUP BY y alguna función agrupada como es este caso con COUNT, 
 todas las columnas que no estén agregadas deben ir en el GROUP BY. */ 
 


-- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.

select f.film_id, f.title as titulo, concat(a.first_name, ' ', a.last_name) as actor 
from film f
left join film_actor fa on f.film_id = fa.film_id
left join actor a on fa.actor_id = a.actor_id
order by f.film_id, actor;

-- 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.

select concat(a.first_name, ' ', a.last_name) as actor, f.film_id, f.title as titulo  
from actor a
left join film_actor fa on a.actor_id = fa.actor_id
left join film f on fa.film_id = f.film_id
order by actor;


-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler.

select f.film_id, f.title as titulo, r.rental_id, r.rental_date, r.customer_id -- Seleccionamos las columnas más interesantes de la unión de las tablas film, inventory y rental
from film f
left join inventory i on f.film_id = i.film_id -- Hacemos LEFT JOIN para quedarnos con todos los datos, incluso si no tenemos inventario registrado o alquiler.
left join rental r on i.inventory_id = r.inventory_id
order by f.film_id, r.rental_date; -- Ordenamos los resultados de la consulta primero por el título de la película y después por fecha de alquiler




-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.

select c.customer_id, sum(p.amount) as total_cliente   
from customer c 
join payment p on c.customer_id = p.customer_id
group by c.customer_id
order by total_cliente desc   -- Ordenador de mayor gasto a menor, una vez agrupados, para quedarnos con los 5 que más gastan, que son los 5 primeros
limit 5;



-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.

select * from actor a 
where first_name = 'JOHNNY';



-- 36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.

select 
	first_name as "Nombre",
    last_name as "Apellido"
from actor;

/* Esto renombra las columnas de forma visual, la estructura de la tabla no cambia */

/* Si quisiéramos cambiar el nombre definitivamente, tendríamos que ejecutar un ALTER TABLE.
 * No lo hacemos porque afecta a todas las consultas futuras e incluso a las anteriores si volvemos a ejecutarlas.
 * 
 * alter table actor rename column first_name to nombre;
 * alter table actor rename column last_name to apellido;
 *  */



-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.

select 
min(actor_id) as id_minimo,
max(actor_id) as id_maximo
from actor;



--- 38. Cuenta cuántos actores hay en la tabla “actor”.

select count(actor_id) from actor;



--- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.

select * from actor
order by last_name; -- de forma predeterminada el orden en order by es ascendente, por eso no lo especificamos



--- 40. Selecciona las primeras 5 películas de la tabla “film”.

select * from film f 
limit 5;


-- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?

select first_name, count(*) total_actores from actor a 
group by first_name
order by total_actores desc; -- Además, ordenamos por el total de actores de forma descendente


-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.

select r.rental_id, r.rental_date, r.return_date, r.inventory_id, r.customer_id, c.first_name, c.last_name    -- seleccionamos las columnas más interesante para tener información de los alquiles y el nombre y apellido de cada cliente
from rental r 
join customer c on r.customer_id = c.customer_id;



-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.

select c.customer_id, c.first_name, c.last_name, r.rental_id, r.rental_date, r.return_date 
from customer c
left join rental r on c.customer_id = r.customer_id; -- como necesitamos incluir incluso aquellos clientes que no tienen alquileres, hacemos un LEFT JOIN


-- 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.

select f.title, c.name
from film f
cross join category c;

/*Esta consulta genera un producto cartesiano entre las tablas film y category.
 * Es decir, combina todas las películas con todas las categorías.
 * 
 * Esta consulta no tiene valor, porque lo que hace es cruzar todas las películas con todas las categorías, 
 * no refleja la relación real entre películas y categorías.
 * 
 * Lo realmente interesante sería saber en qué categoría está clasificada cada película.*/



-- 45. Encuentra los actores que han participado en películas de la categoría 'Action'.

select a.actor_id, concat(a.first_name, ' ', a.last_name) as actor, count(*) as total_peliculas_action
from actor a
join film_actor fa on a.actor_id = fa.actor_id
join film_category fc on fa.film_id = fc.film_id
join category c on fc.category_id = c.category_id
where c.name = 'Action'
group by a.actor_id, a.first_name, a.last_name
order by total_peliculas_action desc;


/*Hemos hecho joins para cruzar las tablas de actor y categoría.
 * Además, contamos cuántas películas ha hecho cada actor y ordenamos de más a menos películas,
 * para que el resultado de la consulta se pueda analizar de forma más clara.*/

/* Como el enunciado no pide contar las películas, podríamos hacerlo también con EXISTS */

select a.actor_id, concat(a.first_name, ' ', a.last_name) as actor
from actor a
where exists(
	select 1
	from film_actor fa 
	join film_category fc on fa.film_id = fc.film_id
	join category c on fc.category_id = c.category_id
	where fa.actor_id = a.actor_id and c.name = 'Action')

/* Al añadir en where la condición fa.actor_id = a.actor_id, la subconsulta filtra solo sus películas
 * y comprueba si hay alguna de acción. Si hay alguna, EXISTS devuelte TRUE y entonces se incluye. 
 * Si no hay, EXISTS devuelve FALSE y no incluye ese actor en el resultado.*/
	
	
	
-- 46. Encuentra todos los actores que no han participado en películas.
	

select a.actor_id, concat(a.first_name, ' ', a.last_name) as actor
from actor a
where not exists(
	select 1
	from film_actor fa 
	where fa.actor_id = a.actor_id);

/* La consulta no devuelve ningún actor, pero no se trata de un error. Significa que no hay ningún actor que no haya participado en películas*/


	
-- 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.

select concat(a.first_name, ' ', a.last_name) as actor, count(fa.film_id) as total_peliculas
from actor a
join film_actor fa on a.actor_id = fa.actor_id
group by a.actor_id, a.first_name, a.last_name
order by total_peliculas desc;
	
	

-- 48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.

create view actor_num_peliculas as   -- Creamos la vista, con el mismo contenido que el ejercicio anterior
select concat(a.first_name, ' ', a.last_name) as actor, count(fa.film_id) as total_peliculas
from actor a
join film_actor fa on a.actor_id = fa.actor_id
group by a.actor_id, a.first_name, a.last_name
order by total_peliculas desc;

select * from actor_num_peliculas; -- Consultamos la vista y vemos que obtenemos lo mismo que en la consulta anterior


-- 49. Calcula el número total de alquileres realizados por cada cliente.

select c.customer_id, concat(c.first_name, ' ', c.last_name) as cliente, count(r.rental_id) as total_alquileres -- si usáramos count(*) y hubiera clientes sin alquileres, los contaría también, daría 1 en lugar de null. Contando r.rental_id nos aseguramos de que cuente el verdadero alquiler.
from customer c 
left join rental r on c.customer_id = r.customer_id
group by c.customer_id, c.first_name, c.last_name
order by total_alquileres desc;

/* Hacemos un LEFT JOIN entre las tablas customer y rental.
Agrupamos por el customer_id y contabilizamos cuántos alquileres tiene cada uno.
Finalmente, ordenamos la salida de más alquileres a menos*/
 

-- 50. Calcula la duración total de las películas en la categoría 'Action'.

select sum(f.length) -- Filtramos después de hacer los dos joins por la categoría Action y a continuación, calculamos la duración total de estas películas
from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
where c.name = 'Action';



-- 51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.

create temporary table cliente_rentas_temporal as  -- Creamos la tabla temporal y añadimos la consulta del ejercicio 49 (el order by lo dejamos fuera, para la consulta con select)
select c.customer_id, concat(c.first_name, ' ', c.last_name) as cliente, count(r.rental_id) as total_alquileres 
from customer c 
left join rental r on c.customer_id = r.customer_id
group by c.customer_id, c.first_name, c.last_name;


select * from cliente_rentas_temporal
order by total_alquileres desc;




-- 52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.

create temporary table peliculas_alquiladas as (
select f.film_id, f.title, count(r.rental_id) as total_alquilada
from film f
left join inventory i on f.film_id = i.film_id
left join rental r on i.inventory_id = r.rental_id
group by f.film_id, f.title
having count(r.rental_id) > 10
);

select * from peliculas_alquiladas;

/*Al hacer esta consulta nos sale vacío. Comprobamos que no es un error de código
 Vemos en la consulta a continuación, sin poner la limitación de 10, que el máximo de alquileres de una película es 8, luego al pedir que sea > 10, no tenemos ninguna.
 Nuestra tabla temporal es correcta.*/

select f.film_id, f.title, count(r.rental_id) as total_alquilada
from film f
left join inventory i on f.film_id = i.film_id
left join rental r on i.inventory_id = r.rental_id
group by f.film_id, f.title
order by total_alquilada desc;


-- 53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.

select f.title
from film f
join inventory i on f.film_id = i.film_id -- Hacemos esta relación para saber qué copias existen
join rental r on i.inventory_id = r.inventory_id -- Esta relación para saber cuándo se alquilaron
join customer c on r.customer_id = c.customer_id
where c.first_name = 'TAMMY' and c.last_name = 'SANDERS'
	and r.return_date is null -- esta condición significa que la película aún no se ha devuelto
order by f.title;


-- 54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados alfabéticamente por apellido.

select concat(a.first_name, ' ', a.last_name) actor
from actor a 
where exists(
	select 1
	from film_actor fa
	join film_category fc on fa.film_id = fc.film_id
	join category c on fc.category_id = c.category_id
	where a.actor_id = fa.actor_id -- Ejecutamos la consulta para cada actor y evaluamos si cumple las condiciones de exists o no
		and c.name = 'Sci-Fi')
order by a.last_name, a.first_name;





-- 55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.

/* Usamos CTE para calcular la fecha del primer alquiler de la película 'Spartacus Cheaper'.*/

select distinct concat(a.first_name, ' ', a.last_name) nombre_actor
from actor a
join film_actor fa on a.actor_id = fa.actor_id
join film f on fa.film_id = f.film_id
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
where r.rental_date > 
	(select min(r2.rental_date)
	from rental r2
	join inventory i2 on r2.inventory_id = i2.inventory_id
	join film f2 on i2.film_id = f2.film_id
	where f2.title = 'SPARTACUS CHEAPER' -- 2005-08-21 08:40:21.000;
)
order by concat(a.first_name, ' ', a.last_name);


-- 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.

select concat(a.first_name, ' ', a.last_name) actor
from actor a 
where not exists( -- Aquí indicamos que si un actor está en alguna categoría Music, lo elimina
	select 1
	from film_actor fa
	join film_category fc on fa.film_id = fc.film_id
	join category c on fc.category_id = c.category_id
	where fa.actor_id = a.actor_id -- Ejecutamos la consulta para cada actor y evaluamos si cumple las condiciones de exists o no
		and c.name = 'Music')
order by a.first_name, a.last_name; -- En este caso, ordenamos por nombre y luego por el apellido


-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.

select f.title
from film f
where exists(
	select 1
	from rental r
	join inventory i on r.inventory_id = i.inventory_id
	where i.film_id = f.film_id
		and r.return_date is not null -- porque si es null y lo incluimos en la resta, no funcionará
		and (r.return_date - r.rental_date) > interval '8 days'
)
order by f.title;


-- 58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.

select f.title 
from film f
left join film_category fc on f.film_id = fc.film_id
left join category c on fc.category_id = c.category_id
where c.name = 'Animation';

/* Juntamos las 3 tablas que nos interesan y filtramos por la categoría "Animation" */


-- 59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. Ordena los resultados alfabéticamente por título de película.

select f.title
from film f
where f.length = (
	select f.length from film f
	where f.title = 'DANCING FEVER')
order by f.title;


-- Usamos CTE para calcular la duración solo una vez, por si tuviéramos que reutilizar el valor
with df_length as (  
    select length as duracion_df
    from film
    where title = 'DANCING FEVER'	
)
select f.film_id, f.title, f.length  -- Seleccionamos solo las columnas de interés, para que la consulta sea más eficiente
from film f
join df_length d on f.length = d.duracion_df
order by f.title;


-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.

select c.first_name, c.last_name, count(distinct(i.film_id)) total_alquiler   
from customer c
join rental r on c.customer_id = r.customer_id 
join inventory i on r.inventory_id = i.inventory_id
group by c.customer_id
having count(distinct(i.film_id)) >= 7
order by total_alquiler, c.first_name, c.last_name; 


/*En la consulta anterior, nos salen los 599 clientes. 
 Como me extraña, hago una comprobación a continuación, para ver cuántas películas diferentes alquila el cliente que menos alquila.
 Como son 12, que es mayor que 7, tiene sentido el resultado que hemos obtenido*/


select c.customer_id,
       count(distinct i.film_id) as total_peliculas
from customer c
join rental r on c.customer_id = r.customer_id 
join inventory i on r.inventory_id = i.inventory_id
group by c.customer_id
order by total_peliculas
limit 1;



-- 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

select c.name, count(r.inventory_id) as alquileres
from category c
join film_category fc on c.category_id = fc.category_id
join inventory i on fc.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
group by c.name
order by alquileres desc; -- hay distintas opciones de ordenación, también podríamos haberlo hecho por el nombre de la categoría



-- 62. Encuentra el número de películas por categoría estrenadas en 2006.

select c.name, count(f.film_id) as total_peliculas_2006
from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
where f.release_year = 2006
group by c.name
order by total_peliculas_2006 desc;

-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.

select staff.staff_id, concat(staff.first_name, ' ', staff.last_name) as nombre_empleado, store.store_id
from staff
cross join store;



-- 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

select c.customer_id, concat(c.first_name, ' ', c.last_name) as nombre, count(*) as total_alquileres
from customer c
left join rental r on c.customer_id = r.customer_id
group by c.customer_id, c.first_name, c.last_name
order by c.customer_id;


