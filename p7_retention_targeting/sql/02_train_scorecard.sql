-- Q2. Propensity scorecard (recency × frequency), learned on the TRAIN snapshot.
-- I tested 3- and 5-feature versions, but they overfit and validated worse out of time, so the simplest one wins.
-- Smoothing pulls small cells toward the overall rate: (repeats + k*base) / (customers + k), k = 50
DROP TABLE IF EXISTS scorecard;
CREATE TABLE scorecard AS
WITH base AS (SELECT AVG(bought_next_180d) AS b FROM feat_train)
SELECT recency_band, frequency_band, COUNT(*) AS train_customers, SUM(bought_next_180d) AS train_repeaters,
       (SUM(bought_next_180d) + 50*(SELECT b FROM base)) / (COUNT(*) + 50.0) AS score
FROM feat_train GROUP BY 1,2;
SELECT recency_band, frequency_band, train_customers, train_repeaters, ROUND(100*score,2) AS score_pct FROM scorecard ORDER BY score DESC;
