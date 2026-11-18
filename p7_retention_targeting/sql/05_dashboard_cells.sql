-- Q5. Data for the live dashboard: TEST-snapshot customers grouped by score cell and spend band
SELECT recency_band, frequency_band, spend_band, COUNT(*) AS customers, ROUND(AVG(score),4) AS score,
       ROUND(AVG(spend/orders),1) AS avg_order_value, SUM(bought_next_180d) AS actual_repeaters
FROM scored_test GROUP BY 1,2,3 ORDER BY score DESC, avg_order_value DESC;
