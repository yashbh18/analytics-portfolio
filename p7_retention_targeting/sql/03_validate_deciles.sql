-- Q3. Out-of-time validation: score the TEST snapshot (Mar 2018) with the TRAIN scorecard (Sep 2017), then compare with what customers actually did
DROP TABLE IF EXISTS scored_test;
CREATE TABLE scored_test AS
SELECT t.*, COALESCE(c.score,(SELECT AVG(bought_next_180d) FROM feat_train)) AS score,
       NTILE(10) OVER (ORDER BY COALESCE(c.score,0) DESC, t.recency_days) AS decile
FROM feat_test t LEFT JOIN scorecard c USING (recency_band, frequency_band);
SELECT decile, COUNT(*) AS customers, ROUND(100*AVG(score),2) AS predicted_pct, ROUND(100.0*AVG(bought_next_180d),2) AS actual_repeat_pct,
       ROUND(AVG(bought_next_180d)/(SELECT AVG(bought_next_180d) FROM feat_test),2) AS lift,
       ROUND(100.0*SUM(SUM(bought_next_180d)) OVER (ORDER BY decile)/(SELECT SUM(bought_next_180d) FROM feat_test),1) AS cumulative_capture_pct
FROM scored_test GROUP BY decile ORDER BY decile;
