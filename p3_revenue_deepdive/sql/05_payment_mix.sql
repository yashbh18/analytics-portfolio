-- Q5. Payment type: share of orders, AOV, and instalments
WITH p AS (
  SELECT op.order_id, op.payment_type, op.payment_installments, op.payment_value,
         ROW_NUMBER() OVER (PARTITION BY op.order_id ORDER BY op.payment_value DESC) AS rn
  FROM order_payments op JOIN customer_orders co ON co.order_id = op.order_id)
SELECT payment_type, COUNT(*) AS orders, ROUND(100.0*COUNT(*)/SUM(COUNT(*)) OVER (),1) AS pct_orders,
       ROUND(AVG(payment_value),1) AS avg_payment_brl, ROUND(AVG(payment_installments),1) AS avg_installments
FROM p WHERE rn = 1 GROUP BY 1 ORDER BY orders DESC;
