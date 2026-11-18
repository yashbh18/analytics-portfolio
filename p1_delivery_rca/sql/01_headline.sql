-- Q1. How common are late deliveries, and how do they change review scores?
SELECT CASE WHEN days_vs_estimate > 0 THEN 'Late' ELSE 'On time / early' END AS delivery,
       COUNT(*)                                                    AS orders,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1)          AS pct_orders,
       ROUND(AVG(review_score), 2)                                 AS avg_review,
       ROUND(100.0 * AVG(CASE WHEN review_score <= 2 THEN 1.0 ELSE 0 END), 1) AS pct_1_2_star
FROM delivered_orders
WHERE review_score IS NOT NULL
GROUP BY 1;
