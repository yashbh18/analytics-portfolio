# What wins on Indian business-news YouTube? A content-performance audit of ET vs 5 peers

**Data:** real, public YouTube data I collected on 18 Nov 2026: 1,860 recent uploads (long-form + Shorts) from **The Economic Times, Moneycontrol, CNBC-TV18, Business Today, Mint and NDTV Profit** (views, likes, comments, duration, publish time). Not a Kaggle dataset. Raw file in `data/videos_raw.csv`.
**Skills shown:** SQL (views, CTEs, window functions for channel-level medians, CASE-based topic and title tagging, time-zone conversion), outlier-robust metric design, competitive benchmarking, content strategy, opportunity sizing

| | |
|---|---|
| **Business question** | ET's YouTube team has to choose where to put editing capacity. Which formats, topics, lengths and title styles actually win reach, and where is ET behind its peers? |
| **Approach** | Converted publish times to IST and dropped videos under 24h old. Built a **performance index** (views ÷ the same channel's median for that format) so a 3M-subscriber and a 1M-subscriber channel compare fairly. Measured **breakout rate** (share of videos at 2×+ their channel median) instead of averages, because a few viral videos (one at 1,000× median) wreck any mean. Then cut by format, length, topic, title features and hour, and benchmarked ET against the peer average. |
| **Impact** | **ET has almost stopped posting Shorts: about 1 a week vs 41–300 a week at peers**, even though ET's Shorts get a median 7.3K views, 1.7× its own long-form. At 5 Shorts a day at today's median, that is **~1.1M extra views a month, about +54% on ET's current long-form base**. ET also has the **highest engagement of the six (1.6% vs 0.4–0.6%)** and out-draws peers ~1.9× on markets content, but publishes very little of it. |

## Findings
| # | Finding | Query |
|---|---|---|
| 1 | Upload volume ranges from ~100 (Mint, ET) to ~1,080 (CNBC-TV18) long-form videos a week. ET's engagement rate is the highest: 1.63% on long-form, 2.92% on Shorts. | 01 |
| 2 | **Shorts are a reach engine for peers:** NDTV Profit and CNBC-TV18 Shorts get 2.5–2.6× their long-form median, and Shorts bring 38–61% of their views. ET Shorts bring 18% from a handful of uploads. | 02 |
| 3 | **Longer beats clips:** 10–30 min videos break out 39% of the time vs 24% for clips under 3 minutes, with 2.5× the engagement. | 03 |
| 4 | 06–10 IST is the weakest slot (21% breakout); late night and early morning uploads (22–06 IST) break out 36–37%, likely from less competition. Small samples, so treat as a test idea. | 04 |
| 5 | **Supply vs demand mismatch:** geopolitics is 35% of all uploads but beats its channel median only 52% of the time; Indian politics (59%), personal finance (61%) and markets (55%) do better while getting 2–12% of uploads. | 05 |
| 6 | **Titles:** 80+ character titles break out 35.6% vs 21.6% for short ones (+14pp); direct quotes add +7pp. Numbers and pipe separators make little difference. | 06 |
| 7 | **ET vs peers:** ET long-form beats the peer average on markets (1.9×), Indian politics (1.7×) and general news (1.6×) but made only 5–9 videos in those topics in the window; ET Shorts on geopolitics get half the peer average. | 07 |

## Recommendations (with owner and metric)
| Recommendation | Owner | Success metric |
|---|---|---|
| Restart Shorts: cut 3–5 vertical clips a day from existing long-form interviews | Video / social team | Shorts views per week; share of channel views from Shorts |
| Shift part of geopolitics output to markets, personal finance and Indian politics, where ET already out-performs | Editorial | Breakout rate by topic |
| Default to 10–30 min explainers over sub-3-min clips; write descriptive 80+ character titles with a direct quote | Video producers | Breakout rate, engagement % |
| A/B test the 22–06 IST slot for evergreen uploads | Channel ops | Breakout rate by slot |

## Caveats
One snapshot of the most recent uploads (about 2 weeks for most channels, so weekday effects aren't reliable). Young videos are still gaining views; the 24h filter plus within-channel normalisation reduces, but doesn't remove, this. Topics are tagged by title keywords, so a few videos are mis-tagged. Next step: re-collect weekly to track final views.

## Dashboard spec (Power BI / Looker Studio, data in `/dashboard_data`)
Channel scorecard table (`01`), Shorts vs long-form bars (`02`), topic supply vs demand (`05`), title-feature lift (`06`), ET vs peer heatmap (`07`), breakout video list (`08`).

## Files
`data/videos_raw.csv` raw data · `sql/00_base_view.sql`, `00b_performance_index.sql` set-up · `sql/01–08_*.sql` one question each · `dashboard_data/` outputs · `charts/`.
