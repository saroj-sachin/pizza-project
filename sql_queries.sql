-- SQL Pizza Project
-- Datasets: pizzas, pizza_types, orders, order_details
-- Description: SQL queries to analyze pizza sales data


/* ==============================
   1. Total number of orders placed.
   ============================== */
SELECT COUNT(order_id) AS total_orders
FROM pizza.orders;


/* ==============================
   2. Total revenue generated from pizza sales.
   ============================== */
SELECT 
    ROUND(SUM(pizzas.price * order_details.quantity),2) AS total_sales
FROM
    pizzas
		JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id;


/* ==============================
   3. Highest priced pizza.
   ============================== */
SELECT 
	pizza_types.name, 
	pizzas.price
FROM 
	pizzas 
		JOIN 
	pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
ORDER BY pizzas.price DESC;


/* ==============================
   4. Most common pizza size ordered.
   ============================== */
SELECT 
	pizzas.size, 
	COUNT(order_details.order_details_id) AS "No. of times ordered" 
FROM 
	pizzas 
		JOIN 
	order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY size;


/* ==============================
   5. Top 5 most ordered pizza types along with their quantities.
   ============================== */
SELECT 
    pizza_types.name,
    SUM(order_details.quantity) AS quantities
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY SUM(order_details.quantity) DESC
LIMIT 5;


/* ==============================
   6. Total quantity of each pizza category ordered.
   ============================== */
SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS quantities
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category
ORDER BY SUM(order_details.quantity) DESC;


/* ==============================
   7. Distribution of orders by hour of the day.
   ============================== */
SELECT 
    HOUR(order_time) AS hours, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY (HOUR(order_time))
ORDER BY HOUR(order_time);


/* ==============================
   8. Category-wise distribution of pizzas.
   ============================== */
SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;


/* ==============================
   9. Average number of pizzas ordered per day.
   ============================== */
SELECT 
    ROUND(AVG(quantity)) AS avg_per_day
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS order_quantity; 

    
/* ==============================
   10. Most ordered pizza types based on revenue.
   ============================== */
SELECT 
    pizza_types.name,
    SUM(pizzas.price * order_details.quantity) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY Revenue DESC
LIMIT 5;


/* ==============================
   11. Percentage contribution of each pizza type to total revenue.
   ============================== */
SELECT 
    pizza_types.category,
    ROUND((SUM(pizzas.price * order_details.quantity) / (SELECT 
                    SUM(pizzas.price * order_details.quantity)
                FROM
                    pizzas
                        JOIN
                    order_details ON pizzas.pizza_id = order_details.pizza_id)) * 100,
            2) AS percentage
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category
ORDER BY percentage DESC;


/* ==============================
   12. Cumulative revenue generated over time in months.
   ============================== */
SELECT 
	MONTH(orders.order_date) AS months,
	ROUND(SUM(pizzas.price * order_details.quantity),2) AS revenue,
	ROUND(SUM(SUM(pizzas.price * order_details.quantity)) 
	OVER (ORDER BY MONTH(orders.order_date)),2) AS cumulative_revenue
FROM 
	pizzas
		JOIN 
	order_details ON pizzas.pizza_id = order_details.pizza_id
		JOIN 
	orders ON order_details.order_id = orders.order_id
GROUP BY MONTH(orders.order_date);


/* ==============================
   13. Top 3 most ordered pizza types based on revenue for each pizza category.
   ============================== */
WITH ranked_pizzas AS (
SELECT 
	pizza_types.category, 
	pizza_types.name,
	SUM(pizzas.price * order_details.quantity) AS revenue,
	RANK() OVER (PARTITION BY category ORDER BY SUM(pizzas.price * order_details.quantity) DESC) AS rk
FROM pizza_types
	JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
	JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY 
	pizza_types.category, 
    pizza_types.name
)

SELECT
	category,
    name,
    ROUND(revenue,2),
    rk
FROM ranked_pizzas
WHERE rk <= 3
ORDER BY category, revenue DESC;