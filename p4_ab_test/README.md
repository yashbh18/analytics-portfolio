# A/B test design & readout in Excel

**Data:** SIMULATED 21-day checkout experiment (231K sessions), clearly labelled. Built to show experiment design and decision-making, not to claim a real result.
**Skills shown:** Experiment design (hypothesis, primary and guardrail metrics, power and sample size), two-proportion z-test, confidence intervals, sample-ratio-mismatch (chi-square) check, segment analysis with Bonferroni correction, novelty-effect check, annualised impact, and a written ship/no-ship recommendation. Everything is live Excel formulas (SUMIFS, NORM.S.INV, NORM.S.DIST, CHISQ.TEST, INDIRECT), so changing an input recalculates the whole readout.

| | |
|---|---|
| **Business question** | Does showing a delivery date + "free returns" badge at checkout raise conversion, without hurting refunds or basket size? Should we ship it? |
| **Approach** | Sized the test (77,062 sessions per arm for an 8% relative lift on a 3.2% baseline), ran 3 full weeks, checked the traffic split, tested the primary metric and guardrails, cut by device and user type, and checked whether the lift faded after the first days. |
| **Impact / decision** | Conversion **+7.3% (95% CI +2.7% to +11.8%, p = 0.002)**; revenue per session +5.5%. **But refund rate rose from 4.26% to 6.15% (guardrail breach)**, and the win is almost all **mobile (+12.0%, significant)** vs desktop +1.6% (not significant). Net of reversed orders and handling, the annual upside is ~₹7.2M vs ₹12.0M gross. **Decision: ship to mobile only, behind a flag, after re-testing without the free-returns badge.** |

## Workbook tabs
| Tab | What it shows |
|---|---|
| `0_Decision_memo` | One-page recommendation; every sentence is built from formulas |
| `1_Design` | Hypothesis, metrics, inputs (yellow), sample size and runtime |
| `2_Results` | CR, RPV, AOV and refund-rate tests, CIs, SRM check, annualised impact |
| `3_Segments` | Mobile / desktop / new / returning with Bonferroni-adjusted alpha |
| `4_Daily_trend` | Cumulative lift by day, novelty check, chart |
| `Data` | 168 rows of daily aggregates (day × arm × device × user type) |

## Files
`AB_Test_Readout.xlsx` the workbook · `simulated_experiment.csv.gz` session-level simulated data · `charts/` sample visuals.
