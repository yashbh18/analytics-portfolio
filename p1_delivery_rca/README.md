# Late deliveries & bad reviews: root-cause analysis in SQL

**Data:** Olist Brazilian e-commerce marketplace (public, 96K delivered orders, 2016–2018)
**Skills shown:** SQL (multi-table joins, CTEs, window functions: ROW_NUMBER, NTILE, RANK), funnel/lifecycle breakdown, root-cause analysis, opportunity sizing, KPI and dashboard design (Power BI / Looker Studio)

| | |
|---|---|
| **Business question** | Review scores fell sharply in some months. What drives 1–2★ reviews, where in the order lifecycle does it start, who owns the fix, and what is it worth? |
| **Approach** | Built one clean delivered-orders view (orders + customers + items + de-duplicated reviews). Measured delivery vs promised date, broke each order into approval → seller prep → carrier transit, then cut by state, seller decile, category and month. Built a seller SLA scorecard and sized the fix in orders, reviews and GMV. |
| **Impact** | Late orders get **6× more 1–2★ reviews (54% vs 9%)**. Late seller hand-over makes an order **3.8× more likely to arrive late (24.4% vs 6.5%)**, and **30% of sellers cause 54% of late orders**. Fixing the late hand-overs alone removes **~1,560 late orders (20% of all late) and ~700 bad reviews**, protecting part of **R$1.35M GMV** shipped late. |

## Findings (each backed by a query in `/sql`)
| # | Finding | Query |
|---|---|---|
| 1 | 8.0% of delivered orders arrive late; their average review is 2.57 vs 4.29 on time. | 01 |
| 2 | **The 4-day cliff:** 1–3 days late → 19% bad reviews; 4–7 days → 61%; 8+ days → 78%. Customers forgive a short delay, not a long one. | 02 |
| 3 | Late orders lose most days in transit (25.7 vs 7.9 days) and also sit twice as long with the seller (5.3 vs 2.6 days), while their promised window was slightly shorter (22 vs 24 days). | 09 |
| 4 | **The controllable lever is the seller:** a late hand-over lifts late-delivery risk from 6.5% to 24.4%. | 03 |
| 5 | **Concentrated:** the worst 3 seller deciles cause 54% of late orders. The scorecard flags sellers with 30–50% late hand-overs, including one high-volume seller (966 orders, R$137K GMV, 3.5★). | 05, 11 |
| 6 | **Geography & peaks:** CE, BA and RJ run 13–15% late vs 6% in SP. Late rate hit 14% in Nov-17 (Black Friday) and 16–21% in Feb–Mar-18, the two lowest-rated periods. | 04, 06 |
| 7 | Electronics and telephony combine high late rates with freight at 51–69% of item price. | 10 |
| 8 | **Retention cost:** 7,611 customers had a late first order; they repeat 2.60% vs 3.04% on time (–14% relative). | 07, 12 |

## Recommendations (with owner and metric)
| Recommendation | Owner | Success metric |
|---|---|---|
| Seller SLA alert when an order passes `shipping_limit_date`; weekly scorecard; coach, then penalise the bottom decile | Seller ops | Late hand-over % (target –50% in bottom 3 deciles) |
| Dynamic ETA buffer for CE/BA/RJ and for peak months instead of one national promise | Logistics / product | Late rate by state; review score |
| Proactive "delayed" message + voucher when an order is projected 3+ days late (before the 4-day cliff) | CX / CRM | 1–2★ share on late orders |
| Monitor first-order delivery for new customers as a retention KPI | Growth | Repeat rate of first-order-late cohort |

## Dashboard spec (rebuild in Power BI or Looker Studio from `/dashboard_data`)
- **KPI cards:** late %, avg review (late vs on time), late-order GMV, bad reviews avoided.
- **Trend:** monthly late % vs avg review (dual axis): `06_monthly_trend.csv`.
- **Cliff chart:** bad-review % by delay bucket: `02_delay_buckets.csv`.
- **Map / bar:** late % by state: `04_state_late_rate.csv`.
- **Seller scorecard table** with conditional formatting: `11_seller_scorecard.csv`.

## Files
`sql/00_base_view.sql` creates the view all queries use · `sql/01–12_*.sql` one business question each · `dashboard_data/` the result of every query as CSV · `charts/` sample visuals.
