-- Q2. When do repeat customers come back? (gap between 1st and 2nd order)
WITH firsts AS (
    SELECT customer_unique_id,
           MAX(CASE WHEN order_n = 1 THEN purchased_at END) AS first_at,
           MAX(CASE WHEN order_n = 2 THEN purchased_at END) AS second_at
    FROM customer_orders GROUP BY 1
), gaps AS (
    SELECT JULIANDAY(second_at) - JULIANDAY(first_at) AS gap_days FROM firsts
    WHERE second_at IS NOT NULL AND JULIANDAY(second_at) - JULIANDAY(first_at) >= 1
)
SELECT CASE WHEN gap_days <= 30 THEN '1. 0-30 days' WHEN gap_days <= 90 THEN '2. 31-90 days'
            WHEN gap_days <= 180 THEN '3. 91-180 days' ELSE '4. 180+ days' END AS gap_bucket,
       COUNT(*) AS customers,
       ROUND(100.0*COUNT(*)/SUM(COUNT(*)) OVER (),1) AS pct,
       ROUND(100.0*SUM(COUNT(*)) OVER (ORDER BY 1 ROWS UNBOUNDED PRECEDING)/SUM(COUNT(*)) OVER (),1) AS cumulative_pct
FROM gaps GROUP BY 1 ORDER BY 1;
