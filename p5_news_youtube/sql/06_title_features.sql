-- Q6. Title patterns: breakout rate (2x+ the channel's median views) with vs without each title feature
-- (rates, not averages, so a handful of viral outliers cannot distort the result)
WITH f AS (
  SELECT perf_index, 'Question mark' AS feature, has_question AS flag FROM vp
  UNION ALL SELECT perf_index, 'Number in title', has_number FROM vp
  UNION ALL SELECT perf_index, 'Direct quote', has_quote FROM vp
  UNION ALL SELECT perf_index, 'Pipe separator ( | )', has_pipe FROM vp
  UNION ALL SELECT perf_index, 'Long title (80+ chars)', CASE WHEN title_len >= 80 THEN 1 ELSE 0 END FROM vp)
SELECT feature, SUM(flag) AS videos_with,
       ROUND(100.0*AVG(CASE WHEN flag=1 THEN (perf_index>=2)*1.0 END),1) AS breakout_pct_with,
       ROUND(100.0*AVG(CASE WHEN flag=0 THEN (perf_index>=2)*1.0 END),1) AS breakout_pct_without,
       ROUND(100.0*AVG(CASE WHEN flag=1 THEN (perf_index>=2)*1.0 END) - 100.0*AVG(CASE WHEN flag=0 THEN (perf_index>=2)*1.0 END),1) AS lift_pp
FROM f GROUP BY feature ORDER BY lift_pp DESC;
