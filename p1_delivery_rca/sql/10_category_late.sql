-- Q10. Which product categories suffer most? (categories with 1,500+ delivered orders)
SELECT COALESCE(t.product_category_name_english, p.product_category_name) AS category,
       COUNT(*)                                                         AS orders,
       ROUND(100.0*AVG(CASE WHEN d.days_vs_estimate > 0 THEN 1.0 ELSE 0 END),1) AS late_rate_pct,
       ROUND(AVG(d.review_score),2)                                     AS avg_review,
       ROUND(AVG(oi.freight_value / NULLIF(oi.price,0))*100,1)          AS freight_pct_of_price
FROM delivered_orders d
JOIN order_items oi ON oi.order_id = d.order_id AND oi.order_item_id = 1
JOIN products p     ON p.product_id = oi.product_id
LEFT JOIN product_category_name_translation t ON t.product_category_name = p.product_category_name
GROUP BY 1 HAVING COUNT(*) >= 1500
ORDER BY late_rate_pct DESC;
