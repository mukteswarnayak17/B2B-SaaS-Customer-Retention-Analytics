# B2B SaaS Customer Retention & Churn Analysis

An end-to-end analysis of customer retention and revenue churn for a B2B SaaS company with 1,200 commercial accounts and $971.4K in Monthly Recurring Revenue (MRR). Five relational Kaggle datasets were cleaned in Excel Power Query, modelled as a star schema in Power BI, and presented in a 2-page interactive dashboard. Key metrics were then cross-checked in MySQL with five SQL scripts.



## 📌 Project Overview

Retaining existing customers is critical for a B2B SaaS business because recurring revenue compounds only when accounts stay and pay. This project looks at where the company is losing revenue, which customer segments are most exposed, and which billing, support and adoption signals sit alongside churn risk.

The analysis covers three areas:

- **Revenue retention:** MRR by plan, churned vs. at-risk (past due) MRR, and churn by industry.
- **Operational health:** support volume, resolution time, CSAT, overdue invoices and seat utilization.
- **SQL validation:** five MySQL scripts that reproduce or extend key dashboard figures at account level.

**Workflow:** Kaggle CSVs → Excel / Power Query → Power BI star schema → 2-page dashboard → MySQL → SQL validation



## 🎯 Business Objectives

- Identify where recurring revenue is being lost, by plan, industry and company size.
- Separate permanent churn from revenue still at risk (past-due accounts).
- Find the industries with the highest churn rate and the largest dollar loss.
- Locate overdue invoice balances and see which customer segments hold them.
- Assess support performance (volume, resolution time, CSAT) and product adoption (seat utilization).
- Turn the findings into practical retention actions.



## 📊 Dataset

**Source:** Kaggle B2B SaaS dataset (5 relational CSV files).

| Table | Description | Records |
| ----- | ----------- | ------: |
| `accounts` | Company master data: `account_id`, `company_name`, `industry`, `country`, `employee_count`, `signup_date`, `plan`, `company_size` | 1,200 |
| `subscriptions` | Contract data: `seats`, `mrr`, `status` (active / churned / past_due), `started_on`, `ended_on`, churn and past-due flags | 1,200 |
| `invoices` | Billing records: `amount`, `invoice_date`, `status` (paid / open / void / uncollectible), `is_unpaid` | 14,500 |
| `support_tickets` | Support tickets: `category`, `priority`, `opened_at`, `resolved_at`, `resolution_hours`, `satisfaction_score`, `ticket_status` | 5,600 |
| `users` | Provisioned users per account: `user_id`, `account_id`, `full_name`, `role` (Admin / Member / Viewer), `email` | 21,884 |
| **Total** | | **44,384** |



## 🛠️ Tools & Technologies

| Layer | Tools |
| ----- | ----- |
| Data preparation | Microsoft Excel, Power Query |
| Data modelling & BI | Power BI Desktop, DAX, star schema design |
| Database & validation | MySQL, MySQL Workbench, SQL (schema setup, joins, aggregations, `CASE WHEN`, `HAVING`, CTEs) |



## 🔄 Data Preparation & Cleaning

All five CSV files were cleaned in **Excel Power Query** before being loaded into Power BI.

- Handled null values across the datasets.
- Verified and corrected data types (dates, numeric fields, flags).
- Added a `Dim_Date` table (Date, Month, MonthNumber, Quarter, Year) for time filtering.
- Added a `Priority_Order` field to `Support_Tickets` to support ordering of priority levels.
- Used the source flags (`is_churned`, `is_past_due`, `is_unpaid`) as the basis for churn, at-risk and overdue measures.
- Kept `account_id` consistent across all tables so every table joins cleanly to `Accounts`.

**MySQL load:** the cleaned data was loaded into a `saas_analytics` database using a setup script (`00_schema_and_database_setup.sql`). It creates the five tables and ends with a row-count check per table.

- Date fields, `satisfaction_score` and `resolution_hours` were staged as text (`VARCHAR`) during import, so the queries cast them explicitly.
- Status values are handled case-insensitively (`'open'` / `'Open'`, `LOWER(priority)`) so the SQL results match the Power BI logic.



