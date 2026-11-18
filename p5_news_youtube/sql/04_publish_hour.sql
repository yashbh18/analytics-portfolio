-- Q4. When to publish: IST hour block vs performance (both formats, channel-normalised)
SELECT CASE WHEN hour_ist < 6 THEN '1. 00-06' WHEN hour_ist < 10 THEN '2. 06-10' WHEN hour_ist < 14 THEN '3. 10-14'
            WHEN hour_ist < 18 THEN '4. 14-18' WHEN hour_ist < 22 THEN '5. 18-22' ELSE '6. 22-24' END AS ist_block,
       COUNT(*) AS videos, ROUND(100.0*COUNT(*)/SUM(COUNT(*)) OVER (),1) AS pct_uploads,
       ROUND(100.0*AVG(CASE WHEN perf_index > 1 THEN 1.0 ELSE 0 END),1) AS pct_beat_channel_median,
       ROUND(100.0*AVG(CASE WHEN perf_index >= 2 THEN 1.0 ELSE 0 END),1) AS pct_breakout_2x
FROM vp GROUP BY 1 ORDER BY 1;
