
-- =======================
	-- DATABASE
-- =======================

-- Create and use database 
CREATE DATABASE sales_analysis;

USE sales_analysis

-- View raw data
SELECT *
FROM sales_analysis.dbo.superstoreBI;


-- =======================
	-- DATA CLEANING
-- =======================

-- Volume
SELECT COUNT(*)
FROM sales_analysis.dbo.superstoreBI;


--Nulls in key fields
SELECT 'Order_ID' ,COUNT(*) NULLS
FROM sales_analysis.dbo.superstoreBI
WHERE Order_ID IS NULL
	UNION ALL
SELECT  'Order_Date', COUNT(*) 
FROM sales_analysis.dbo.superstoreBI
WHERE Order_Date IS NULL
	UNION ALL
SELECT 'Sales', COUNT(*)
FROM sales_analysis.dbo.superstoreBI
WHERE sales IS NULL
	UNION ALL
SELECT 'Quantity', COUNT(*)
FROM sales_analysis.dbo.superstoreBI
WHERE Quantity IS NULL;

--Potential Duplicates

SELECT Order_ID, Product_ID, COUNT(*) Duplicates
FROM sales_analysis.dbo.superstoreBI
GROUP BY Order_ID, Product_ID
HAVING COUNT(*) > 1;


--Deep diving duplicates (Real duplicates with exact rows)

SELECT Order_ID, Product_ID, COUNT(*) AS duplicates
FROM sales_analysis.dbo.superstoreBI
GROUP BY Order_ID, Product_ID, Order_Date, Ship_Date, Ship_Mode,
         Customer_ID, Customer_Name, Segment, Country, City, State,
         Postal_Code, Region, Category, Sub_Category, Product_Name,
         Sales, Quantity, Discount, Profit
HAVING COUNT(*) > 1;

--CTE without duplicates

WITH CleanSuperstoreBI AS (
SELECT *
FROM (
   SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY Order_ID, Product_ID, Order_Date, Ship_Date, Ship_Mode,
                         Customer_ID, Customer_Name, Segment, Country, City, State,
                         Postal_Code, Region, Category, Sub_Category, Product_Name,
                         Sales, Quantity, Discount, Profit
            ORDER BY (SELECT NULL)
        ) AS rn
    FROM sales_analysis.dbo.superstoreBI

) x

WHERE rn = 1
)
SELECT *
FROM CleanSuperstoreBI;


--Dates Validation 

WITH CleanSuperstoreBI AS (
SELECT *
FROM (
   SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY Order_ID, Product_ID, Order_Date, Ship_Date, Ship_Mode,
                         Customer_ID, Customer_Name, Segment, Country, City, State,
                         Postal_Code, Region, Category, Sub_Category, Product_Name,
                         Sales, Quantity, Discount, Profit
            ORDER BY (SELECT NULL)
        ) AS rn
    FROM sales_analysis.dbo.superstoreBI

) x

WHERE rn = 1
)

SELECT * 
FROM CleanSuperstoreBI
WHERE Ship_date < Order_Date;


--Sales & Quantity Validation 

WITH CleanSuperstoreBI AS (
SELECT *
FROM (
   SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY Order_ID, Product_ID, Order_Date, Ship_Date, Ship_Mode,
                         Customer_ID, Customer_Name, Segment, Country, City, State,
                         Postal_Code, Region, Category, Sub_Category, Product_Name,
                         Sales, Quantity, Discount, Profit
            ORDER BY (SELECT NULL)
        ) AS rn
    FROM sales_analysis.dbo.superstoreBI

) x

WHERE rn = 1
)

SELECT * 
FROM CleanSuperstoreBI
WHERE Sales < 0 or Quantity < 0;


--Discount distribution

WITH CleanSuperstoreBI AS (
SELECT *
FROM (
   SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY Order_ID, Product_ID, Order_Date, Ship_Date, Ship_Mode,
                         Customer_ID, Customer_Name, Segment, Country, City, State,
                         Postal_Code, Region, Category, Sub_Category, Product_Name,
                         Sales, Quantity, Discount, Profit
            ORDER BY (SELECT NULL)
        ) AS rn
    FROM sales_analysis.dbo.superstoreBI

) x

WHERE rn = 1
)

SELECT ROUND(Discount,3) Discount,COUNT(*) cnt
FROM CleanSuperstoreBI
GROUP BY Discount 
ORDER BY Discount DESC;

