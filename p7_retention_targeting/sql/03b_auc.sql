-- Q3b. AUC in pure SQL (Mann-Whitney rank formula, tied scores get their average rank)
WITH g AS (SELECT score, COUNT(*) AS n, SUM(bought_next_180d) AS pos FROM scored_test GROUP BY score),
r AS (SELECT *, SUM(n) OVER (ORDER BY score ROWS UNBOUNDED PRECEDING) - n + (n + 1) / 2.0 AS avg_rank FROM g),
t AS (SELECT SUM(pos) AS P, SUM(n) - SUM(pos) AS N, SUM(pos * avg_rank) AS rank_sum FROM r)
SELECT ROUND((rank_sum - P * (P + 1) / 2.0) / (P * N), 3) AS auc, P AS repeaters, N AS non_repeaters FROM t;
