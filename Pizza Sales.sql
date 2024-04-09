CREATE DATABASE IF NOT EXISTS pizzaDb;
USE pizzaDb;

CREATE TABLE pizzaSales(
	pizza_id INT PRIMARY KEY,
    order_id INT,
    pizza_name_id VARCHAR(50),
    quantity TINYINT,
    order_date DATE,
    order_time TIME,
    unit_price FLOAT,
    total_price FLOAT,
    pizza_size VARCHAR(50),
    pizza_category VARCHAR(50),
    pizza_ingredients VARCHAR(200),
    pizza_name VARCHAR(50)
);

ALTER TABLE pizzasales
MODIFY COLUMN order_date VARCHAR(50);

SET SQL_SAFE_UPDATES = 0;

-- UPDATE pizzasales
-- SET order_date = STR_TO_DATE(order_date, '%d-%m-%Y');

-- ALTER TABLE pizzasales
-- MODIFY COLUMN order_date DATE;

SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = true;

LOAD DATA LOCAL INFILE 'D:/Power BI/P3 Pizza Sales/pizza_sales.csv'
INTO TABLE pizzaSales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- KPI's Requirement

-- Total Revenue: sum of total price of all pizza orders
SELECT SUM(total_price) AS total_revenue
FROM pizzasales;

-- Average Order Value: total revenue / total orders
SELECT ROUND(SUM(total_price)/COUNT(DISTINCT order_id), 2)
AS avg_order_value
FROM pizzasales;

-- Total Pizzas Sold: sum of quantities of all pizzas sold
SELECT SUM(quantity) AS total_pizzas_sold
FROM pizzasales;

-- Total Orders: total orders placed
SELECT COUNT(DISTINCT order_id) AS total_orders_placed
FROM pizzasales;

-- Avg Pizzas Per Order: total pizzas sold / total orders
SELECT ROUND(SUM(quantity)/COUNT(DISTINCT order_id), 2)
AS avg_pizzas_per_order
FROM pizzasales;

-- 	Charts Requirement

-- Daily Trends For Orders
SELECT DAYNAME(order_date) AS order_day,
COUNT(DISTINCT order_id) AS total_orders
FROM pizzasales
GROUP BY order_day
ORDER BY CASE
          WHEN order_day = 'Sunday' THEN 1
          WHEN order_day = 'Monday' THEN 2
          WHEN order_day = 'Tuesday' THEN 3
          WHEN order_day = 'Wednesday' THEN 4
          WHEN order_day = 'Thursday' THEN 5
          WHEN order_day = 'Friday' THEN 6
          WHEN order_day = 'Saturday' THEN 7
     END ASC;

-- Monthly Trends For Orders
SELECT MONTHNAME(order_date) AS order_day,
COUNT(DISTINCT order_id) AS total_orders
FROM pizzasales
GROUP BY order_day
ORDER BY total_orders DESC;

-- Percentage Of Sales By Pizza Category
SELECT pizza_category,
ROUND(SUM(total_price)*100/(SELECT SUM(total_price) FROM pizzasales) ,2) AS percent_sales
FROM pizzasales
GROUP BY pizza_category
ORDER BY percent_sales DESC;

-- Percentage Of Sales By Pizza Size
SELECT pizza_size,
ROUND(SUM(total_price)*100/(SELECT SUM(total_price) FROM pizzasales) ,2) AS percent_sales
FROM pizzasales
GROUP BY pizza_size
ORDER BY percent_sales DESC;

-- Total Pizzas Sold By Pizza Category
SELECT pizza_category,
SUM(quantity) AS Total_sold
FROM pizzasales
GROUP BY pizza_category
ORDER BY Total_sold DESC;

-- Top 5 Best Sellers By Total Pizzas Sold
SELECT pizza_name,
SUM(total_price) AS total_revenue
FROM pizzasales
GROUP BY pizza_name
ORDER BY Total_revenue DESC
LIMIT 5;

-- Bottom 5 Best Sellers By Total Pizzas Sold
SELECT pizza_name,
SUM(total_price) AS total_revenue
FROM pizzasales
GROUP BY pizza_name
ORDER BY Total_revenue
LIMIT 5;

