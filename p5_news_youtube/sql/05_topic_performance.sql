-- Q5. Topic mix vs performance: where channels publish vs what audiences watch
SELECT topic, COUNT(*) AS videos, ROUND(100.0*COUNT(*)/SUM(COUNT(*)) OVER (),1) AS pct_uploads,
       ROUND(100.0*AVG(CASE WHEN perf_index > 1 THEN 1.0 ELSE 0 END),1) AS pct_beat_channel_median,
       ROUND(100.0*AVG(CASE WHEN perf_index >= 2 THEN 1.0 ELSE 0 END),1) AS pct_breakout_2x,
       ROUND(100.0*AVG(engagement_rate),2) AS avg_engagement_pct
FROM vp GROUP BY 1 ORDER BY pct_breakout_2x DESC;
