-- Q2. Review score falls off a cliff as soon as an order is late
SELECT CASE WHEN days_vs_estimate <= -7 THEN '1. 7+ days early'
            WHEN days_vs_estimate <=  0 THEN '2. 0-7 days early'
            WHEN days_vs_estimate <=  3 THEN '3. 1-3 days late'
            WHEN days_vs_estimate <=  7 THEN '4. 4-7 days late'
            ELSE                             '5. 8+ days late' END AS delay_bucket,
       COUNT(*) AS orders,
       ROUND(AVG(review_score), 2) AS avg_review,
       ROUND(100.0 * AVG(CASE WHEN review_score <= 2 THEN 1.0 ELSE 0 END), 1) AS pct_1_2_star
FROM delivered_orders
WHERE review_score IS NOT NULL
GROUP BY 1 ORDER BY 1;
