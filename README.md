# Yashika Bhatia: Analytics Portfolio

Seven end-to-end projects showing how I take a business question to a sized recommendation.
**Tools:** SQL · Excel / Google Sheets · Power BI / Looker Studio

| # | Project | Skills | Headline impact |
|---|---|---|---|
| 1 | [Late deliveries & bad reviews: RCA](p1_delivery_rca) | SQL joins, CTEs, window functions, lifecycle breakdown, seller scorecard | Late orders get 6× more 1–2★ reviews; 30% of sellers cause 54% of late orders; fix worth ~1,560 fewer late orders and ~700 fewer bad reviews |
| 2 | [Retention, cohorts & RFM](p2_cohort_rfm) | Cohort matrix, NTILE RFM scoring, segmentation, CRM sizing | 22% of customers hold 40% of revenue; 5% win-back = ~R$309K |
| 3 | [Revenue, category & payment deep-dive](p3_revenue_deepdive) | LAG/MoM, YoY, Pareto, instalment analysis, hypothesis testing | Growth is almost entirely volume-led (AOV flat); 7x+ instalments = 32% of card GMV at 3.3× AOV |
| 4 | [A/B test design & readout](p4_ab_test) | Power/sample size, z-test, CI, SRM, guardrails, Bonferroni, Excel modelling | +7.3% conversion but refund-rate breach, so shipped to mobile only (~₹7.2M net/yr) |
| 5 | [Indian business-news YouTube audit: ET vs 5 peers](p5_news_youtube) | Real scraped data (1,860 videos), SQL window functions, outlier-robust index, benchmarking | ET posts ~1 Short/week vs 41–300 at peers; restarting at 5/day ≈ +1.1M views/month (+54%) |
| 6 | [UPI at 25 bn a month: is growth slowing?](p6_upi_payments) | Real NPCI data (107 months), SQL YoY self-joins, Excel log-linear forecast | Growth halving every ~2 years (29% in FY25-26); avg ticket ₹1,858 → ₹1,293; 30 bn/month ≈ Aug 2027 |
| 7 | [Who should we contact first? (live dashboard)](p7_retention_targeting) | SQL propensity scorecard, out-of-time validation, AUC in SQL, expected-profit targeting | Top decile 2× repeat rate, 20% of repeaters; discounts only pay under ~R$1.4 per contact |

**Data:** Projects 1–3 use the public [Olist Brazilian e-commerce dataset](https://github.com/olist/work-at-olist-data). Project 4 uses clearly labelled simulated data. Project 5 uses public YouTube data and Project 6 uses NPCI data, both collected in Nov 2026.
**Run it:** load the Olist CSVs into any SQL database (SQLite, PostgreSQL, MySQL with minor date-function changes), run each project's `00_*` view file, then the numbered queries. Every result is saved in `dashboard_data/` for Power BI / Looker Studio.
