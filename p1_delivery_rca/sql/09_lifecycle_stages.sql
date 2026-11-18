-- Q9. Where does the time go? Average days in each order-lifecycle stage, late vs on-time
SELECT CASE WHEN JULIANDAY(o.order_delivered_customer_date) > JULIANDAY(o.order_estimated_delivery_date)
            THEN 'Late' ELSE 'On time' END                                                        AS delivery,
       ROUND(AVG(JULIANDAY(o.order_approved_at) - JULIANDAY(o.order_purchase_timestamp)), 1)      AS approval_days,
       ROUND(AVG(JULIANDAY(o.order_delivered_carrier_date) - JULIANDAY(o.order_approved_at)), 1)  AS seller_prep_days,
       ROUND(AVG(JULIANDAY(o.order_delivered_customer_date) - JULIANDAY(o.order_delivered_carrier_date)), 1) AS transit_days,
       ROUND(AVG(JULIANDAY(o.order_estimated_delivery_date) - JULIANDAY(o.order_purchase_timestamp)), 1)     AS promised_days,
       COUNT(*) AS orders
FROM orders o
WHERE o.order_status = 'delivered' AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_delivered_carrier_date IS NOT NULL AND o.order_approved_at IS NOT NULL
GROUP BY 1;
