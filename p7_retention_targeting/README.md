# Who should we contact first? A SQL propensity scorecard and a live retention-targeting dashboard

**Live dashboard:** https://yashbh18.github.io/analytics-portfolio/p7_retention_targeting/dashboard.html
**Data:** public Olist marketplace data (real orders). Train snapshot 1 Sep 2017 (21,664 customers), test snapshot 1 Mar 2018 (55,524 customers). Outcome: did the customer buy again within 180 days?
**Skills shown:** propensity modelling in SQL (time-split train/test, smoothed scorecard, NTILE deciles, lift and capture, AUC computed in SQL), avoiding overfitting, expected-profit targeting, interactive dashboard design

| | |
|---|---|
| **The question** | A win-back campaign costs money per contact. Which customers are worth contacting, and does a discount even pay on this marketplace? |
| **What I found** | Repeat buying is rare (1.2% in 180 days) and only weakly predictable: **AUC 0.573** out of time. 3- and 5-feature scorecards overfit and validated worse, so the **simplest recency × frequency scorecard won**. Still, the **top decile repeats at 2.0× the average and holds 20% of all repeat buyers**, and its prediction matched reality (2.34% vs 2.34%). The one strong signal: **recent customers with 2+ orders (1.1% of the base) come back ~5× more often**. |
| **What I'd do** | Paid discounts don't pay here: the best group breaks even at about **R$1.4 per contact** (30% uplift, 30% margin). Target the top groups only through near-free channels (email, push, WhatsApp opt-ins), and test with a 20% hold-out before scaling. |

## How the model works (all SQL)
1. `01_features.sql` builds recency, frequency, spend, last review and last-delivery features as of a snapshot, plus the 180-day outcome.
2. `02_train_scorecard.sql` learns a smoothed repeat rate per recency × frequency cell on the train snapshot.
3. `03_validate_deciles.sql` scores the later test snapshot with the train scorecard and checks actual repeat rate, lift and capture by decile; `03b_auc.sql` computes AUC with the Mann-Whitney rank formula in SQL.
4. `04_drivers.sql` shows the raw repeat rate behind each feature.
5. `05_dashboard_cells.sql` feeds the dashboard: customers, score, AOV and actual repeaters per group.

## Dashboard
Sliders for cost per contact, uplift and margin; KPIs for customers worth contacting, extra orders, revenue and profit; groups ranked by profit per contact with break-even cost; decile validation chart; CSV download of the contact list.

## Limitations
Uplift is an assumption until measured with a hold-out. Olist has few repeat customers, so cells with under ~100 customers are noisy.
