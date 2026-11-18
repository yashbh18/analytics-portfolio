-- Base view: clean video table with IST publish time, age, engagement and a channel-relative performance index
DROP VIEW IF EXISTS v;
CREATE VIEW v AS
WITH t AS (
  SELECT *,
    DATETIME(SUBSTR(pub,1,19), PRINTF('%+d hours', -CAST(SUBSTR(pub,20,3) AS INT)), '+330 minutes') AS pub_ist,
    CAST(comments AS INT) AS n_comments
  FROM videos_raw
), t2 AS (
  SELECT *,
    JULIANDAY(SUBSTR(scraped_at,1,19)) - JULIANDAY(pub_ist, '-330 minutes') AS age_days,
    CAST(STRFTIME('%H', pub_ist) AS INT)                                AS hour_ist,
    CASE STRFTIME('%w', pub_ist) WHEN '0' THEN '7 Sun' WHEN '1' THEN '1 Mon' WHEN '2' THEN '2 Tue'
         WHEN '3' THEN '3 Wed' WHEN '4' THEN '4 Thu' WHEN '5' THEN '5 Fri' ELSE '6 Sat' END AS weekday,
    1.0*(COALESCE(likes,0)+COALESCE(CAST(comments AS INT),0))/NULLIF(views,0) AS engagement_rate,
    CASE WHEN title LIKE '%?%' THEN 1 ELSE 0 END                       AS has_question,
    CASE WHEN title GLOB '*[0-9]*' THEN 1 ELSE 0 END                   AS has_number,
    CASE WHEN title LIKE '%|%' THEN 1 ELSE 0 END                       AS has_pipe,
    CASE WHEN title LIKE '%''%' OR title LIKE '%"%' OR title LIKE '%‘%' OR title LIKE '%“%' THEN 1 ELSE 0 END AS has_quote,
    LENGTH(title)                                                       AS title_len,
    CASE
      WHEN LOWER(title) GLOB '*cricket*' OR LOWER(title) GLOB '*asia cup*' OR LOWER(title) GLOB '*highlights*' OR LOWER(title) GLOB '*ipl*' THEN 'Sports'
      WHEN LOWER(title) GLOB '*trump*' OR LOWER(title) GLOB '*china*' OR LOWER(title) GLOB '*pakistan*' OR LOWER(title) GLOB '*russia*'
        OR LOWER(title) GLOB '*ukraine*' OR LOWER(title) GLOB '*israel*' OR LOWER(title) GLOB '*iran*' OR LOWER(title) GLOB '* war*'
        OR LOWER(title) GLOB '*tariff*' OR LOWER(title) GLOB '*putin*' OR LOWER(title) GLOB '*us *' THEN 'Geopolitics & world'
      WHEN LOWER(title) GLOB '*stock*' OR LOWER(title) GLOB '*market*' OR LOWER(title) GLOB '*sensex*' OR LOWER(title) GLOB '*nifty*'
        OR LOWER(title) GLOB '*share*' OR LOWER(title) GLOB '*ipo*' OR LOWER(title) GLOB '*invest*' OR LOWER(title) GLOB '*gold*' THEN 'Markets & investing'
      WHEN LOWER(title) GLOB '* ai*' OR LOWER(title) GLOB '*ai *' OR LOWER(title) GLOB '*tech*' OR LOWER(title) GLOB '*nvidia*'
        OR LOWER(title) GLOB '*startup*' OR LOWER(title) GLOB '*elon*' OR LOWER(title) GLOB '*apple*' THEN 'Tech, AI & startups'
      WHEN LOWER(title) GLOB '*tax*' OR LOWER(title) GLOB '*salary*' OR LOWER(title) GLOB '*loan*' OR LOWER(title) GLOB '*emi*'
        OR LOWER(title) GLOB '*rbi*' OR LOWER(title) GLOB '*bank*' OR LOWER(title) GLOB '*money*' THEN 'Personal finance & banking'
      WHEN LOWER(title) GLOB '*modi*' OR LOWER(title) GLOB '*bjp*' OR LOWER(title) GLOB '*congress*' OR LOWER(title) GLOB '*rahul*'
        OR LOWER(title) GLOB '*election*' OR LOWER(title) GLOB '*bihar*' OR LOWER(title) GLOB '*minister*' THEN 'Indian politics'
      ELSE 'Other / general news' END AS topic
  FROM t
)
SELECT *, CASE WHEN format='short' THEN 'Short'
               WHEN secs < 180 THEN '1. <3 min' WHEN secs < 600 THEN '2. 3-10 min'
               WHEN secs < 1800 THEN '3. 10-30 min' ELSE '4. 30+ min' END AS length_bucket
FROM t2
WHERE age_days >= 1;   -- drop videos under 24h old (news views mostly accrue in the first day)
