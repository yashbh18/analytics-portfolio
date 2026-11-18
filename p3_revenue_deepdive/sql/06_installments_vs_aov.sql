-- Q6. Credit-card orders: instalment band vs basket size
WITH cc AS (
  SELECT op.order_id, MAX(op.payment_installments) AS inst, co.order_value
  FROM order_payments op JOIN customer_orders co ON co.order_id = op.order_id
  WHERE op.payment_type = 'credit_card' GROUP BY op.order_id, co.order_value)
SELECT CASE WHEN inst <= 1 THEN '1. 1x' WHEN inst <= 3 THEN '2. 2-3x' WHEN inst <= 6 THEN '3. 4-6x' ELSE '4. 7x+' END AS band,
       COUNT(*) AS orders, ROUND(100.0*COUNT(*)/SUM(COUNT(*)) OVER (),1) AS pct_orders,
       ROUND(AVG(order_value),1) AS aov_brl, ROUND(100.0*SUM(order_value)/SUM(SUM(order_value)) OVER (),1) AS pct_gmv
FROM cc GROUP BY 1 ORDER BY 1;
