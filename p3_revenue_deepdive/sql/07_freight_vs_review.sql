-- Q7. Does a high freight share of price hurt reviews? (joins P1 delivered_orders view)
WITH f AS (
  SELECT oi.order_id, SUM(oi.freight_value)/NULLIF(SUM(oi.price),0) AS freight_ratio
  FROM order_items oi GROUP BY 1)
SELECT CASE WHEN freight_ratio < 0.10 THEN '1. <10%' WHEN freight_ratio < 0.20 THEN '2. 10-20%'
            WHEN freight_ratio < 0.40 THEN '3. 20-40%' ELSE '4. 40%+' END AS freight_share_of_price,
       COUNT(*) AS orders, ROUND(AVG(d.review_score),2) AS avg_review,
       ROUND(100.0*AVG(CASE WHEN d.days_vs_estimate > 0 THEN 1.0 ELSE 0 END),1) AS late_pct,
       ROUND(100.0*AVG(CASE WHEN d.review_score <= 2 THEN 1.0 ELSE 0 END),1) AS bad_review_pct
FROM f JOIN delivered_orders d ON d.order_id = f.order_id
WHERE d.review_score IS NOT NULL GROUP BY 1 ORDER BY 1;
