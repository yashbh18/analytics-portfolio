-- Q2. Like-for-like growth: Jan-Aug 2018 vs Jan-Aug 2017
SELECT SUBSTR(order_month,1,4) AS yr, COUNT(*) AS orders, ROUND(SUM(order_value)) AS gmv_brl,
       ROUND(SUM(order_value)/COUNT(*),1) AS aov_brl, COUNT(DISTINCT customer_unique_id) AS buyers
FROM customer_orders WHERE CAST(SUBSTR(order_month,6,2) AS INT) <= 8 AND order_month >= '2017-01'
GROUP BY 1 ORDER BY 1;
