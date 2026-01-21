-- CHANGE OVER TIME
SELECT
YEAR(order_date) AS ORDER_YEAR, 
MONTH(order_date) AS ORDER_MONTH, 
SUM(sales_amount) AS TOTAL_SALES,
COUNT(DISTINCT customer_key) AS TOTAL_CUSTOMERS,
SUM(quantity) AS TOTAL_QUANTITY
FROM DataWarehouseAnalytics.dbo.[gold.sales]
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date)


SELECT
DATETRUNC(YEAR, order_date) AS ORDER_DATE,
SUM(sales_amount) AS TOTAL_SALES,
COUNT(DISTINCT customer_key) AS TOTAL_CUSTOMERS,
SUM(quantity) AS TOTAL_QUANTITY
FROM DataWarehouseAnalytics.dbo.[gold.sales]
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(YEAR, order_date)
ORDER BY DATETRUNC(YEAR, order_date)