## 🧩 Data Modeling

The Power BI model is a **star schema** centred on `Accounts` and `Dim_Date`. Every relationship is **one-to-many (1:\*)**, which keeps DAX measures fast and avoids circular relationships.

| Role | Tables |
| ---- | ------ |
| Fact tables | `Subscriptions` (MRR, seats, churn), `Invoices` (billing and collections), `Support_Tickets` (SLA and CSAT) |
| Dimension tables | `Accounts` (industry, plan, company size), `Dim_Date`, `Users` (user adoption) |

`Users` is classified as a dimension in the project files and connects to `Accounts` through `account_id`.



![Star Schema](Star-Schema-Model.png)

**Why this design:** one account dimension filters all fact tables, so the Plan, Industry, Company Size and Year slicers apply consistently across every visual on both pages.



## 📈 Power BI Dashboard

The dashboard has **2 interactive pages**. Both share the same slicers: **Plan, Industry, Company Size, Year**.

### Page 1 — Executive Revenue Retention & Churn Overview

![Page 1](dashboard-views/Page1_Executive_Revenue_Overview.png)

**Purpose:** show how much recurring revenue is secure, lost or at risk, and where.

**KPIs:** Total Portfolio MRR, Lost MRR, Customer Churn Rate %, Total Paying Accounts

**Visuals:**
- Total vs Lost MRR by Plan
- MRR at Risk Breakdown (donut)
- Churn Rate by Industry
- Lost Revenue by Industry & Plan

**Business questions answered:**
- Which plan tiers generate the revenue, and where is lost revenue concentrated?
- How much MRR is active, churned or past due?
- Which industries have the highest churn rate?
- Which industries cause the largest dollar loss?

### Page 2 — Customer Health & Churn Risk Diagnostics

![Page 2](dashboard-views/Page2_Customer_Health_Diagnostics.png)

**Purpose:** show the operational signals around churn risk: support performance, overdue billing and product adoption.

**KPIs:** Seat Utilization %, Avg CSAT Score, Overdue Balance, Avg Resolution Time (Hrs)

**Visuals:**
- Ticket Volume by Category & Priority
- Overdue Balance by Company Size
- Support Ticket Resolution Status
- Seat Utilization by Plan

**Business questions answered:**
- Which support categories generate the most tickets and urgent escalations?
- Where is the overdue invoice balance concentrated?
- How much of the support queue is resolved vs. still open?
- Are customers using the seats they bought, by plan?



## ❓ Business Questions Answered

1. Which subscription plans drive revenue, and where is lost revenue concentrated?
2. What share of MRR is secure, permanently churned, or at risk through failed payments?
3. Which industries have the highest customer churn rates?
4. Which industries cause the largest financial loss, and how does that differ from churn rate?
5. Which support categories generate the most volume and urgent escalations, and which are slowest to resolve?
6. Where is the overdue invoice balance concentrated?
7. What share of support tickets is resolved vs. still open?
8. Are customers actively using the seats they purchased, across plan tiers?
9. Which high-value accounts show combined risk signals (late payments, low usage, urgent tickets) and need intervention first?



## 📊 Key KPIs

| KPI | Value | Definition | Business Purpose |
| --- | ----: | ---------- | ---------------- |
| Total Portfolio MRR | $971.4K | Total monthly recurring revenue across all 1,200 accounts | Baseline for measuring revenue exposure |
| Lost MRR | $91.8K | MRR from churned accounts ($58.5K) plus past-due accounts ($33.3K) | Quantifies revenue lost or at immediate risk |
| Customer Churn Rate % | 10.33% | Churned accounts ÷ total accounts (124 of 1,200) | Headline retention metric |
| Total Paying Accounts | 1,200 | Total account count in the portfolio | Denominator for account-level metrics |
| Seat Utilization % | 77.8% | Share of purchased seats assigned to users | Adoption signal for expansion and downgrade risk |
| Avg CSAT Score | 4.03 / 5 | Average satisfaction score on support tickets | Customer sentiment on support |
| Overdue Balance | $739.60K | Unpaid balance on open invoices (void invoices excluded) | Measures collections exposure |
| Avg Resolution Time | 40.8 hrs | Average hours to resolve a support ticket | Support efficiency |



