-- One row per delivered order with delivery timing and review score
DROP VIEW IF EXISTS delivered_orders;
CREATE VIEW delivered_orders AS
WITH reviews_dedup AS (           -- an order can have >1 review; keep the latest
    SELECT order_id, review_score,
           ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY review_answer_timestamp DESC) AS rn
    FROM order_reviews
),
first_item AS (                   -- seller + shipping deadline for the order's first item
    SELECT order_id, seller_id, shipping_limit_date
    FROM order_items WHERE order_item_id = 1
)
SELECT o.order_id,
       c.customer_unique_id,
       c.customer_state,
       fi.seller_id,
       DATE(o.order_purchase_timestamp)                                   AS purchase_date,
       STRFTIME('%Y-%m', o.order_purchase_timestamp)                       AS purchase_month,
       JULIANDAY(o.order_delivered_customer_date) - JULIANDAY(o.order_estimated_delivery_date) AS days_vs_estimate,
       JULIANDAY(o.order_delivered_carrier_date)  - JULIANDAY(fi.shipping_limit_date)          AS seller_handover_delay,
       JULIANDAY(o.order_delivered_customer_date) - JULIANDAY(o.order_delivered_carrier_date)  AS carrier_transit_days,
       r.review_score
FROM orders o
JOIN customers c        ON c.customer_id = o.customer_id
LEFT JOIN first_item fi ON fi.order_id = o.order_id
LEFT JOIN reviews_dedup r ON r.order_id = o.order_id AND r.rn = 1
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL;
