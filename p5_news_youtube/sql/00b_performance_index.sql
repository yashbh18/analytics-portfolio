-- Performance index = views / median views of the same channel and format (1.0 = typical video)
DROP TABLE IF EXISTS vp;
CREATE TABLE vp AS
WITH r AS (
  SELECT channel, format, views,
         ROW_NUMBER() OVER (PARTITION BY channel, format ORDER BY views) AS rn,
         COUNT(*)     OVER (PARTITION BY channel, format)                 AS n
  FROM v),
med AS (SELECT channel, format, AVG(views) AS median_views FROM r
        WHERE rn IN ((n+1)/2, (n+2)/2) GROUP BY 1,2)
SELECT v.*, m.median_views, 1.0*v.views/m.median_views AS perf_index
FROM v JOIN med m USING (channel, format);
