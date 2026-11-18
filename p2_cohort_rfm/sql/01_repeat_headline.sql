-- Q1. How many customers come back, and how much revenue do they bring?
WITH per_customer AS (
    SELECT customer_unique_id, COUNT(*) AS orders, SUM(order_value) AS revenue
    FROM customer_orders GROUP BY 1
)
SELECT COUNT(*)                                                              AS customers,
       ROUND(100.0*AVG(CASE WHEN orders > 1 THEN 1.0 ELSE 0 END),2)          AS repeat_customer_pct,
       ROUND(100.0*SUM(CASE WHEN orders > 1 THEN revenue END)/SUM(revenue),1) AS revenue_from_repeaters_pct,
       ROUND(SUM(revenue))                                                    AS total_revenue_brl,
       ROUND(AVG(revenue),1)                                                  AS avg_revenue_per_customer
FROM per_customer;
