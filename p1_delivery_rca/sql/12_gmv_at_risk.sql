-- Q12. Money view: GMV of late orders and repeat revenue lost because late first orders repeat less
WITH first_orders AS (
    SELECT d.customer_unique_id, d.days_vs_estimate,
           ROW_NUMBER() OVER (PARTITION BY d.customer_unique_id ORDER BY d.purchase_date) AS n
    FROM delivered_orders d
), cust AS (
    SELECT customer_unique_id, COUNT(*) AS orders FROM delivered_orders GROUP BY 1
), pay AS (
    SELECT order_id, SUM(payment_value) AS value FROM order_payments GROUP BY 1
)
SELECT
  (SELECT ROUND(SUM(p.value)) FROM delivered_orders d JOIN pay p USING(order_id) WHERE d.days_vs_estimate > 0) AS late_orders_gmv_brl,
  (SELECT ROUND(AVG(p.value),1) FROM pay p)                                                                  AS avg_order_value_brl,
  (SELECT COUNT(*) FROM first_orders WHERE n=1 AND days_vs_estimate > 0)                                     AS customers_first_order_late,
  ROUND((SELECT AVG(CASE WHEN c.orders>1 THEN 1.0 ELSE 0 END) FROM first_orders f JOIN cust c USING(customer_unique_id) WHERE f.n=1 AND f.days_vs_estimate<=0)
       -(SELECT AVG(CASE WHEN c.orders>1 THEN 1.0 ELSE 0 END) FROM first_orders f JOIN cust c USING(customer_unique_id) WHERE f.n=1 AND f.days_vs_estimate>0), 4) AS repeat_rate_gap;
