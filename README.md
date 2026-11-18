# Yashika Bhatia: Analytics Portfolio

Four end-to-end projects showing how I take a business question to a sized recommendation.
**Tools:** SQL · Excel / Google Sheets · Power BI / Looker Studio

| # | Project | Skills | Headline impact |
|---|---|---|---|
| 1 | [Late deliveries & bad reviews: RCA](p1_delivery_rca) | SQL joins, CTEs, window functions, lifecycle breakdown, seller scorecard | Late orders get 6× more 1–2★ reviews; 30% of sellers cause 54% of late orders; fix worth ~1,560 fewer late orders and ~700 fewer bad reviews |
| 2 | [Retention, cohorts & RFM](p2_cohort_rfm) | Cohort matrix, NTILE RFM scoring, segmentation, CRM sizing | 22% of customers hold 40% of revenue; 5% win-back = ~R$309K |
| 3 | [Revenue, category & payment deep-dive](p3_revenue_deepdive) | LAG/MoM, YoY, Pareto, instalment analysis, hypothesis testing | Growth is almost entirely volume-led (AOV flat); 7x+ instalments = 32% of card GMV at 3.3× AOV |
| 4 | [A/B test design & readout](p4_ab_test) | Power/sample size, z-test, CI, SRM, guardrails, Bonferroni, Excel modelling | +7.3% conversion but refund-rate breach, so shipped to mobile only (~₹7.2M net/yr) |

**Data:** Projects 1–3 use the public [Olist Brazilian e-commerce dataset](https://github.com/olist/work-at-olist-data). Project 4 uses clearly labelled simulated data.
**Run it:** load the Olist CSVs into any SQL database (SQLite, PostgreSQL, MySQL with minor date-function changes), run each project's `00_*` view file, then the numbered queries. Every result is saved in `dashboard_data/` for Power BI / Looker Studio.
