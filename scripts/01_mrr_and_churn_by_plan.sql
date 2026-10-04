-- ====================================================================
-- Script 01: Revenue Retention and Churn Rate by Plan Tier
-- File Name: 01_mrr_and_churn_by_plan.sql
-- Business Question: What is our Total MRR, Lost MRR, and Churn Rate
--                    across each subscription tier?
-- ====================================================================

USE saas_analytics;

SELECT 
    a.plan,
    COUNT(s.account_id) AS total_accounts,
    SUM(CASE WHEN s.status = 'active' THEN s.mrr ELSE 0 END) AS active_mrr,
    SUM(CASE WHEN s.is_churned = 1 THEN s.mrr ELSE 0 END) AS lost_mrr,
    ROUND(
        100.0 * SUM(CASE WHEN s.is_churned = 1 THEN 1 ELSE 0 END) / COUNT(s.account_id), 
        2
    ) AS churn_rate_pct
FROM accounts a
JOIN subscriptions s ON a.account_id = s.account_id
GROUP BY a.plan
ORDER BY active_mrr DESC;