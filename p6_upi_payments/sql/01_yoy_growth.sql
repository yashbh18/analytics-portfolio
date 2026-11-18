-- Q1. Is UPI growth slowing? Year-on-year growth for the same month (self-join on month - 12)
SELECT c.month, c.volume_mn, c.value_cr,
       ROUND(100.0*(c.volume_mn - p.volume_mn)/p.volume_mn,1) AS volume_yoy_pct,
       ROUND(100.0*(c.value_cr  - p.value_cr )/p.value_cr ,1) AS value_yoy_pct,
       c.avg_ticket_inr, p.avg_ticket_inr AS ticket_last_year
FROM upi c JOIN upi p ON p.yr = c.yr - 1 AND p.mon = c.mon
WHERE c.yr >= 2020 ORDER BY c.month;
