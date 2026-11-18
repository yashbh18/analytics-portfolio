-- Q4. Late-delivery rate by customer state (states with 1,000+ orders), ranked
WITH s AS (
    SELECT customer_state, COUNT(*) AS orders,
           100.0 * AVG(CASE WHEN days_vs_estimate > 0 THEN 1.0 ELSE 0 END) AS late_rate,
           AVG(review_score) AS avg_review
    FROM delivered_orders GROUP BY customer_state HAVING COUNT(*) >= 1000
)
SELECT customer_state, orders, ROUND(late_rate,1) AS late_rate_pct, ROUND(avg_review,2) AS avg_review,
       RANK() OVER (ORDER BY late_rate DESC) AS late_rank
FROM s ORDER BY late_rank;
