-- Q8. Revenue concentration by customer state + AOV
SELECT customer_state, COUNT(*) AS orders, ROUND(SUM(order_value)) AS gmv_brl,
       ROUND(100.0*SUM(order_value)/SUM(SUM(order_value)) OVER (),1) AS share_pct,
       ROUND(AVG(order_value),1) AS aov_brl
FROM customer_orders GROUP BY 1 ORDER BY gmv_brl DESC LIMIT 10;
