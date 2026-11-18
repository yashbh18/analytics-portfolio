-- Q7. The Economic Times vs peer average: gap by format and topic
WITH c AS (SELECT channel, format, topic, AVG(views) AS avg_views, COUNT(*) AS n FROM vp GROUP BY 1,2,3)
SELECT format, topic,
       MAX(CASE WHEN channel='TheEconomicTimes' THEN n END) AS et_videos,
       ROUND(MAX(CASE WHEN channel='TheEconomicTimes' THEN avg_views END)) AS et_avg_views,
       ROUND(AVG(CASE WHEN channel<>'TheEconomicTimes' THEN avg_views END)) AS peer_avg_views,
       ROUND(MAX(CASE WHEN channel='TheEconomicTimes' THEN avg_views END)/AVG(CASE WHEN channel<>'TheEconomicTimes' THEN avg_views END),2) AS et_vs_peer
FROM c GROUP BY 1,2 HAVING et_videos >= 5 ORDER BY format, et_vs_peer;
