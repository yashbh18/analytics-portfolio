-- Q8. Impact sizing: if sellers who hand over late performed like on-time sellers,
-- how many late orders (and 1-2 star reviews) would be avoided?
WITH g AS (
    SELECT SUM(CASE WHEN seller_handover_delay > 0 THEN 1 ELSE 0 END)                               AS late_handover_orders,
           AVG(CASE WHEN seller_handover_delay > 0  THEN (days_vs_estimate > 0)*1.0 END)            AS late_rate_bad,
           AVG(CASE WHEN seller_handover_delay <= 0 THEN (days_vs_estimate > 0)*1.0 END)            AS late_rate_good,
           SUM(CASE WHEN days_vs_estimate > 0 THEN 1 ELSE 0 END)                                    AS total_late,
           AVG(CASE WHEN days_vs_estimate > 0  THEN (review_score <= 2)*1.0 END)                    AS bad_review_late,
           AVG(CASE WHEN days_vs_estimate <= 0 THEN (review_score <= 2)*1.0 END)                    AS bad_review_ontime
    FROM delivered_orders WHERE seller_handover_delay IS NOT NULL
)
SELECT ROUND(late_handover_orders*(late_rate_bad-late_rate_good))                                   AS late_orders_avoided,
       ROUND(100.0*late_handover_orders*(late_rate_bad-late_rate_good)/total_late,1)                AS pct_of_all_late,
       ROUND(late_handover_orders*(late_rate_bad-late_rate_good)*(bad_review_late-bad_review_ontime)) AS bad_reviews_avoided
FROM g;
