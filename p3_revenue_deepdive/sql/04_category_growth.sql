-- Q4. Which top categories grew fastest? H1-2018 vs H1-2017 item revenue
WITH x AS (
  SELECT COALESCE(t.product_category_name_english,'unknown') AS category,
         SUM(CASE WHEN co.order_month BETWEEN '2017-01' AND '2017-06' THEN oi.price END) AS h1_2017,
         SUM(CASE WHEN co.order_month BETWEEN '2018-01' AND '2018-06' THEN oi.price END) AS h1_2018
  FROM order_items oi JOIN customer_orders co ON co.order_id = oi.order_id
  JOIN products p ON p.product_id = oi.product_id
  LEFT JOIN product_category_name_translation t ON t.product_category_name = p.product_category_name
  GROUP BY 1)
SELECT category, ROUND(h1_2017) AS h1_2017_brl, ROUND(h1_2018) AS h1_2018_brl,
       ROUND(100.0*(h1_2018-h1_2017)/h1_2017,0) AS growth_pct, ROUND(h1_2018-h1_2017) AS abs_growth_brl
FROM x WHERE h1_2018 >= 200000 ORDER BY abs_growth_brl DESC;
