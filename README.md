# B2B SaaS Customer Retention & Churn Analysis

An end-to-end analysis of customer retention and revenue churn for a B2B SaaS company with 1,200 accounts and $971.4K in Monthly Recurring Revenue (MRR). Five relational Kaggle datasets were cleaned in Excel Power Query, modelled as a star schema in Power BI, shown in a 2-page interactive dashboard, and cross-checked in MySQL with five SQL scripts.

## 📌 Project Overview

Recurring revenue only compounds when accounts stay and pay. This project shows where the company is losing revenue, which segments are most exposed, and which billing, support and adoption signals sit alongside churn risk.

- **Revenue retention:** MRR by plan, churned vs. past-due MRR, churn by industry.
- **Operational health:** support volume, resolution time, CSAT, overdue invoices, seat utilization.
- **SQL validation:** five MySQL scripts that reproduce or extend dashboard figures.

**Workflow:** Kaggle CSVs → Excel / Power Query → Power BI star schema → 2-page dashboard → MySQL → SQL validation

## 🎯 Business Objectives

- Identify where revenue is lost, by plan, industry and company size.
- Separate permanent churn from revenue still at risk (past-due accounts).
- Compare industries by churn rate and by dollar loss.
- Locate overdue invoice balances and the segments holding them.
- Assess support performance and product adoption (seat utilization).
- Turn findings into practical retention actions.

## 📊 Dataset

**Source:** Kaggle B2B SaaS dataset (5 relational CSV files)

| Table | Description | Records |
| ----- | ----------- | ------: |
| `accounts` | Company data: industry, country, employee count, plan, company size | 1,200 |
| `subscriptions` | Seats, MRR, status (active / churned / past_due), start and end dates, churn and past-due flags | 1,200 |
| `invoices` | Amount, invoice date, status (paid / open / void / uncollectible), unpaid flag | 14,500 |
| `support_tickets` | Category, priority, resolution hours, CSAT score, ticket status | 5,600 |
| `users` | Users per account with roles (Admin / Member / Viewer) | 21,884 |
| **Total** | | **44,384** |

## 🛠️ Tools & Technologies

- **Data preparation:** Microsoft Excel, Power Query
- **Modelling & BI:** Power BI Desktop, DAX, star schema design
- **Database & validation:** MySQL, MySQL Workbench, SQL (joins, aggregations, `CASE WHEN`, `HAVING`, CTEs)

## 🔄 Data Preparation & Cleaning

All five CSV files were cleaned in **Excel Power Query** before loading into Power BI:

- Handled null values and verified data types (dates, numerics, flags).
- Added a `Dim_Date` table (Date, Month, MonthNumber, Quarter, Year).
- Added a `Priority_Order` field to `Support_Tickets` for priority sorting.
- Used source flags (`is_churned`, `is_past_due`, `is_unpaid`) for churn, at-risk and overdue measures.
- Kept `account_id` consistent across all tables.

**MySQL load:** the cleaned data was loaded into a `saas_analytics` database using `00_schema_and_database_setup.sql`, which creates the five tables and runs a row-count check. Date fields, `satisfaction_score` and `resolution_hours` were staged as text, so queries cast them explicitly. Status values are handled case-insensitively to match the Power BI logic.

## 🧩 Data Modeling

A **star schema** centred on `Accounts` and `Dim_Date`, with all relationships **one-to-many (1:\*)**. This keeps DAX measures fast and avoids circular relationships.

- **Fact tables:** `Subscriptions` (MRR, seats, churn), `Invoices` (billing), `Support_Tickets` (SLA, CSAT)
- **Dimension tables:** `Accounts`, `Dim_Date`, `Users` (user adoption)

![Star Schema](Star-Schema-Model.png)

One account dimension filters all fact tables, so the Plan, Industry, Company Size and Year slicers work consistently across both pages.

## 📈 Power BI Dashboard

A **2-page interactive dashboard** with shared slicers: **Plan, Industry, Company Size, Year**.

### Page 1 — Executive Revenue Retention & Churn Overview

![Page 1](dashboard-views/Page1_Executive_Revenue_Overview.png)

- **Purpose:** show how much recurring revenue is secure, lost or at risk, and where.
- **KPIs:** Total Portfolio MRR, Lost MRR, Customer Churn Rate %, Total Paying Accounts
- **Visuals:** Total vs Lost MRR by Plan, MRR at Risk Breakdown, Churn Rate by Industry, Lost Revenue by Industry & Plan

