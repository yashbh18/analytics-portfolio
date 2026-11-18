-- Q1. Channel scorecard: output (from all scraped uploads), reach and engagement (videos 1+ day old)
WITH output AS (
  SELECT channel, format,
         ROUND(COUNT(*)/((JULIANDAY(MAX(SUBSTR(pub,1,19)))-JULIANDAY(MIN(SUBSTR(pub,1,19))))/7.0),1) AS uploads_per_week
  FROM videos_raw GROUP BY 1,2)
SELECT vp.channel, vp.format, COUNT(*) AS videos_analysed, o.uploads_per_week,
       ROUND(MAX(vp.median_views)) AS median_views, ROUND(AVG(vp.views)) AS avg_views,
       ROUND(100.0*SUM(COALESCE(vp.likes,0)+COALESCE(vp.n_comments,0))/SUM(vp.views),2) AS engagement_pct
FROM vp JOIN output o ON o.channel = vp.channel AND o.format = vp.format
GROUP BY 1,2 ORDER BY 1,2;
