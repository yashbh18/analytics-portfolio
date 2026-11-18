-- Q6. Opportunity sizing: revenue from reactivating 3% / 5% / 10% of at-risk high-value customers once
WITH snapshot AS (SELECT JULIANDAY(MAX(purchased_at)) + 1 AS snap FROM customer_orders),
rfm AS (SELECT customer_unique_id, (SELECT snap FROM snapshot) - JULIANDAY(MAX(purchased_at)) AS recency_days,
               COUNT(*) AS frequency, SUM(order_value) AS monetary FROM customer_orders GROUP BY 1),
scored AS (SELECT *, NTILE(5) OVER (ORDER BY recency_days DESC) AS r, NTILE(5) OVER (ORDER BY monetary) AS m FROM rfm),
at_risk AS (SELECT * FROM scored WHERE frequency = 1 AND r <= 3 AND m >= 4),
total AS (SELECT SUM(order_value) AS rev FROM customer_orders)
SELECT rate AS reactivation_rate, (SELECT COUNT(*) FROM at_risk) AS at_risk_customers,
       ROUND((SELECT COUNT(*) FROM at_risk) * rate * (SELECT AVG(monetary) FROM at_risk)) AS revenue_brl,
       ROUND(100.0*(SELECT COUNT(*) FROM at_risk) * rate * (SELECT AVG(monetary) FROM at_risk)/(SELECT rev FROM total),2) AS pct_of_total_revenue
FROM (SELECT 0.03 AS rate UNION ALL SELECT 0.05 UNION ALL SELECT 0.10);
