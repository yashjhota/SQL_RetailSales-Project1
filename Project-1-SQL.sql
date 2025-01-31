CREATE DATABASE RETAIL;
USE RETAIL;

DROP TABLE IF EXISTS Retail;

CREATE TABLE Retail (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(6),
    age INT,
    category VARCHAR(16),
    quantiy INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

SELECT * FROM retail LIMIT 100;

-- During importing data in MYSQL it will automatically Will remove NULL Values 
-- You can execute if using other database

-- Data Cleaning

SELECT 
    *
FROM
    retail
WHERE
    transactions_id IS NULL
        OR sale_date IS NULL
        OR sale_time IS NULL
        OR customer_id IS NULL
        OR gender IS NULL
        OR age IS NULL
        OR category IS NULL
        OR quantiy IS NULL
        OR price_per_unit IS NULL
        OR cogs IS NULL
        OR total_sale IS NULL;

-- Data Exploration

-- Number of sales  we have?

SELECT COUNT(*) AS TotalSale FROM retail;

-- How many customer as well?

SELECT DISTINCT (COUNT(customer_id)) AS TotalCust FROM retail;

-- list out Unique Categories ?

SELECT DISTINCT (category) AS Category FROM retail;

-- Data Analysis 

-- 1 Write a query to retrieve all columns for sales made on '2022-11-05'

SELECT * FROM retail
WHERE sale_date='2022-11-05';

-- 2 Write a Sql Query to retrieve all columns where category is clothing and quantity
--   sold is more than 3 in month of Nov-2022

SELECT * FROM retail
WHERE category = 'Clothing' 
AND quantiy > 3
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';


-- 3 What is the total quantity of "Clothing" items sold where the quantity per 
--   transaction was more than 3, between November 1 and November 30, 2022?

SELECT category,SUM(quantiy) AS Counts FROM retail
WHERE category = 'Clothing' 
AND quantiy > 3
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'
GROUP BY 1;

-- 4 Write the Query to Calculate the total sales for each Category

SELECT 
    category, SUM(total_sale) AS TotalSales
FROM
    retail
GROUP BY category;

-- 5 Write a SQL Query to find the Average of customers who purchased items
--   from the beatuy category.

SELECT ROUND(AVG(age),2) AS AvgAge
FROM retail
WHERE category='beauty'
GROUP By category;

-- 6 Write a SQL Query to find all transactions where the total Sales is greater
--  than 1000.

SELECT * FROM retail WHERE total_sale >1000;

-- 7 Write a SQL Query to find total no of transaction(NO OF ORDERS BASCIALLY) 
--   made by each gender in each category.

SELECT category,gender,COUNT(transactions_id)
FROM retail
GROUP BY 1,2; -- 1 MEANS category and 2 MEANS gender don't get confused

-- 8 Write a SQL Query to find average sale of each month and best selling month in each year

SELECT 
   *
FROM (
    SELECT 
        YEAR(sale_date) AS YEAR,
        MONTH(sale_date) AS MONTH,
        AVG(total_sale) AS AvgSale,
        RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rnk
    FROM retail
    GROUP BY YEAR, MONTH
) A
WHERE rnk = 1
ORDER BY YEAR;

-- Alternative using CTE

WITH YearMonthSales AS (
    SELECT 
        YEAR(sale_date) AS Year,
        MONTH(sale_date) AS Month,
        ROUND(AVG(total_sale), 2) AS AvgSale,
        ROW_NUMBER() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rnk
    FROM retail
    GROUP BY Year, Month
)
SELECT YEAR,MONTH,AvgSale
FROM YearMonthSales
WHERE rnk = 1;

-- 9 Write a Sql Query to find the top 5 Customers based on the highest total sales

SELECT customer_id,SUM(total_sale) Sales FROM retail  
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 10 Write a sql Query to find the number of unique customer who purchased item from each category

SELECT category,COUNT(DISTINCT customer_id) AS Unique_Cust
FROM retail
GROUP BY 1;

-- 11 Write a sql query to create each shift and number of orders 
-- Example mrng<12,afternoon 12-17 and eveing 	>17

WITH Hour_Sale AS(
SELECT *,CASE 
WHEN  HOUR(sale_time) < 12 THEN 'Morning'
WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END AS Shift
FROM retail) 

SELECT Shift, COUNT(*) As TotalOrders  FROM Hour_Sale GROUP BY Shift  ;