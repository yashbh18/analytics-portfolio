# Customer retention, cohorts & RFM segmentation in SQL

**Data:** Olist Brazilian e-commerce (public; 96K delivered orders, 93K unique customers, R$15.4M revenue)
**Skills shown:** SQL window functions (ROW_NUMBER, MIN() OVER, NTILE, running totals), cohort retention matrix, RFM segmentation, CRM targeting, opportunity sizing

| | |
|---|---|
| **Business question** | Is the marketplace keeping customers? Which customers should CRM target first, and what is a win-back campaign worth? |
| **Approach** | Built a customer-orders view with each customer's order sequence and cohort month. Measured repeat rate and time to second order, built a monthly cohort retention matrix, scored every customer on Recency and Monetary quintiles (NTILE) with a repeat flag, and mapped them to 6 named segments. Then ranked first-purchase categories by repeat rate and sized a win-back campaign. |
| **Impact** | Only **3.0% of customers ever buy again** and they bring 5.6% of revenue, so growth is almost entirely acquisition-led. **22% of customers ("At-risk high-value") hold 40% of revenue** and average R$298. Reactivating just **5% of them once is worth ~R$309K (+2.0% revenue)**; 10% is worth ~R$618K. |

## Findings
| # | Finding | Query |
|---|---|---|
| 1 | 93,357 customers; 3.0% repeat; repeat buyers bring 5.6% of revenue. | 01 |
| 2 | **54% of second orders happen within 90 days** (29% inside 30 days), so the win-back window is the first quarter after purchase. | 02 |
| 3 | Month-1 retention is below 1% for every cohort (0.2–0.7%). Retention never builds, even for the big Nov-17 Black Friday cohort (7,060 buyers, 0.57% in month 1). | 03 |
| 4 | **Segments:** At-risk high-value 22% of customers / 40% of revenue; New high-value 15% / 28%; Hibernating low-value 36% / 16%; New low-value 23% / 10%; Loyal repeaters 1.9% / 3.7%. | 04 |
| 5 | Repeat rate depends on the first category: fashion bags 5.7%, furniture/decor 4.5%, bed/bath 4.4% vs electronics 1.6%. | 05 |
| 6 | Win-back sizing: 3% → R$185K, 5% → R$309K, 10% → R$618K. | 06 |

## Recommendations
1. **Win-back flow for At-risk high-value** at day 60–90 (category-matched offers). KPI: reactivation %, revenue per contacted customer, with a hold-out group.
2. **Second-order nudge inside 30 days** for New high-value customers. KPI: 90-day repeat rate.
3. **Use home/decor/bed-bath as acquisition categories** in paid campaigns because those buyers come back 2–3× more than electronics buyers.
4. Don't discount to Hibernating low-value customers; they are 36% of the base but low value.

## Dashboard spec (Power BI / Looker Studio, data in `/dashboard_data`)
Cohort heatmap (`03`), segment treemap with revenue share (`04`), days-to-second-order histogram (`02`), category repeat bar (`05`), and a what-if slider for reactivation rate (`06`).

## Files
`sql/00_customer_orders.sql` builds the base view · `sql/01–06_*.sql` one question each · `dashboard_data/` query outputs · `charts/` sample visuals.
