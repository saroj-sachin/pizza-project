# Pizza Sales Analysis with SQL

<img src="/Screenshots/dashboard_screenshot.gif">

<img src="/Screenshots/dashboard_screenshot_3.gif" width="398.67" height="300">   <img src="/Screenshots/dashboard_screenshot_2.gif" width="398.67" height="300">

## Project Overview

This project analyzes pizza sales data using MySQL to extract meaningful business insights.

The goal is to understand customer behavior, sales trends, and popular menu items to help the business make data-driven decisions.

The final analysis is presented in an interactive dashboard created with Canva.

## Interactive Dashboard
[Canva Dashboard](https://www.canva.com/design/DAGyNLJ9g0Q/r0cKVohhyPxVUozguWXjRw/view?utm_content=DAGyNLJ9g0Q&utm_campaign=designshare&utm_medium=link2&utm_source=uniquelinks&utlId=hdb36d00342)

## Tools & Skills Used
- **SQL (MySQL)**: Data extraction and transformation
- **Canva**: Dashboard design and visualization
- **Git & GitHub**: Documentation and project sharing

## Dataset
The dataset consists of four CSV files:
- [**orders.csv**](/Datasets/orders.csv): Contains the date and time for each order placed.
- [**order_details.csv**](/Datasets/order_details.csv): Contains the specific pizzas and quantities for each order.
- [**pizzas.csv**](/Datasets/pizzas.csv): Contains the size and price for each unique pizza ID.
- [**pizza_types.csv**](/Datasets/pizza_types.csv): Contains the category and ingredients for each pizza type.

## Problem Statement & Objectives
The primary objective of this project was to answer key business questions by analyzing the sales data. The main questions addressed were:
1. What is the total number of orders and the total revenue generated?
2. What is the busiest time of day and day of the week for sales?
3. Which pizza sizes and categories are the most popular?
4. Which specific pizza types are the best-sellers by revenue and quantity?
5. How does revenue accumulate over the months?
6. What is the percentage contribution of each pizza category to the total revenue?

## SQL Concepts Applied
This project utilized a wide range of SQL concepts, from basic queries to advanced analytical functions, to extract and analyze the data.

### Basic SQL Queries
- **Aggregate Functions**: `COUNT()` to get the total number of orders, `SUM()` to calculate total revenue, and `MAX()` to find the highest-priced pizza.
- `GROUP BY`: Used extensively to group data for analysis, such as calculating orders by hour, day, or pizza category.
- `ORDER BY`: Used to rank results, such as finding the most and least ordered pizza sizes.

### Intermediate SQL Queries
- `JOIN`s: `INNER JOIN` and `LEFT JOIN` were used to combine data from the four different tables to create a comprehensive view for analysis (e.g., joining `orders` with `order_details` and `pizzas`).
- **Subqueries / Nested Queries**: Applied to perform multi-step calculations, such as finding the average number of pizzas ordered per day.
- **Common Table Expressions (CTEs)**: Used with the `WITH` clause to improve the readability and structure of complex queries, particularly for multi-level aggregations.

### Advanced SQL Queries
- **Window Functions**:
  - Used `SUM() OVER (ORDER BY ...)` to calculate the cumulative revenue over time (month by month).
  - Used ranking functions like `ROW_NUMBER()` or `RANK()` to determine the top 3 most ordered pizza types within each category based on revenue.
 
## Key Insights from the Analysis
- **Total Revenue**: The total revenue generated from all pizza sales was **$817,860.05**.
- **Total Orders**: A total of **21,350** orders were placed throughout the year.
- **Peak Hours**: The busiest times for orders are the lunch rush from **12 PM to 1 PM** and the dinner rush from **5 PM to 7 PM**.
- **Most Popular Size**: The **Large** size is the most frequently ordered pizza size.
- **Top 3 Pizza Types by Revenue**:
  1. The Thai Chicken Pizza
  2. The Barbecue Chicken Pizza
  3. The California Chicken Pizza
- **Category Contribution**: The **Classic** pizza category contributes the most to total revenue, accounting for **26.9%** of sales.

## SQL Queries
Each query is documented in the [sql_queries](sql_queries.sql) file.

Examples include:
### Total Revenue Generated
```sql
SELECT 
    ROUND(SUM(pizzas.price * order_details.quantity),2) AS total_sales
FROM
    pizzas
		JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id;
```

### Most Common Pizza Size Ordered
```sql
SELECT 
	pizzas.size, 
	COUNT(order_details.order_details_id) AS "No. of times ordered" 
FROM 
	pizzas 
		JOIN 
	order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY size;
```

### Distribution of orders by hour of the day
```sql
SELECT 
    HOUR(order_time) AS hours, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY (HOUR(order_time))
ORDER BY HOUR(order_time);
```

## How To Use
1. Clone the repo:
   ```
   git clone https://github.com/saroj-sachin/pizza-project.git
   ```
2. Import the dataset into MySQL
3. Run queries from [sql_queries](sql_queries.sql)
4. Explore insights and build a dashboard in a tool like Canva, Tableau, or Power BI.

## Acknowledgements
This project was created to practice SQL for business analytics and visualize the results in a simple dashboard format. It was inspired by the ["End-to-End SQL Project"](https://www.youtube.com/watch?v=zZpMvAedh_E) tutorial on YouTube. A huge thanks to the creator for providing the dataset and comprehensive guidance.
