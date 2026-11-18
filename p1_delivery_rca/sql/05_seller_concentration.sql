-- Q5. Are late orders concentrated in a few sellers? (sellers with 30+ orders)
WITH seller AS (
    SELECT seller_id, COUNT(*) AS orders,
           SUM(CASE WHEN days_vs_estimate > 0 THEN 1 ELSE 0 END) AS late_orders
    FROM delivered_orders GROUP BY seller_id HAVING COUNT(*) >= 30
), ranked AS (
    SELECT *, 1.0*late_orders/orders AS late_rate,
           NTILE(10) OVER (ORDER BY 1.0*late_orders/orders DESC) AS decile
    FROM seller
)
SELECT decile, COUNT(*) AS sellers, SUM(orders) AS orders, SUM(late_orders) AS late_orders,
       ROUND(100.0*SUM(late_orders)/SUM(orders),1) AS late_rate_pct,
       ROUND(100.0*SUM(late_orders)/(SELECT SUM(late_orders) FROM ranked),1) AS share_of_all_late_pct
FROM ranked GROUP BY decile ORDER BY decile;