## 🔍 Key Business Insights

**1. Revenue is concentrated in Business, Growth and Enterprise, and so is the dollar loss.**
- **Finding:** Active MRR is $431.3K (Business), $235.7K (Growth), $184.1K (Enterprise) and $28.5K (Starter). Lost MRR is $21.8K, $18.8K, $15.0K and $2.9K respectively. Starter is 524 of 1,200 accounts (about 44%) but a small share of lost revenue.
- **What it means:** Churn in the higher tiers costs far more than churn in Starter.
- **Why it matters:** Retention effort should be weighted by revenue, not by account count.

**2. $33.3K of MRR is past due and could still be recovered.**
- **Finding:** 90.55% ($880K) of MRR is active, 6.03% ($59K) has churned and 3.43% ($33K) is past due.
- **What it means:** Past-due accounts have not yet churned, so this revenue is still in play.
- **Why it matters:** Recovering failed payments is a lower-effort retention lever than winning back cancelled accounts.

**3. The industry with the highest churn rate is not the one with the largest loss.**
- **Finding:** Retail (12.8%) and Healthcare (11.9%) have the highest churn rates, against a 10.33% average. Software (10.5%) causes the largest dollar loss, about $35K of lost MRR, mostly from Enterprise and Business plans. Retail is about $14K.
- **What it means:** Account-level churn and revenue-weighted churn tell different stories.
- **Why it matters:** Prioritising by churn rate alone would misdirect retention effort.

**4. Education (8.0%) and Financial Services (8.9%) are the most stable industries.**
- **Finding:** Both sit below the 10.33% average.
- **What it means:** These segments retain better than the portfolio overall.
- **Why it matters:** They are useful benchmarks for what healthy retention looks like.

**5. Overdue invoices are concentrated in Enterprise companies.**
- **Finding:** Enterprise holds $524.35K (70.9%) of the $739.60K overdue balance across 157 open invoices (average ≈ $3,340). Mid-Market holds $192.73K and Small holds $22.52K.
- **What it means:** A small number of large invoices drives most of the collections exposure.
- **Why it matters:** Collections effort aimed at large Enterprise invoices has the biggest cash impact.

**6. Integrations and Billing are the main support pain points.**
- **Finding:** In the validated resolved-ticket sample, Integrations has the most tickets (1,171) and the most urgent ones (101), followed by Bug Reports (1,046 tickets, 76 urgent). Billing is the slowest category (42.8 hrs average) and has the lowest CSAT (3.96).
- **What it means:** Billing tickets are both slow to close and the least satisfying for customers.
- **Why it matters:** Billing support overlaps with the overdue and past-due revenue issues above.

**7. Support backlog is small, and seat utilization is fairly even across plans.**
- **Finding:** 91.59% of tickets are resolved and 8.41% are open. Seat utilization is 84.7% (Business), 82.3% (Starter), 80.2% (Enterprise) and 78.6% (Growth), against 77.8% overall.
- **What it means:** Neither the support queue nor seat adoption shows an acute problem at portfolio level.
- **Why it matters:** The revenue risk sits mainly in billing and high-tier churn. Account-level adoption gaps are still worth monitoring, and the SQL layer flags them.



## 🗄️ SQL Validation

After the Power BI analysis, the cleaned data was loaded into **MySQL** (`saas_analytics` database) and queried in **MySQL Workbench**. A setup script creates the schema and checks row counts. Five analysis scripts then cross-check the dashboard logic and extend it to account level.

| # | Validation Script | What It Validates |
| - | ----------------- | ----------------- |
| 1 | `01_mrr_and_churn_by_plan.sql` | Accounts, active MRR, lost (churned) MRR and churn rate by plan tier. Reconciles with the Total vs Lost MRR by Plan chart (churned MRR $58.5K, active MRR about $880K). |
| 2 | `02_overdue_balance_by_company_size.sql` | Open invoice count, total overdue balance and average invoice size by company size, excluding void invoices. Reconciles with the $739.60K Overdue Balance KPI. |
| 3 | `03_license_seat_utilization.sql` | Seat utilization (assigned users ÷ purchased seats) for active accounts, flagging those below 65%. Supports the Page 2 adoption analysis at account level. |
| 4 | `04_support_sla_and_csat_analysis.sql` | Ticket count, urgent tickets, average resolution hours and average CSAT by category (resolved tickets). Supports the support-category visuals and the resolution-time and CSAT KPIs. |
| 5 | `05_top_10_high_risk_accounts.sql` | Early-warning list of the top 10 accounts by MRR that have overdue balances, urgent open tickets or seat utilization below 50%, built with CTEs. |