### Page 2 — Customer Health & Churn Risk Diagnostics

![Page 2](dashboard-views/Page2_Customer_Health_Diagnostics.png)

- **Purpose:** show the operational signals around churn risk: support, billing and adoption.
- **KPIs:** Seat Utilization %, Avg CSAT Score, Overdue Balance, Avg Resolution Time (Hrs)
- **Visuals:** Ticket Volume by Category & Priority, Overdue Balance by Company Size, Ticket Resolution Status, Seat Utilization by Plan

## ❓ Business Questions Answered

1. Which plans drive revenue, and where is lost revenue concentrated?
2. What share of MRR is secure, churned, or at risk through failed payments?
3. Which industries have the highest churn rates?
4. Which industries cause the largest dollar loss, and how does that differ from churn rate?
5. Which support categories generate the most volume and urgent tickets, and which are slowest to resolve?
6. Where is the overdue invoice balance concentrated?
7. What share of support tickets is resolved vs. open?
8. Are customers using the seats they purchased, across plans?
9. Which high-value accounts show combined risk signals and need intervention first?

## 📊 Key KPIs

| KPI | Value | Definition | Business Purpose |
| --- | ----: | ---------- | ---------------- |
| Total Portfolio MRR | $971.4K | Monthly recurring revenue across all 1,200 accounts | Baseline revenue exposure |
| Lost MRR | $91.8K | Churned MRR ($58.5K) + past-due MRR ($33.3K) | Revenue lost or at immediate risk |
| Customer Churn Rate | 10.33% | Churned accounts ÷ total accounts (124 of 1,200) | Headline retention metric |
| Total Paying Accounts | 1,200 | Total accounts in the portfolio | Denominator for account metrics |
| Seat Utilization | 77.8% | Assigned users ÷ purchased seats | Adoption and downgrade-risk signal |
| Avg CSAT Score | 4.03 / 5 | Average satisfaction score on tickets | Customer sentiment on support |
| Overdue Balance | $739.60K | Unpaid balance on open invoices (void excluded) | Collections exposure |
| Avg Resolution Time | 40.8 hrs | Average hours to resolve a ticket | Support efficiency |

## 🔍 Key Business Insights

**1. Revenue and dollar loss sit mainly in the higher tiers.**
Active MRR: Business $431.3K, Growth $235.7K, Enterprise $184.1K, Starter $28.5K. Lost MRR: $21.8K, $18.8K, $15.0K, $2.9K. Starter is about 44% of accounts (524 of 1,200) but a small share of the loss. → *Weight retention effort by revenue, not account count.*

**2. $33.3K of MRR is past due and still recoverable.**
90.55% ($880K) of MRR is active, 6.03% ($59K) churned, 3.43% ($33K) past due. → *Recovering failed payments is a lower-effort lever than winning back cancelled accounts.*

**3. The highest-churn industry is not the biggest dollar loss.**
Retail (12.8%) and Healthcare (11.9%) churn most, against a 10.33% average. Software (10.5%) loses the most, about $35K of MRR, versus about $14K for Retail. → *Prioritising by churn rate alone would misdirect effort.*

**4. Education (8.0%) and Financial Services (8.9%) are the most stable industries.** → *Useful benchmarks for healthy retention.*

**5. Overdue invoices are concentrated in Enterprise.**
Enterprise holds $524.35K (70.9%) of the $739.60K overdue balance across 157 open invoices (average ≈ $3,340). Mid-Market holds $192.73K and Small holds $22.52K. → *A few large invoices drive most of the collections exposure.*

**6. Integrations and Billing are the main support pain points.**
In the resolved-ticket sample, Integrations has the most tickets (1,171) and urgent ones (101), followed by Bug Reports (1,046; 76 urgent). Billing is slowest (42.8 hrs) with the lowest CSAT (3.96). → *Billing issues overlap with the overdue and past-due revenue problem.*

**7. The support backlog is small and seat usage is fairly even.**
91.59% of tickets are resolved and 8.41% are open. Seat utilization is 84.7% (Business), 82.3% (Starter), 80.2% (Enterprise), 78.6% (Growth), against 77.8% overall. → *Revenue risk sits mainly in billing and high-tier churn. The SQL layer flags account-level adoption gaps.*

