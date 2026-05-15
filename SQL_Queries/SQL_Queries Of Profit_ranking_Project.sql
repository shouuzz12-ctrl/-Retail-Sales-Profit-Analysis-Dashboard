CREATE TABLE Profit_Ranking(
Row_id INT PRIMARY KEY,
ORDER_id VARCHAR(20),
order_date date,
ship_date date,
ship_mode VARCHAR(50),
customer_id VARCHAR(50),
customer_name VARCHAR(100),
segment VARCHAR(50),
country VARCHAR(50),
city VARCHAR(50),
state VARCHAR(50),
postal_code VARCHAR(50),
region VARCHAR(50),
product_id VARCHAR(100),
category VARCHAR(50),
sub_category VARCHAR(50),
product_name VARCHAR(200),
sales NUMERIC,
quantity INT,
discount NUMERIC,
profit NUMERIC
);






1.	---Rank products by profit within each region.--
SELECT
    Product_Name,
    Region,
    Profit,
    RANK() OVER(
        PARTITION BY Region
        ORDER BY Profit DESC
    ) AS profit_rank
FROM profit_ranking;


2.---	Identify top 5 profitable products per region.---

WITH ranked_products AS (

    SELECT
        Product_Name,
        Region,
        Profit,

        RANK() OVER(
            PARTITION BY Region
            ORDER BY Profit DESC
        ) AS profit_rank

    FROM profit_ranking
)

SELECT *
FROM ranked_products
WHERE profit_rank <= 5;


---Categorize products based on profitability.--
SELECT
    Product_Name,
    Region,
    Profit,

    CASE
        WHEN Profit > 500 THEN 'High Profit'

        WHEN Profit BETWEEN 100 AND 500
        THEN 'Medium Profit'

        WHEN Profit > 0
        THEN 'Low Profit'

        ELSE 'Loss Making'
    END AS profit_category

FROM profit_ranking;



---Compare profit rankings using window functions.---
SELECT
    Product_Name,
    Region,
    Profit,

    ROW_NUMBER() OVER(
        PARTITION BY Region
        ORDER BY Profit DESC
    ) AS row_num,

    RANK() OVER(
        PARTITION BY Region
        ORDER BY Profit DESC
    ) AS rank_num,

    DENSE_RANK() OVER(
        PARTITION BY Region
        ORDER BY Profit DESC
    ) AS dense_rank_num

FROM profit_ranking;

-----USe AI to generate SQL Quieries---
SELECT category,
SUM(sales)
FROM profit_ranking
GROUP BY category;

---Validate AI-generated SQL logic.----







----Optimize AI-generated queries manually.---

SELECT category,
round( sum(sales),2)AS Total_sales
FROM profit_ranking
GROUP BY category
ORDER BY Total_sales DESC;


--Compare AI vs manually written SQL performance.--

---AI version
SELECT region,
SUM(profit)
FROM profit_ranking
GROUP BY region;
 ----no round ,alias,order by--
 
 ---Manualy version_
 SELECT region,

ROUND(SUM(profit), 2) AS total_profit

FROM profit_ranking

GROUP BY region

ORDER BY total_profit DESC;


---	Generate KPI tables for Power BI dashboards--
SELECT sum(sales)AS total_sales,
sum( profit)AS total_profit,
avg(discount)AS AVG_Discount,
count(DISTINCT order_id)AS total_orders,
count(DISTINCT customer_name)AS total_Customer
FROM profit_ranking;


----Create CTE-based summary queries.
WITH High_Sales AS (

SELECT region,

ROUND(SUM(profit), 2) AS total_profit

FROM profit_ranking

GROUP BY region

)

SELECT *

FROM High_Sales

ORDER BY total_profit DESC;

---	Export query results to CSV format.


---	Design queries optimized for BI tools.
SELECT category,

ROUND(SUM(profit), 2) AS total_profit,

ROUND(SUM(sales), 2) AS total_sales

FROM profit_ranking

GROUP BY category

ORDER BY total_profit DESC, total_sales DESC;



---which category have highest sales--
SELECT category,

ROUND(SUM(sales), 2) AS total_sales

FROM profit_ranking

GROUP BY category

ORDER BY total_sales DESC;


---What is the monthly sales trend
SELECT

EXTRACT(MONTH FROM order_date) AS monthly_trend,

ROUND(SUM(sales), 2) AS total_sales

FROM profit_ranking

GROUP BY monthly_trend

ORDER BY monthly_trend ASC;



---Top 10 customers sales--

SELECT customer_name,

ROUND(SUM(sales), 2) AS total_sales

FROM profit_ranking

GROUP BY customer_name

ORDER BY total_sales DESC

LIMIT 10;


---which Sub_category Causes losees
SELECT sub_category,

ROUND(SUM(profit), 2) AS total_profit

FROM profit_ranking

GROUP BY sub_category

ORDER BY total_profit ASC;

---Which category earns the most profit relative to sales? or highest profit margin category

SELECT category,

ROUND(SUM(profit), 2) AS total_profit,

ROUND(SUM(sales), 2) AS total_sales,

ROUND(
(SUM(profit) / SUM(sales)) * 100,
2
) AS profit_margin_percentage

FROM profit_ranking

GROUP BY category

ORDER BY profit_margin_percentage DESC;
--this show two sales and its porfit  and profit margin--

----which product has negative profit
SELECT product_name,

ROUND(SUM(profit), 2) AS total_profit

FROM profit_ranking

WHERE profit < 0

GROUP BY product_name

ORDER BY total_profit ASC;



