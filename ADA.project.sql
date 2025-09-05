/*	CHANGE OVER TIME
- Analyse the sales performance over time, Add total number of customers

	CUMMULATIVE ANALYSIS
- Calculate the total sales per month...
- ...and the running total for sales over time.

	PERFORMANCE ANALYSIS
- Analyse the yearly performance of products by comparing each product's sales to both its average sales performance
and the previous years' sales.

	PART-TO-WHOLE ANALYSIS
- Which category contributes the most to over all sales
- First step: find the total sales for each category.
- Next step: Sum up the total sale for each category to get the overall total.
- This is basically getting the whole in itself, where the sum of each category is typically a part of the whole.
- Next: Calculate the percentage

	DATA SEGMENTATION
- Segment products into cost ranges and count how many products fall into each segment
/* Group customers into three segments based on their spending behaviour:
- VIP: at least 12 months of history and spending more than $5000
- Regular: at least 12 months history and spending $5000 or less
- New: lifespan less than 12 months
... And find the total number of customers for each group

REPORTING:
CUSTOMER REPORT: This report consolidates key customer metrics and behaviours.
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
	- average monthly value spend

	PRODUCT REPORT
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