-- Create View based on data cleaned 

CREATE VIEW vw_CleanSuperstoreBI AS 
SELECT *
FROM (
   SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY Order_ID, Product_ID, Order_Date, Ship_Date, Ship_Mode,
                         Customer_ID, Customer_Name, Segment, Country, City, State,
                         Postal_Code, Region, Category, Sub_Category, Product_Name,
                         Sales, Quantity, Discount, Profit
            ORDER BY (SELECT NULL)
        ) AS rn
    FROM sales_analysis.dbo.superstoreBI

) x

WHERE rn = 1
AND Sales >=0
AND Ship_Date >=Order_Date
AND Quantity > 0;
 
 
	 SELECT * 
	 FROM vw_CleanSuperstoreBI;


 -- =======================
	-- KPI ANALYSIS
-- =======================


--											======= FINANCE AND PROFITABILITY========	

-- Basic Measures

SELECT ROUND(SUM(sales),2) AS Revenue
FROM vw_CleanSuperstoreBI

SELECT ROUND(SUM(Profit),2) AS Profit
FROM vw_CleanSuperstoreBI

SELECT ROUND(100*SUM(Profit)/NULLIF(SUM(sales),0),2) AS Profit_Margin
FROM vw_CleanSuperstoreBI

SELECT SUM(Quantity) AS Qty 
FROM vw_CleanSuperstoreBI

SELECT COUNT(DISTINCT(Order_ID)) AS Orders
FROM vw_CleanSuperstoreBI



-- 2) Distinct Ship Mode,Customer Segment, State, Category & Sub_category

SELECT DISTINCT Ship_Mode
FROM vw_CleanSuperstoreBI;

SELECT DISTINCT Segment asCustomer_Segment
FROM vw_CleanSuperstoreBI;

SELECT DISTINCT State
FROM vw_CleanSuperstoreBI;

SELECT DISTINCT Category
FROM vw_CleanSuperstoreBI;

SELECT DISTINCT Sub_Category
FROM vw_CleanSuperstoreBI;

-- 3) Revenue, Profit & Profit Margin by Ship Mode

SELECT 
	Ship_Mode,
	ROUND(SUM(sales),2) AS Revenue,
	ROUND(SUM(Profit),2) AS Profit,
	ROUND((SUM(Profit)/SUM(sales))*100,2) AS Profit_Margin

FROM vw_CleanSuperstoreBI
GROUP BY Ship_Mode
Order By Profit_Margin Desc;

-- 4) Revenue, Profit & Profit Margin by Customer Segment

SELECT 
	Segment ASCustomer_Segment,
	ROUND(SUM(sales),2) AS Revenue,
	ROUND(SUM(Profit),2) AS Profit,
	ROUND((SUM(Profit)/SUM(sales))*100,2) AS Profit_Margin
FROM vw_CleanSuperstoreBI
GROUP BY Segment
Order By Profit_Margin Desc;

-- 5) Revenue, Profit & Profit Margin by State

SELECT 
	State ,
	ROUND(SUM(sales),2) AS Revenue,
	ROUND(SUM(Profit),2) AS Profit,
	ROUND((SUM(Profit)/SUM(sales))*100,2) AS Profit_Margin

FROM vw_CleanSuperstoreBI
GROUP BY State
Order By Profit_Margin Desc, Profit DESC;

-- 6) Revenue, Profit & Profit Margin by Category

SELECT 
	Category,
	ROUND(SUM(sales),2) AS Revenue,
	ROUND(SUM(Profit),2) AS Profit,
	ROUND((SUM(Profit)/SUM(sales))*100,2) AS Profit_Margin

FROM vw_CleanSuperstoreBI

GROUP BY Category

Order By Profit_Margin Desc;


-- 7) Revenue, Profit & Profit Margin by Sub_category

SELECT 
	Sub_Category,
	ROUND(SUM(sales),2) AS Revenue,
	ROUND(SUM(Profit),2) AS Profit,
	ROUND((SUM(Profit)/SUM(sales))*100,2) AS Profit_Margin

FROM vw_CleanSuperstoreBI

GROUP BY Sub_Category

Order By Profit_Margin Desc;

-- 8) Revenue, Profit & Profit Margin by Month/Year

