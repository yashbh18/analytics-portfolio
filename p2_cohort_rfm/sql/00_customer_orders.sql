-- Base view: one row per delivered order with the customer's unique id, order value and order sequence
DROP VIEW IF EXISTS customer_orders;
CREATE VIEW customer_orders AS
WITH pay AS (SELECT order_id, SUM(payment_value) AS order_value FROM order_payments GROUP BY order_id)
SELECT o.order_id,
       c.customer_unique_id,
       c.customer_state,
       o.order_purchase_timestamp                                         AS purchased_at,
       STRFTIME('%Y-%m', o.order_purchase_timestamp)                      AS order_month,
       p.order_value,
       ROW_NUMBER() OVER (PARTITION BY c.customer_unique_id ORDER BY o.order_purchase_timestamp) AS order_n,
       MIN(STRFTIME('%Y-%m', o.order_purchase_timestamp)) OVER (PARTITION BY c.customer_unique_id) AS cohort_month
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN pay p       ON p.order_id   = o.order_id
WHERE o.order_status = 'delivered' AND o.order_purchase_timestamp < '2018-09-01';
