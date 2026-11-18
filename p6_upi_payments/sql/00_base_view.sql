-- Base view: one row per month with days, average ticket size, daily averages and value per bank
-- Source: NPCI UPI Product Statistics (volume in million, value in ₹ crore). NPCI's site omits April-May for FY2016-17 to FY2025-26.
DROP VIEW IF EXISTS upi;
CREATE VIEW upi AS
SELECT month,
       CAST(SUBSTR(month,1,4) AS INT)                                        AS yr,
       CAST(SUBSTR(month,6,2) AS INT)                                        AS mon,
       banks_live, volume_mn, value_cr,
       CAST(STRFTIME('%d', DATE(month || '-01', '+1 month', '-1 day')) AS INT) AS days,
       CASE WHEN volume_mn > 0 THEN ROUND(value_cr * 10.0 / volume_mn, 0) END AS avg_ticket_inr,   -- ₹ cr ×1e7 / (mn ×1e6)
       ROUND(volume_mn / CAST(STRFTIME('%d', DATE(month || '-01', '+1 month', '-1 day')) AS REAL), 1) AS daily_volume_mn,
       ROUND(volume_mn / banks_live, 2)                                      AS volume_per_bank_mn
FROM upi_raw;
