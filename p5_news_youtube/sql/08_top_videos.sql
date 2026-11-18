-- Q8. Breakout videos: top 15 by performance index (what over-performers have in common)
SELECT channel, format, topic, length_bucket, hour_ist, views, ROUND(perf_index,1) AS perf_index, title
FROM (SELECT *, RANK() OVER (ORDER BY perf_index DESC) AS rk FROM vp) WHERE rk <= 15 ORDER BY rk;
