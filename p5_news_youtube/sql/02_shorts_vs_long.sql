-- Q2. Shorts vs long-form: how much more reach does a Short get, per channel?
WITH x AS (SELECT channel,
   MAX(CASE WHEN format='short' THEN median_views END) AS short_median,
   MAX(CASE WHEN format='video' THEN median_views END) AS long_median,
   SUM(CASE WHEN format='short' THEN views END) AS short_views,
   SUM(views) AS all_views,
   SUM(CASE WHEN format='short' THEN 1 ELSE 0 END) AS shorts, COUNT(*) AS all_videos
 FROM vp GROUP BY 1)
SELECT channel, ROUND(short_median) AS short_median_views, ROUND(long_median) AS long_median_views,
       ROUND(short_median/long_median,1) AS short_to_long_ratio,
       ROUND(100.0*shorts/all_videos,1) AS shorts_pct_of_uploads,
       ROUND(100.0*short_views/all_views,1) AS shorts_pct_of_views
FROM x ORDER BY short_to_long_ratio DESC;
