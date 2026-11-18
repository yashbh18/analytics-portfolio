-- Q3. Root cause: is the delay at the seller (late hand-over to carrier) or in carrier transit?
SELECT CASE WHEN seller_handover_delay > 0 THEN 'Seller handed over late'
            ELSE 'Seller on time' END                         AS seller_stage,
       COUNT(*)                                               AS orders,
       ROUND(100.0 * AVG(CASE WHEN days_vs_estimate > 0 THEN 1.0 ELSE 0 END), 1) AS late_rate_pct,
       ROUND(AVG(carrier_transit_days), 1)                    AS avg_transit_days
FROM delivered_orders
WHERE seller_handover_delay IS NOT NULL
GROUP BY 1;