SELECT 
	YEAR(Order_Date) AS Year,
	MONTH(Order_Date) AS Month,
	ROUND(SUM(Sales),2) AS Revenue,
	ROUND(SUM(Profit),2) AS Profit,
	ROUND((SUM(Profit)/SUM(Sales))*100,2) AS Profit_Margin
FROM vw_CleanSuperstoreBI
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY YEAR(Order_Date), MONTH(Order_Date);

-- 9) Pareto Principle 80/20 - Subcategory

WITH Sub AS (SELECT 
	Sub_Category,
	CAST(SUM(Sales) AS DECIMAL(10,2))AS Revenue,
	CAST(SUM(Profit) AS DECIMAL (10,2)) AS Profit
FROM vw_CleanSuperstoreBI
GROUP BY Sub_Category)

SELECT 
	Sub_Category,
	Revenue,
	Profit,
	SUM(Profit) OVER(ORDER BY Profit DESC  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumul_Prof,
	SUM(Profit) OVER () AS Total_Profit,
	CAST(100* (SUM(Profit) OVER(ORDER BY Profit DESC  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / 
	NULLIF(SUM(Profit) OVER (), 0) )AS DECIMAL (5,2)) AS CumulPc,
	CASE
		WHEN CAST(100* (SUM(Profit) OVER(ORDER BY Profit DESC  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / 
			 SUM(Profit) OVER () )AS DECIMAL (5,2)) <= 80 THEN 'Top 80%'
		ELSE 'Rest'
	END AS 'Pareto Flag'
FROM Sub
ORDER BY Profit DESC;

--											======= DISCOUNTS ========


-- 1) Discount % vs. Margin — Where do discounts start to destroy margin?

SELECT *
FROM vw_CleanSuperstoreBI


WITH base AS (
SELECT	
	CAST(ROUND(Discount,2) AS DECIMAL(4,2)) AS Disc,
	Sales,
	Profit
	
FROM vw_CleanSuperstoreBI
) ,

base2 AS(

SELECT
	CASE
		WHEN Disc = 0 THEN '0%'
		WHEN Disc <= 0.10 THEN '0%-10%'
		WHEN Disc <= 0.15 THEN '10%-15%'
		WHEN Disc <= 0.20 THEN '15%-20%'
		WHEN Disc <= 0.30 THEN '20%-30%'
		WHEN Disc <= 0.40 THEN '30%-40%'
		WHEN Disc <= 0.50 THEN '40%-50%'
		WHEN Disc <= 0.60 THEN '50%-60%'
		WHEN Disc <= 0.70 THEN '60%-70%'
		WHEN Disc <= 0.80 THEN '70%-80%'
		ELSE '>80%'
		END AS Discount_Bands ,

	CASE
		WHEN Disc = 0 THEN 0
		WHEN Disc <= 0.10 THEN 1
		WHEN Disc <= 0.15 THEN 2
		WHEN Disc <= 0.20 THEN 3
		WHEN Disc <= 0.30 THEN 4
		WHEN Disc <= 0.40 THEN 5
		WHEN Disc <= 0.50 THEN 6
		WHEN Disc <= 0.60 THEN 7
		WHEN Disc <= 0.70 THEN 8
		WHEN Disc <= 0.80 THEN 9
		ELSE 10
		END AS Rank_Bands,

	Sales,
	Profit


FROM base

)

SELECT 
	Discount_Bands,
	Rank_Bands,
	COUNT(*) AS Qty,
	ROUND(SUM(Sales),2) AS Revenue,
	ROUND(SUM(Profit),2) AS Profit,
	ROUND(100* SUM(Profit)/NULLIF(SUM(Sales),0),2)AS Prof_Margin
FROM base2
GROUP BY Discount_Bands,Rank_Bands
ORDER BY Rank_Bands;



--												======= CUSTOMERS ========

-- 1)  Top 10 customers by Revenue and Profit

--Revenue 

SELECT 
	Customer_ID,
	Customer_Name,
	ROUND(SUM(Sales),2) AS Revenue
FROM vw_CleanSuperstoreBI
GROUP BY Customer_ID, Customer_Name
ORDER BY Revenue DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

--Profit

SELECT
	Customer_ID,
	Customer_Name,
	ROUND(SUM(Profit),2) AS Profit
FROM vw_CleanSuperstoreBI
GROUP BY Customer_ID,Customer_Name
ORDER BY Profit DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;


-- 2) Loss-Making Customers (Negative Profit or Margin)

