-- Q11. Seller SLA scorecard: the 15 sellers (100+ orders) with the worst late-handover rate
SELECT d.seller_id,
       COUNT(*)                                                                         AS orders,
       ROUND(100.0*AVG(CASE WHEN d.seller_handover_delay > 0 THEN 1.0 ELSE 0 END),1)    AS late_handover_pct,
       ROUND(100.0*AVG(CASE WHEN d.days_vs_estimate > 0 THEN 1.0 ELSE 0 END),1)         AS late_delivery_pct,
       ROUND(AVG(d.review_score),2)                                                     AS avg_review,
       ROUND(SUM(oi.price),0)                                                           AS gmv_brl
FROM delivered_orders d
JOIN order_items oi ON oi.order_id = d.order_id AND oi.order_item_id = 1
GROUP BY d.seller_id HAVING COUNT(*) >= 100
ORDER BY late_handover_pct DESC LIMIT 15;
