-- SQL retail sales analysis p1
CREATE DATABASE sql_project_p2;

-- Create TABLE

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(
						transactions_id INTEGER PRIMARY KEY,
						sale_date DATE,
						sale_time TIME,
						customer_id INTEGER,
						gender VARCHAR(15),
						age INTEGER,
						category VARCHAR(15),
						quantiy INTEGER,
						price_per_unit FLOAT,
						cogs FLOAT,
						total_sale FLOAT
);

-- Data Cleaning

SELECT * FROM retail_sales;

SELECT COUNT(*) FROM retail_sales;

SELECT * FROM retail_sales
WHERE sale_date is NULL
OR customer_id is NULL
OR gender is NULL
OR age is NULL
OR category is NULL
OR quantiy is NULL
OR price_per_unit is NULL
OR cogs is NULL
OR total_sale is NULL;

DELETE FROM retail_sales
WHERE age is NULL
OR quantiy is NULL
OR price_per_unit is NULL
OR cogs is NULL
OR total_sale is NULL;

-- Data Exploration

-- How many sales we have

SELECT * FROM retail_sales

SELECT COUNT(*) AS No_of_totalsale
FROM retail_sales;

-- how many customers we have
SELECT COUNT(customer_id)
FROM retail_sales;

SELECT COUNT(DISTINCT(customer_id))
FROM retail_sales;

-- how many categories we have

SELECT COUNT(DISTINCT(category))
FROM retail_sales;

-- Data Analysis and Business key problems and answers

-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
-- Q3. Write a SQL query to calculate the total sales (total_sale) for each category
-- Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
-- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000
-- Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales
-- Q9.Write a SQL query to find the number of unique customers who purchased items from each category
-- Q10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
AND quantiy >= 4
ORDER BY sale_date;

-- Q3. Write a SQL query to calculate the total sales (total_sale) for each category

SELECT category,SUM(total_sale)
FROM retail_sales
GROUP BY category;

-- Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category

SELECT category,ROUND(AVG(age)) AS avg_age
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category;

-- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000

SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT category,gender,COUNT(transactions_id)
FROM retail_sales
GROUP BY category,gender
ORDER BY gender;

-- Q7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT * FROM
(SELECT
  EXTRACT(YEAR FROM sale_date) AS year,
  TO_CHAR(sale_date, 'Mon') AS month,
  AVG(total_sale) AS avg_sale,
  RANK() OVER(PARTITION BY(EXTRACT(YEAR FROM sale_date)) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY year,month)
WHERE rank = 1;

-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales

SELECT * FROM
(SELECT customer_id, SUM(total_sale) AS T_sale,
      RANK() OVER(ORDER BY (SUM(total_sale))DESC) AS rank
FROM retail_sales
GROUP BY customer_id) as t1
WHERE rank IN(1,2,3,4,5);

-- Q9.Write a SQL query to find the number of unique customers who purchased items from each category

SELECT category,COUNT(DISTINCT customer_id) AS unique_cstm
FROM retail_sales
GROUP BY category

-- Q10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale AS(
SELECT *,
CASE
    WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
END AS SHIFTS
FROM retail_sales)
SELECT SHIFTS, COUNT(*)
FROM hourly_sale
GROUP BY SHIFTS

-- END OF PROJECT












