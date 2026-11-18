# Revenue, category & payment deep-dive in SQL

**Data:** Olist Brazilian e-commerce (public; 96K delivered orders, Jan-2017 to Aug-2018)
**Skills shown:** SQL time-series (LAG for MoM, rolling 3-month average), YoY like-for-like comparison, Pareto analysis with cumulative SUM OVER, RANK, payment/instalment analysis, testing (and rejecting) a hypothesis

| | |
|---|---|
| **Business question** | What is driving revenue growth: more buyers or bigger baskets? Which categories and payment options matter most, and is freight cost hurting customers? |
| **Approach** | Built monthly GMV, orders and AOV with month-over-month change and a rolling average; compared Jan–Aug 2018 vs 2017; ranked categories with a cumulative Pareto; compared H1-18 vs H1-17 growth by category; analysed payment mix and credit-card instalments vs basket size; tested freight-share vs reviews. |
| **Impact** | GMV grew **2.4× YoY (R$3.47M → R$8.45M, Jan–Aug)**, driven almost entirely by **2.4× more buyers** while AOV stayed flat (R$158 → R$160), so growth is volume-led with no basket-size lever pulled. **7+ instalment orders are 16% of card orders but 32% of card GMV (AOV R$334 vs R$101 for single payments)**, which makes instalments the strongest AOV lever. Growth plateaued at ~R$1.0–1.1M/month from Jan-18. |

## Findings
| # | Finding | Query |
|---|---|---|
| 1 | Nov-17 (Black Friday) was the peak at R$1.15M (+54% MoM); after Jan-18, monthly GMV is flat at R$1.0–1.13M, so growth has stalled. | 01 |
| 2 | Jan–Aug 2018 vs 2017: orders 22.0K → 52.8K, buyers 21.4K → 51.6K, AOV R$158 → R$160. | 02 |
| 3 | **Pareto:** the top 7 of 70+ categories make ~50% of item revenue; top 20 make 84%. Health & beauty (9.3%) and watches & gifts (8.8%) lead. | 03 |
| 4 | Fastest growers H1-18 vs H1-17: watches & gifts +R$392K (+298%), health & beauty +R$373K (+232%), baby +522%. | 04 |
| 5 | Credit card 75.5% of orders (avg 3.5 instalments), boleto 19.9%, voucher 3.1%. | 05 |
| 6 | **Instalments drive basket size:** 1x R$101, 2–3x R$135, 4–6x R$182, 7x+ R$334 AOV. | 06 |
| 7 | **Hypothesis rejected:** freight share of price barely moves reviews (4.21 at <10% vs 4.11 at 40%+). Delivery speed (Project 1) matters far more than freight cost. | 07 |
| 8 | SP is 37% of GMV but has the lowest AOV (R$143); BA/GO have the highest (R$171–182). | 08 |

## Recommendations
1. **Lift AOV, not just traffic:** promote "no-interest 6x/10x" on products above R$150 and test an instalment-threshold banner (A/B test design in Project 4).
2. **Double down on the growth categories** (watches & gifts, health & beauty, baby) in acquisition budgets; they also sit at the top of the Pareto.
3. **Spend on delivery speed before freight discounts**, since freight cost didn't change reviews but lateness did.
4. Track a weekly GMV bridge: buyers × orders per buyer × AOV, so a stall like 2018 is caught early.

## Dashboard spec (Power BI / Looker Studio, data in `/dashboard_data`)
GMV trend with MoM % and 3-month rolling line (`01`), YoY KPI cards (`02`), Pareto bar + cumulative line (`03`), category growth waterfall (`04`), payment donut + instalment AOV bars (`05`, `06`).

## Files
`sql/01–08_*.sql` (uses the `customer_orders` view from Project 2 and `delivered_orders` from Project 1) · `dashboard_data/` query outputs.
