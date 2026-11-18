# UPI at 25 billion a month: is growth slowing, and what changes for payment companies?

**Data:** real NPCI UPI Product Statistics, 107 months from June 2016 to October 2026 (banks live, volume, value), collected 18 Nov 2026 from npci.org.in. NPCI's site leaves out April–May for FY2016-17 to FY2025-26, so yearly comparisons use the same June–March window every year.
**Skills shown:** SQL (views, self-joins for YoY, LAG, window running totals, milestone detection), like-for-like comparisons with missing data, Excel forecasting with live formulas (SLOPE/LN log-linear trend, scenario inputs, INDEX/MATCH), payments domain thinking

| | |
|---|---|
| **The question** | UPI keeps setting records. Is growth actually slowing, what is driving it, and what should a payments company (PSP, wallet, bank) plan for next? |
| **What I found** | **Growth is roughly halving every two years:** volume growth fell from 103% (FY21-22) to 77%, 56%, 40% and **29% in FY25-26**; monthly YoY is now ~22–23%. **Value grows slower than volume every year since FY22-23**, so the **average ticket fell from ₹1,858 to ₹1,293** (Aug 2026: ₹1,217, the lowest since 2018). Banks live grew only 6.7% in FY25-26 while volume per bank grew 16%, so **growth now comes from deeper use, not new banks**. On the current trend UPI **crosses 30 bn transactions a month around Aug 2027**. |
| **What I'd do** | For a PSP: compete on frequency and small-ticket UX (UPI Lite, one-tap repeat payments), monetise through adjacent products (credit on UPI, merchant tools) because per-transaction value is shrinking, and plan capacity for ~30 bn/month by late 2027. |

## Findings (each backed by a query in `/sql`)
| # | Finding | Query |
|---|---|---|
| 1 | Monthly YoY volume growth slid from ~35% (mid-2025) to ~22–23% (mid-2026); value growth sits 3–7 points lower. | 01 |
| 2 | June–March like-for-like: volume growth 103% → 77% → 56% → 40.5% → 29.3% across FY21-22 to FY25-26; value growth 99% → 20%. | 02 |
| 3 | Average ticket by calendar year: ₹1,840 (2021) → ₹1,691 → ₹1,549 → ₹1,427 → ₹1,307 → ₹1,271 (2026 YTD). | 03 |
| 4 | Banks live: 705 in Mar 2026 (+6.7%), while volume per bank rose 16% to 32 mn a month. | 04 |
| 5 | Milestones: 10 bn a month (Aug 2023) → 20 bn (Aug 2025) took 24 months; 25 bn arrived in Oct 2026. | 05 |

## Excel forecast (`UPI_Forecast.xlsx`, 685 live formulas)
Log-linear trend on the latest 13 contiguous months gives **1.69% a month (~22% a year)** and a 30 bn month in **Aug 2027**. A yellow "growth haircut" input lets you test slower scenarios; the milestone month and the chart update automatically. The data sheet computes ticket size, daily averages and YoY with formulas.

## Limitations
Volume is a flow of transactions, not users, so frequency per user can't be separated from new users. The trend forecast assumes the recent growth rate holds and ignores policy shocks (e.g. MDR changes).

## Files
`data/upi_monthly_npci.csv` raw data · `sql/00_base_view.sql` + `01–05_*.sql` · `dashboard_data/` outputs · `UPI_Forecast.xlsx` · `charts/`.
