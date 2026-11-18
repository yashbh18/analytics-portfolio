-- Q3. Monthly acquisition cohorts: % of each cohort that orders again in month 1..6
WITH activity AS (
    SELECT DISTINCT customer_unique_id, cohort_month,
           (CAST(SUBSTR(order_month,1,4) AS INT)*12 + CAST(SUBSTR(order_month,6,2) AS INT))
         - (CAST(SUBSTR(cohort_month,1,4) AS INT)*12 + CAST(SUBSTR(cohort_month,6,2) AS INT)) AS month_age
    FROM customer_orders
), sizes AS (
    SELECT cohort_month, COUNT(DISTINCT customer_unique_id) AS cohort_size FROM activity GROUP BY 1
)
SELECT a.cohort_month, s.cohort_size,
       ROUND(100.0*COUNT(DISTINCT CASE WHEN month_age=1 THEN customer_unique_id END)/s.cohort_size,2) AS m1,
       ROUND(100.0*COUNT(DISTINCT CASE WHEN month_age=2 THEN customer_unique_id END)/s.cohort_size,2) AS m2,
       ROUND(100.0*COUNT(DISTINCT CASE WHEN month_age=3 THEN customer_unique_id END)/s.cohort_size,2) AS m3,
       ROUND(100.0*COUNT(DISTINCT CASE WHEN month_age=4 THEN customer_unique_id END)/s.cohort_size,2) AS m4,
       ROUND(100.0*COUNT(DISTINCT CASE WHEN month_age=5 THEN customer_unique_id END)/s.cohort_size,2) AS m5,
       ROUND(100.0*COUNT(DISTINCT CASE WHEN month_age=6 THEN customer_unique_id END)/s.cohort_size,2) AS m6
FROM activity a JOIN sizes s USING (cohort_month)
WHERE a.cohort_month BETWEEN '2017-01' AND '2018-02'
GROUP BY a.cohort_month, s.cohort_size ORDER BY a.cohort_month;