SELECT 
	Customer_Name,
	ROUND(SUM(Sales),2) AS Revenue,
	ROUND(SUM(Profit),2) AS Profit,
	ROUND(100* SUM(Profit)/NULLIF(SUM(Sales),0),2) AS Profit_Margin
FROM vw_CleanSuperstoreBI
GROUP BY Customer_Name
HAVING SUM(Profit) < 0 OR SUM(Profit)/NULLIF(SUM(Sales),0) < 0 
ORDER BY Profit_Margin ASC;


-- 3) Basic Customer Lifetime Value (Revenue per customer)

SELECT
	 Customer_ID,
	 Customer_Name,
	 ROUND(SUM(Sales),2) AS Revenue,
	 ROUND(SUM(Profit),2) AS Profit
FROM vw_CleanSuperstoreBI
GROUP BY Customer_ID, Customer_Name
ORDER BY Revenue DESC


--												======= PRODUCTS ========


-- 1) Top 10 best-selling and most profitable products

SELECT TOP 10
	Product_Name,
	ROUND(SUM(Sales),2) AS Revenue,
	ROUND(SUM(Profit),2) AS Profit,
	SUM(Quantity) AS Total_Qty_Sold
FROM vw_CleanSuperstoreBI
GROUP BY Product_Name
ORDER BY SUM(Quantity) DESC


SELECT
	Product_Name,
	ROUND(SUM(Sales),2) AS Revenue,
	ROUND(SUM(Profit),2) AS Profit
FROM vw_CleanSuperstoreBI
GROUP BY Product_Name
ORDER BY Profit DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;




-- 2)  Products with high Revenue but negative Profit

SELECT 
	Product_ID,
	Product_Name,
	ROUND(SUM(Sales),2) AS Revenue,
	ROUND(SUM(Profit),2) AS Profit,
	SUM(Quantity) AS Total_Qty_Sold
FROM vw_CleanSuperstoreBI
GROUP BY Product_ID,Product_Name
HAVING ROUND(SUM(Profit),2) < 0 
ORDER BY Revenue DESC;



-- 3) ABC classification of products (A, B, C according to cumulative sales)

DECLARE @A DECIMAL(4,2) = 0.80
DECLARE @B DECIMAL(4,2) = 0.95;


WITH a AS (
SELECT
	Category,
	Product_ID,
	Product_Name,
	CAST(SUM(Sales) AS DECIMAL (8,2)) AS Revenue
FROM vw_CleanSuperstoreBI
GROUP BY Category,Product_ID,Product_Name
),
b AS(
SELECT
	a.*,
	SUM(Revenue) OVER( 
	PARTITION BY Category 
	ORDER BY Revenue DESC
	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumu_Revenue,
	SUM(Revenue) OVER(PARTITION BY Category) AS Total_Revenue

FROM a
)
SELECT 
	b.*,
	CAST(100 *(Cumu_Revenue/NULLIF(Total_Revenue,0)) AS DECIMAL(5,2)) AS Cum_Revenue_Pct,
	CASE
	WHEN Cumu_Revenue/NULLIF(Total_Revenue,0)  <= @A THEN 'A'
	WHEN Cumu_Revenue/NULLIF(Total_Revenue,0) <= @B THEN 'B'
	ELSE 'C'
	END AS ABC_Class

FROM b


--												======= REGIONS ========


-- 1)  Revenue, Profit, and Profit Margin by Region

SELECT
	Region,
	ROUND(SUM(Sales),2) AS Revenue,
	ROUND(SUM(Profit),2) AS Profit,
	ROUND(100* SUM(Profit) / NULLIF(SUM(Sales),0),2) AS Margin_Profit
FROM vw_CleanSuperstoreBI
GROUP BY Region
ORDER BY Margin_Profit DESC, Profit DESC;

-- 2) Top 5 States and Cities by profitability

SELECT TOP 5
	State,
	ROUND(SUM(Sales),2) AS Revenue,
	ROUND(SUM(Profit),2) AS Profit,
	ROUND(100* SUM(Profit) / NULLIF(SUM(Sales),0),2) AS Margin_Profit
FROM vw_CleanSuperstoreBI
GROUP BY State
ORDER BY SUM(Profit) DESC;


