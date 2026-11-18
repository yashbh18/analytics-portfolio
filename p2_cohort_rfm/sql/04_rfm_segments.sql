-- Q4. RFM segmentation: recency & monetary quintiles (NTILE) + repeat flag -> 6 actionable segments
WITH snapshot AS (SELECT JULIANDAY(MAX(purchased_at)) + 1 AS snap FROM customer_orders),
rfm AS (
    SELECT customer_unique_id,
           (SELECT snap FROM snapshot) - JULIANDAY(MAX(purchased_at)) AS recency_days,
           COUNT(*)                                                    AS frequency,
           SUM(order_value)                                            AS monetary
    FROM customer_orders GROUP BY 1
), scored AS (
    SELECT *, NTILE(5) OVER (ORDER BY recency_days DESC) AS r_score,   -- 5 = most recent
              NTILE(5) OVER (ORDER BY monetary ASC)      AS m_score    -- 5 = highest spend
    FROM rfm
), segmented AS (
    SELECT *, CASE WHEN frequency >= 2 AND r_score >= 3 THEN 'Loyal repeaters'
                   WHEN frequency >= 2                  THEN 'Lapsed repeaters'
                   WHEN r_score >= 4 AND m_score >= 4   THEN 'New high-value'
                   WHEN r_score >= 4                    THEN 'New low-value'
                   WHEN m_score >= 4                    THEN 'At-risk high-value'
                   ELSE 'Hibernating low-value' END AS segment
    FROM scored
)
SELECT segment, COUNT(*) AS customers,
       ROUND(100.0*COUNT(*)/SUM(COUNT(*)) OVER (),1)                 AS pct_customers,
       ROUND(SUM(monetary))                                           AS revenue_brl,
       ROUND(100.0*SUM(monetary)/SUM(SUM(monetary)) OVER (),1)        AS pct_revenue,
       ROUND(AVG(monetary),1)                                         AS avg_spend_brl,
       ROUND(AVG(recency_days))                                       AS avg_recency_days
FROM segmented GROUP BY segment ORDER BY revenue_brl DESC;
