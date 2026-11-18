-- Q4. What drives a return? Actual next-180-day repeat rate by each feature on the TEST snapshot
SELECT 'Recency' AS feature, recency_band AS band, COUNT(*) AS customers, ROUND(100.0*AVG(bought_next_180d),2) AS repeat_pct FROM feat_test GROUP BY 2
UNION ALL SELECT 'Frequency', frequency_band, COUNT(*), ROUND(100.0*AVG(bought_next_180d),2) FROM feat_test GROUP BY 2
UNION ALL SELECT 'Spend', spend_band, COUNT(*), ROUND(100.0*AVG(bought_next_180d),2) FROM feat_test GROUP BY 2
UNION ALL SELECT 'Last review', last_review, COUNT(*), ROUND(100.0*AVG(bought_next_180d),2) FROM feat_test GROUP BY 2
UNION ALL SELECT 'Last delivery', last_delivery, COUNT(*), ROUND(100.0*AVG(bought_next_180d),2) FROM feat_test GROUP BY 2;
