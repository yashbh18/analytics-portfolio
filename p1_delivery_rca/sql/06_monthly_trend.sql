-- Q6. Monthly trend: late rate vs average review (2017-01 to 2018-08)
SELECT purchase_month, COUNT(*) AS orders,
       ROUND(100.0*AVG(CASE WHEN days_vs_estimate > 0 THEN 1.0 ELSE 0 END),1) AS late_rate_pct,
       ROUND(AVG(review_score),2) AS avg_review
FROM delivered_orders
WHERE purchase_month BETWEEN '2017-01' AND '2018-08'
GROUP BY 1 ORDER BY 1;
