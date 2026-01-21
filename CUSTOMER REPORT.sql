<<<<<<< HEAD
/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================
use DataWarehouseAnalytics;
GO

CREATE VIEW dbo.report_customers AS
WITH BASE_QUERY AS
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
(
SELECT 
S.order_number
,S.product_key
,S.order_date
,S.sales_amount
,S.quantity
,C.customer_number
,C.customer_key
,C.first_name
,C.last_name
, CONCAT(C.first_name,' ',C.last_name) AS CUSTOMER_NAME
,DATEDIFF(YEAR,C.birthdate,GETDATE()) AS AGE
FROM DataWarehouseAnalytics.dbo.[gold.sales] S
LEFT JOIN DataWarehouseAnalytics.dbo.[gold.customers] C
ON S.customer_key=C.customer_key
WHERE order_date IS NOT NULL
)
, CUSTOMER_AGGREGATION AS (
/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
SELECT 
customer_number
,customer_key
,CUSTOMER_NAME
,AGE
,COUNT(DISTINCT order_number) AS TOTAL_ORDERS
,SUM(sales_amount) AS TOTAL_SALES
,SUM(quantity) AS TOTAL_QUANTITY
,COUNT(DISTINCT product_key) AS TOTAL_PRODUCTS
,MAX(order_date) AS LAST_ORDER_DATE
,DATEDIFF(MONTH,MIN(ORDER_DATE),MAX(ORDER_DATE)) AS LIFESPAN
FROM BASE_QUERY
GROUP BY
customer_number
,customer_key
,CUSTOMER_NAME
,AGE
)
SELECT
customer_number
,customer_key
,CUSTOMER_NAME
,AGE
,CASE WHEN AGE < 20 THEN 'UNDER 20'
      WHEN AGE BETWEEN 20 AND 29 THEN '20-29'
      WHEN AGE BETWEEN 30 AND 39 THEN '30-39'
      WHEN AGE BETWEEN 40 AND 49 THEN '40-49'
      ELSE '50 AND ABOVE'
END AS AGE_GROUP
,CASE WHEN LIFESPAN >=12 AND TOTAL_SALES > 5000 THEN 'VIP'
     WHEN LIFESPAN >=12 AND TOTAL_SALES <= 5000 THEN 'REGULAR'
     ELSE 'NEW'
END AS CUSTOMER_SEGMENT
,TOTAL_ORDERS
,TOTAL_SALES
,TOTAL_QUANTITY
,TOTAL_PRODUCTS
,LAST_ORDER_DATE
,DATEDIFF(MONTH,LAST_ORDER_DATE,GETDATE()) AS RECENCY
,LIFESPAN
-- COMPUTE AVERAGE ORDER VALUE (AVO)
,CASE WHEN TOTAL_SALES = 0 THEN 0
      ELSE TOTAL_SALES/TOTAL_ORDERS
      END AS AVG_ORDER_VALUE

-- COMPUTE AVERAGE MONTHLY SPEND
,CASE WHEN LIFESPAN = 0 THEN TOTAL_SALES
      ELSE TOTAL_SALES/LIFESPAN
      END AS AVG_MONTHLY_SPEND
FROM CUSTOMER_AGGREGATION

=======
/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================
use DataWarehouseAnalytics;
GO

CREATE VIEW dbo.report_customers AS
WITH BASE_QUERY AS
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
(
SELECT 
S.order_number
,S.product_key
,S.order_date
,S.sales_amount
,S.quantity
,C.customer_number
,C.customer_key
,C.first_name
,C.last_name
, CONCAT(C.first_name,' ',C.last_name) AS CUSTOMER_NAME
,DATEDIFF(YEAR,C.birthdate,GETDATE()) AS AGE
FROM DataWarehouseAnalytics.dbo.[gold.sales] S
LEFT JOIN DataWarehouseAnalytics.dbo.[gold.customers] C
ON S.customer_key=C.customer_key
WHERE order_date IS NOT NULL
)
, CUSTOMER_AGGREGATION AS (
/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
SELECT 
customer_number
,customer_key
,CUSTOMER_NAME
,AGE
,COUNT(DISTINCT order_number) AS TOTAL_ORDERS
,SUM(sales_amount) AS TOTAL_SALES
,SUM(quantity) AS TOTAL_QUANTITY
,COUNT(DISTINCT product_key) AS TOTAL_PRODUCTS
,MAX(order_date) AS LAST_ORDER_DATE
,DATEDIFF(MONTH,MIN(ORDER_DATE),MAX(ORDER_DATE)) AS LIFESPAN
FROM BASE_QUERY
GROUP BY
customer_number
,customer_key
,CUSTOMER_NAME
,AGE
)
SELECT
customer_number
,customer_key
,CUSTOMER_NAME
,AGE
,CASE WHEN AGE < 20 THEN 'UNDER 20'
      WHEN AGE BETWEEN 20 AND 29 THEN '20-29'
      WHEN AGE BETWEEN 30 AND 39 THEN '30-39'
      WHEN AGE BETWEEN 40 AND 49 THEN '40-49'
      ELSE '50 AND ABOVE'
END AS AGE_GROUP
,CASE WHEN LIFESPAN >=12 AND TOTAL_SALES > 5000 THEN 'VIP'
     WHEN LIFESPAN >=12 AND TOTAL_SALES <= 5000 THEN 'REGULAR'
     ELSE 'NEW'
END AS CUSTOMER_SEGMENT
,TOTAL_ORDERS
,TOTAL_SALES
,TOTAL_QUANTITY
,TOTAL_PRODUCTS
,LAST_ORDER_DATE
,DATEDIFF(MONTH,LAST_ORDER_DATE,GETDATE()) AS RECENCY
,LIFESPAN
-- COMPUTE AVERAGE ORDER VALUE (AVO)
,CASE WHEN TOTAL_SALES = 0 THEN 0
      ELSE TOTAL_SALES/TOTAL_ORDERS
      END AS AVG_ORDER_VALUE

-- COMPUTE AVERAGE MONTHLY SPEND
,CASE WHEN LIFESPAN = 0 THEN TOTAL_SALES
      ELSE TOTAL_SALES/LIFESPAN
      END AS AVG_MONTHLY_SPEND
FROM CUSTOMER_AGGREGATION

>>>>>>> 5ba72aaa6e573711f502774dbe9f98f0ee4a32dc