## 🗄️ SQL Validation

After the Power BI analysis, the cleaned data was loaded into **MySQL** (`saas_analytics`) and queried in **MySQL Workbench**. Five scripts cross-check the dashboard logic and extend it to account level.

| # | Script | What It Validates |
| - | ------ | ----------------- |
| 1 | `01_mrr_and_churn_by_plan.sql` | Accounts, active MRR, lost MRR and churn rate by plan. Matches the Total vs Lost MRR chart ($58.5K churned, about $880K active). |
| 2 | `02_overdue_balance_by_company_size.sql` | Open invoices, overdue balance and average invoice size by company size. Matches the $739.60K KPI. |
| 3 | `03_license_seat_utilization.sql` | Seat utilization for active accounts, flagging those below 65%. |
| 4 | `04_support_sla_and_csat_analysis.sql` | Tickets, urgent tickets, resolution hours and CSAT by category (resolved tickets). |
| 5 | `05_top_10_high_risk_accounts.sql` | Top 10 accounts by MRR with overdue balances, urgent open tickets or seat utilization below 50%, built with CTEs. |

Reproducing the dashboard totals from the database confirms the DAX measures, relationships and filters match independent queries. Scripts 3 and 5 turn segment-level findings into account-level action lists.

## 🔁 End-to-End Workflow

```text
Kaggle Datasets (5 CSV files)
        ↓
Excel / Power Query → Cleaning & Transformation
        ↓
Power BI Star Schema (facts + dimensions + Dim_Date)
        ↓
DAX Measures & KPIs → 2-Page Interactive Dashboard
        ↓
MySQL (saas_analytics) → SQL Validation Scripts (01–05)
        ↓
Validated Insights & Recommendations
```

## 💡 Business Recommendations

| Finding | Recommendation | Expected Benefit |
| ------- | -------------- | ---------------- |
| $33.3K MRR past due | Automated payment retries and in-app reminders | Recover at-risk MRR before it churns |
| Loss concentrated in Business, Growth, Enterprise | Proactive check-ins using the high-risk list (Script 5) | Earlier intervention where churn costs most |
| $524.35K overdue in Enterprise | Send invoices earlier and confirm vendor requirements up front | Faster collection, better cash flow |
| Integrations has the most tickets and urgent escalations | Review top integration issues in an engineering sprint | Fewer urgent tickets, less support load |
| Billing is slowest (42.8 hrs) with lowest CSAT (3.96) | Set a faster resolution target for billing issues | Better satisfaction on a payment-linked issue |
| Retail and Healthcare churn above average | Review cancellation reasons and tailor onboarding | Lower churn in the highest-churn industries |
| Low seat usage in some active accounts (Script 3) | Adoption outreach to flagged accounts | Better usage, lower downgrade and churn risk |

*Recommendations come from descriptive analysis. They show where to focus, not proven causes of churn.*

## 🧠 Analytical Skills Demonstrated

- **Data cleaning & transformation:** Power Query, null handling, data-type validation, date dimension
- **Data modelling:** star schema with fact and dimension tables and 1:\* relationships
- **DAX & KPI development:** churn rate, MRR, overdue balance, seat utilization, CSAT, resolution time
- **Dashboard development:** 2-page Power BI report with cross-filtering slicers
- **Business analysis:** revenue-weighted vs. account-weighted churn, revenue at risk, collections exposure
- **SQL:** schema setup, joins, conditional aggregation, `HAVING`, CTEs, type casting
- **Data validation:** reconciling Power BI against MySQL, with row-count checks after import
- **Insight generation:** prioritised, data-backed recommendations

## 🚀 Project Highlights

- **End-to-end workflow:** ingestion, cleaning, modelling, dashboarding and SQL validation.
- **Multiple related datasets:** five tables and 44,384 records joined on a common account key.
- **Star schema model:** three fact tables with shared account and date dimensions.
- **Business-focused dashboard:** two pages, nine business questions answered.
- **SQL validation layer:** five scripts reproducing dashboard totals ($58.5K churned MRR, $739.6K overdue balance, support SLA and CSAT) and extending them to account level.
- **Actionable output:** findings tied to specific recommendations, including a CTE-based top-10 high-risk account list.