SELECT TOP 5
	City,
	ROUND(SUM(Sales),2) AS Revenue,
	ROUND(SUM(Profit),2) AS Profit,
	ROUND(100* SUM(Profit) / NULLIF(SUM(Sales),0),2) AS Margin_Profit
FROM vw_CleanSuperstoreBI
GROUP BY City
ORDER BY SUM(Profit) DESC;



-- 3) State/cities with negative margin
SELECT 
	State,
	ROUND(SUM(Sales),2) AS Revenue,
	ROUND(SUM(Profit),2) AS Profit,
	ROUND(100 * SUM(Profit)/NULLIF(SUM(Sales),0),2) AS Profit_Margin
FROM vw_CleanSuperstoreBI
GROUP BY State
HAVING 100 * SUM(Profit)/NULLIF(SUM(Sales),0) < 0
ORDER BY Profit_Margin ASC;

SELECT 
	City,
	ROUND(SUM(Sales),2) AS Revenue,
	ROUND(SUM(Profit),2) AS Profit,
	ROUND(100 * SUM(Profit)/NULLIF(SUM(Sales),0),2) AS Profit_Margin
FROM vw_CleanSuperstoreBI
GROUP BY City
HAVING 100 * SUM(Profit)/NULLIF(SUM(Sales),0) < 0
ORDER BY Profit_Margin ASC;


-- 4) Average shipping time by region and State
SELECT
	Region,
	AVG(DATEDIFF(DAY, Order_Date,Ship_Date)) AS Avg_Shipping_Time
FROM vw_CleanSuperstoreBI
GROUP BY Region
ORDER BY Avg_Shipping_Time DESC


SELECT
	State,
	AVG(DATEDIFF(DAY,Order_Date,Ship_Date)) AS Avg_Shipping_Time
FROM vw_CleanSuperstoreBI
GROUP BY State
ORDER BY Avg_Shipping_Time DESC
	


--												======= TIME/ TRENDS ========


-- 1) YoY (Year-over-Year) and MoM (Month-over-Month) growth of Revenue and Profit


With Monthly AS (
SELECT
	YEAR( Order_Date) AS Year,
	MONTH(Order_Date) AS Month,
	ROUND(SUM(Sales),2) AS Revenue,
	ROUND(SUM(Profit),2) AS Profit
FROM vw_CleanSuperstoreBI
GROUP BY YEAR(Order_Date),MONTH(Order_Date)
)

SELECT
	Year,
	Month,
	Revenue,
	Profit,
	LAG(Revenue) OVER(ORDER BY Year,Month) AS Prev_Month_Rev,
	LAG(Profit) OVER(ORDER BY Year,Month) AS Prev_Month_Prof,
	ROUND(100*(Revenue - LAG(Revenue) OVER(ORDER BY Year,Month)) / NULLIF(LAG(Revenue) OVER(ORDER BY Year,Month),0),2) AS Rev_MoM_Growth,
	ROUND(100*(Profit - LAG(Profit) OVER(ORDER BY Year,Month))/ NULLIF(LAG(Profit) OVER(ORDER BY Year,Month),0),2) AS Prof_MoM_Grouwth
FROM Monthly
ORDER BY Year,Month;




--2)  Seasonality analysis (months with sales peaks)

SELECT
	DATENAME(MONTH,Order_Date) AS Month_name,
	MONTH(Order_Date) AS Month_numb,
	ROUND(SUM(Sales),2) AS Total_Sales
FROM vw_CleanSuperstoreBI
GROUP BY DATENAME(MONTH,Order_Date),MONTH(Order_Date)
ORDER BY ROUND(SUM(Sales),2) DESC



--												======= OPERATIONS ========


--1)  Average shipping time (Ship_Date – Order_Date)

SELECT
	Ship_Mode,
	AVG(DATEDIFF(DAY,Order_Date,Ship_Date)) AS Avg_days
FROM vw_CleanSuperstoreBI
GROUP BY Ship_Mode
ORDER BY Avg_days DESC


-- 2) Orders with long delivery times 

SELECT
	  Order_ID,
	  Ship_Mode,
	  Region,
	  State,
	  DATEDIFF(DAY,Order_Date,Ship_Date) AS Shipping_Days,
	  COUNT(*) OVER(PARTITION BY State) AS Total_Delays_By_States
FROM vw_CleanSuperstoreBI
WHERE  DATEDIFF(DAY,Order_Date,Ship_Date) > 6
ORDER BY Total_Delays_By_States DESC
 



  