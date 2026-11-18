-- Q7. Business impact: do customers whose first order arrived late come back less?
WITH ranked AS (
    SELECT customer_unique_id, purchase_date, days_vs_estimate,
           ROW_NUMBER() OVER (PARTITION BY customer_unique_id ORDER BY purchase_date) AS n,
           COUNT(*)     OVER (PARTITION BY customer_unique_id)                         AS total_orders
    FROM delivered_orders
)
SELECT CASE WHEN days_vs_estimate > 0 THEN 'First order late' ELSE 'First order on time' END AS first_order,
       COUNT(*) AS customers,
       ROUND(100.0*AVG(CASE WHEN total_orders > 1 THEN 1.0 ELSE 0 END),2) AS repeat_rate_pct
FROM ranked WHERE n = 1 GROUP BY 1;
