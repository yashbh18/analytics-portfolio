-- Q5. Which first-purchase categories create repeat customers? (1,000+ first buyers)
WITH first_cat AS (
    SELECT co.customer_unique_id, COALESCE(t.product_category_name_english, p.product_category_name) AS category
    FROM customer_orders co
    JOIN order_items oi ON oi.order_id = co.order_id AND oi.order_item_id = 1
    JOIN products p     ON p.product_id = oi.product_id
    LEFT JOIN product_category_name_translation t ON t.product_category_name = p.product_category_name
    WHERE co.order_n = 1
), cust AS (SELECT customer_unique_id, COUNT(*) AS orders FROM customer_orders GROUP BY 1)
SELECT category, COUNT(*) AS first_buyers,
       ROUND(100.0*AVG(CASE WHEN c.orders > 1 THEN 1.0 ELSE 0 END),2) AS repeat_rate_pct
FROM first_cat f JOIN cust c USING (customer_unique_id)
GROUP BY category HAVING COUNT(*) >= 1000
ORDER BY repeat_rate_pct DESC;
