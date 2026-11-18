-- Q2. Like-for-like yearly view: June-to-March window (months available every year), with growth and ticket size
WITH fy AS (
  SELECT CASE WHEN mon >= 6 THEN yr ELSE yr - 1 END AS fy_start, volume_mn, value_cr
  FROM upi WHERE mon NOT IN (4,5))
SELECT fy_start || '-' || SUBSTR(CAST(fy_start+1 AS TEXT),3,2) AS fiscal_year,
       COUNT(*) AS months, ROUND(SUM(volume_mn)) AS volume_mn, ROUND(SUM(value_cr)/100000.0,2) AS value_lakh_cr,
       ROUND(SUM(value_cr)*10.0/SUM(volume_mn)) AS avg_ticket_inr,
       ROUND(100.0*(SUM(volume_mn)/LAG(SUM(volume_mn)) OVER (ORDER BY fy_start) - 1),1) AS volume_growth_pct,
       ROUND(100.0*(SUM(value_cr)/LAG(SUM(value_cr)) OVER (ORDER BY fy_start) - 1),1) AS value_growth_pct
FROM fy WHERE fy_start BETWEEN 2017 AND 2025 GROUP BY fy_start HAVING COUNT(*) = 10 ORDER BY fy_start;
