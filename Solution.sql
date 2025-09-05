/*CUSTOMER REPORT: This report consolidates key customer metrics and behaviours.
Highlights:
1. Gather essential fields such as names, age and transaction details.
2. Segment customers into categories (VIP, Regular and age groups)
3. Aggregate customer_level metrics:
	- total orders
	- total sales
	- total quantity produced
	- total products
	- lifespan (in months)
4. Calculate valuable KPIs
	- recency (months since last order)
	- average order value
	- average monthly value spend*/

-- retrieving base query
WITH base_query AS (
SELECT 
f.order_number,
f.product_key,
f.quantity,
f.order_date,
c.customer_key,
c.customer_number,
CONCAT (first_name, ' ', last_name) full_name,
DATEDIFF (YEAR, birthdate, GETDATE()) Age,
f.sales_amount
FROM gold.dim_customers c
LEFT JOIN gold.fact_sales f
ON c.customer_key = f.customer_key
WHERE order_date IS NOT NULL
),
Customer_aggregation AS (
-- aggregation at customer-level metrics
SELECT 
customer_key,
customer_number,
full_name,
Age,
COUNT (order_number) total_orders,
SUM (sales_amount) total_sales,
SUM (quantity) total_quantity,
COUNT (DISTINCT product_key) total_product,
MAX (order_date) last_order_date,
MIN (order_date) first_order_date,
DATEDIFF (MONTH, MIN (order_date), MAX (order_date)) lifespan_in_months
FROM base_query
GROUP BY 
customer_key,
customer_number,
full_name,
Age
)
SELECT
customer_key,
customer_number,
full_name,
Age,
total_orders,
total_sales,
total_quantity,
total_product,
last_order_date,
first_order_date,
lifespan_in_months,
DATEDIFF (MONTH, last_order_date, GETDATE()) recency_by_month,
CASE WHEN total_sales = 0 THEN 'NULL'
	 ELSE total_sales / total_orders
	 END avg_order_value,
CASE WHEN total_sales = 0 THEN '0'
	 WHEN lifespan_in_months = 0 THEN '0'
	ELSE total_sales/lifespan_in_months
	END Avg_monthly_spend
FROM Customer_aggregation

/* PRODUCT REPORT
This report consolidates key product metrics and behaviours.
Highlights:
1. Gather essensial fields such as product name, category, sub_category and cost.
2. Segment products by revenue to identify high-performers, Mid-range and low-performers
3. Aggregate product-level metrics
	- total orders
	- total sales
	- total quantity sold
	- total customers (unique)
	- lifespan (in months)
4. Calculate valuable KPIs
	- Recency (months since last sales)
	- Average order revenue (AOR)
	- Average monthly revenue
*/

/* 1. Base query - Retrieves core colums from fact_sales and dim_products: p- product key, product name, category, sub-category,
cost, order date, sales amount, quantity,customer key, order number
2. Product aggregations: summarises key metrics at the product level
3. Final query: Combines all product results into one output
*/

-- Base query - Retrieves core colums from fact_sales and dim_products
WITH base_query 
-- Base query - Retrieves core colums from fact_sales and dim_products
AS ( 
SELECT
f.order_number,
f.customer_key,
f.order_date,
f.sales_amount,
f.quantity,
p.product_key,
p.product_name,
p.category,
p.subcategory,
p.cost
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE order_date IS NOT NULL
)
-- Product aggregations: summarises key metrics at the product level
, product_aggregation AS (
SELECT
product_key,
product_name,
category,
subcategory,
cost,
COUNT (order_number) total_orders,
SUM (sales_amount) total_sales,
SUM (quantity) total_quantity_purchased,
COUNT (product_key) total_products,
MAX (order_date) last_order_date,
DATEDIFF (MONTH, MIN (order_date), MAX (order_date)) lifespan_by_months
FROM base_query
GROUP BY product_key,
product_name,
category,
subcategory,
cost
)
-- Final query: Calculates valuable KPIs and Combines all product results into one output
SELECT 
product_key,
product_name,
category,
subcategory,
cost,
total_orders,
total_sales,
CASE WHEN total_sales BETWEEN 2430 AND 459438 THEN 'Low-Performer'
	 WHEN total_sales BETWEEN 916447 AND 1373454 THEN 'High_Performer'
	 ELSE 'Mid-Range'
	 END product_performance,
total_quantity_purchased,
total_products,
last_order_date,
lifespan_by_months,
DATEDIFF (MONTH, last_order_date, GETDATE()) recency_in_months,
CASE WHEN total_sales = 0 THEN 0
	 ELSE total_sales/total_orders
	 END avg_order_revenue,
CASE WHEN total_sales = 0 THEN 0
	 ELSE total_sales/lifespan_by_months
	 END avg_monthly_revenue
FROM product_aggregation