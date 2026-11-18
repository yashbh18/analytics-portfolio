-- Q1. Monthly GMV, orders, AOV and month-over-month growth (LAG)
WITH m AS (
  SELECT order_month, COUNT(*) AS orders, SUM(order_value) AS gmv FROM customer_orders
  WHERE order_month BETWEEN '2017-01' AND '2018-08' GROUP BY 1)
SELECT order_month, orders, ROUND(gmv) AS gmv_brl, ROUND(gmv/orders,1) AS aov_brl,
       ROUND(100.0*(gmv - LAG(gmv) OVER (ORDER BY order_month))/LAG(gmv) OVER (ORDER BY order_month),1) AS gmv_mom_pct,
       ROUND(SUM(gmv) OVER (ORDER BY order_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)/3) AS gmv_3m_rolling_avg
FROM m ORDER BY 1;
