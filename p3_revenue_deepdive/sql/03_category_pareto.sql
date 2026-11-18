-- Q3. Category Pareto: cumulative share of item revenue (SUM OVER)
WITH cat AS (
  SELECT COALESCE(t.product_category_name_english,'unknown') AS category, SUM(oi.price) AS revenue, COUNT(*) AS items
  FROM order_items oi JOIN customer_orders co ON co.order_id = oi.order_id
  JOIN products p ON p.product_id = oi.product_id
  LEFT JOIN product_category_name_translation t ON t.product_category_name = p.product_category_name
  GROUP BY 1)
SELECT RANK() OVER (ORDER BY revenue DESC) AS rnk, category, items, ROUND(revenue) AS revenue_brl,
       ROUND(100.0*revenue/SUM(revenue) OVER (),1) AS share_pct,
       ROUND(100.0*SUM(revenue) OVER (ORDER BY revenue DESC ROWS UNBOUNDED PRECEDING)/SUM(revenue) OVER (),1) AS cumulative_pct
FROM cat ORDER BY revenue DESC LIMIT 20;
