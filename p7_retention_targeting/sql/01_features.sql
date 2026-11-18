-- Q1. Customer features as of a snapshot date (run twice: TRAIN at 2017-09-01, TEST at 2018-03-01)
-- Uses the customer_orders view (Project 2) and delivered_orders view (Project 1). :snap is the snapshot date.
DROP TABLE IF EXISTS feat_:tag;
CREATE TABLE feat_:tag AS
WITH hist AS (
  SELECT co.customer_unique_id, co.order_id, co.purchased_at, co.order_value,
         ROW_NUMBER() OVER (PARTITION BY co.customer_unique_id ORDER BY co.purchased_at DESC) AS rn_desc
  FROM customer_orders co WHERE co.purchased_at < ':snap'),
agg AS (
  SELECT customer_unique_id, COUNT(*) AS orders, SUM(order_value) AS spend,
         JULIANDAY(':snap') - JULIANDAY(MAX(purchased_at)) AS recency_days,
         MAX(CASE WHEN rn_desc = 1 THEN order_id END) AS last_order
  FROM hist GROUP BY 1),
lab AS (
  SELECT DISTINCT customer_unique_id FROM customer_orders
  WHERE purchased_at >= ':snap' AND purchased_at < DATE(':snap','+180 days'))
SELECT a.customer_unique_id, a.orders, a.spend, a.recency_days,
       CASE WHEN a.recency_days <= 90 THEN '1 0-90d' WHEN a.recency_days <= 180 THEN '2 91-180d'
            ELSE '3 181d+' END            AS recency_band,
       CASE WHEN a.orders >= 2 THEN '2+ orders' ELSE '1 order' END                    AS frequency_band,
       CASE WHEN a.spend < 100 THEN '1 <R$100' WHEN a.spend < 250 THEN '2 R$100-250' ELSE '3 R$250+' END AS spend_band,
       CASE WHEN d.review_score IS NULL THEN 'no review' WHEN d.review_score <= 2 THEN '1-2 stars'
            WHEN d.review_score = 3 THEN '3 stars' ELSE '4-5 stars' END              AS last_review,
       CASE WHEN d.days_vs_estimate > 0 THEN 'late' ELSE 'on time' END                AS last_delivery,
       CASE WHEN l.customer_unique_id IS NOT NULL THEN 1 ELSE 0 END                   AS bought_next_180d
FROM agg a LEFT JOIN temp.dd d ON d.order_id = a.last_order
LEFT JOIN lab l ON l.customer_unique_id = a.customer_unique_id;