Reproducing the dashboard totals directly from the database confirms that the DAX measures, relationships and filters give the same results as independent queries. Scripts 3 and 5 go further and turn the dashboard's segment-level findings into account-level action lists.



## 🔁 End-to-End Workflow

```text
Kaggle Datasets (5 CSV files)
        ↓
Excel / Power Query
        ↓
Data Cleaning & Transformation
        ↓
Power BI Star Schema (facts + dimensions + Dim_Date)
        ↓
DAX Measures & KPI Development
        ↓
2-Page Interactive Dashboard
        ↓
MySQL (saas_analytics database)
        ↓
SQL Validation Scripts (01–05)
        ↓
Validated Insights & Recommendations
```

---

## 💡 Business Recommendations

| Finding | Recommendation | Expected Business Benefit |
| ------- | -------------- | ------------------------- |
| $33.3K of MRR is past due | Add automated payment retries and in-app payment reminders | Recover part of the at-risk MRR before it becomes churn |
| Lost MRR is concentrated in Business, Growth and Enterprise | Prioritise proactive check-ins for high-MRR accounts, using the high-risk list (Script 5) | Earlier intervention on the accounts where churn costs the most |
| $524.35K of overdue balance sits with Enterprise | Send invoices earlier and confirm vendor and procurement requirements up front | Faster collection of large balances and better cash flow |
| Integrations has the most tickets and urgent escalations | Review the most common integration issues in an engineering sprint | Fewer urgent tickets and less support load |
| Billing tickets are slowest (42.8 hrs) and lowest CSAT (3.96) | Set a faster resolution target for billing issues | Better satisfaction on an issue linked to payment risk |
| Retail and Healthcare churn above average | Review why these segments cancel and tailor onboarding and success plans | Lower account churn in the highest-churn industries |
| Some active accounts use a low share of purchased seats (Script 3) | Run adoption outreach for the flagged accounts | Better product usage, lowering downgrade and churn risk |

*These recommendations come from descriptive analysis of the dataset. They show where to focus, not proven causes of churn.*









## 🧠 Analytical Skills Demonstrated

- **Data cleaning and preparation:** Power Query, null handling, data-type validation
- **Data transformation:** a date dimension, a priority-ordering field, consistent keys across five tables
- **Data modelling:** star schema design with fact and dimension tables and 1:\* relationships
- **DAX and KPI development:** churn rate, MRR, overdue balance, seat utilization, CSAT and resolution-time measures
- **Dashboard development:** a 2-page Power BI report with cross-filtering slicers
- **Business analysis:** revenue-weighted vs. account-weighted churn, revenue at risk, collections exposure
- **SQL:** schema setup, joins, conditional aggregation, `HAVING`, CTEs, explicit type casting, case-insensitive status handling
- **Data validation:** reconciling Power BI results against MySQL queries, with row-count checks after import
- **Insight generation:** turning findings into specific, prioritised recommendations



## 🚀 Project Highlights

- **End-to-end workflow:** ingestion, cleaning, modelling, dashboarding and SQL validation in one project.
- **Multiple related datasets:** five tables and 44,384 records joined through a common account key.
- **Star schema model:** three fact tables and shared account and date dimensions supporting both dashboard pages.
- **Business-focused dashboard:** two pages covering revenue retention and customer health, with nine business questions answered.
- **SQL validation layer:** a MySQL database with five scripts that reproduce dashboard totals ($58.5K churned MRR, $739.6K overdue balance, support SLA and CSAT metrics) and extend them to account level.
- **Actionable output:** findings tied to specific recommendations, including a CTE-based top-10 high-risk account list.

