/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
-- =============================================================================
-- Create Report: gold.report_products
-- =============================================================================

WITH BASE_QUERY AS(
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products
---------------------------------------------------------------------------*/
SELECT 
S.order_number
,S.order_date
,S.customer_key
,S.sales_amount
,S.quantity
,P.product_key
,P.product_name
,P.category
,P.subcategory
,P.cost
FROM DataWarehouseAnalytics.dbo.[gold.sales] S
LEFT JOIN DataWarehouseAnalytics.dbo.[gold.products] P
ON S.product_key=P.product_key
WHERE order_date IS NOT NULL
),
PRODUCT_AGGREGATION AS (
/*---------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
---------------------------------------------------------------------------*/
SELECT
product_key
,product_name
,category
,subcategory
,cost
,DATEDIFF(MONTH,MIN(ORDER_DATE),MAX(ORDER_DATE)) AS LIFESPAN
,MAX(ORDER_DATE) AS LAST_SALE_DATE
,COUNT(DISTINCT order_number) AS TOTAL_ORDERS
,COUNT(DISTINCT customer_key) AS TOTAL_CUSTOMERS
,SUM(sales_amount) AS TOTAL_SALES
,SUM(quantity) AS TOTAL_QUANTITY
,ROUND(AVG(CAST(sales_amount AS FLOAT)/NULLIF(quantity,0)),2) AS AVG_SELLING_PRICE

FROM BASE_QUERY
GROUP BY 
product_key
,product_name
,category
,subcategory
,cost
)
/*---------------------------------------------------------------------------
  3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/
SELECT 
product_key
,product_name
,category
,subcategory
,cost
,LIFESPAN
,LAST_SALE_DATE
,DATEDIFF(MONTH,LAST_SALE_DATE,GETDATE()) AS RECENCY_IN_MONTHS
,CASE WHEN TOTAL_SALES > 50000 THEN 'HIGH-PERFORMER'
      WHEN TOTAL_SALES >= 10000 THEN 'MID-RANGE'
      ELSE 'LOW-PERFORMER'
END AS PRODUCT_SEGMENT
,TOTAL_ORDERS
,TOTAL_CUSTOMERS
,TOTAL_SALES
,TOTAL_QUANTITY
,AVG_SELLING_PRICE
-- AVERAGE ORDER REVENUE
,CASE WHEN TOTAL_ORDERS = 0 THEN 0
      ELSE TOTAL_SALES/TOTAL_ORDERS
      END AS AVG_ORDER_REVENUE
-- AVERAGE MONTHLY REVENUE
,CASE WHEN LIFESPAN = 0 THEN TOTAL_SALES
      ELSE TOTAL_SALES/LIFESPAN
END AS AVG_MONTHLY_REVENUE
      
FROM PRODUCT_AGGREGATION