-- Q5. Milestones: first month UPI crossed each monthly-volume mark, and months taken from the previous mark
WITH marks(m) AS (VALUES (1000),(2000),(5000),(10000),(15000),(20000),(25000)),
first AS (SELECT m, MIN(month) AS first_month FROM marks JOIN upi ON volume_mn >= m GROUP BY m)
SELECT m AS volume_mark_mn, first_month,
       (CAST(SUBSTR(first_month,1,4) AS INT)*12 + CAST(SUBSTR(first_month,6,2) AS INT))
     - (CAST(SUBSTR(LAG(first_month) OVER (ORDER BY m),1,4) AS INT)*12 + CAST(SUBSTR(LAG(first_month) OVER (ORDER BY m),6,2) AS INT)) AS months_since_previous_mark
FROM first ORDER BY m;
