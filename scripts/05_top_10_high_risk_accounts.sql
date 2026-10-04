-- ====================================================================
-- Script 05: Multi-Factor Early Warning Churn Radar (Top 10 High-Risk)
-- File Name: 05_top_10_high_risk_accounts.sql
-- Business Question: Which top 10 high-value accounts need immediate 
--                    intervention based on late payments, low usage, 
--                    and urgent support tickets?
-- ====================================================================

USE saas_analytics;

WITH AccountAdoption AS (
    SELECT 
        account_id, 
        COUNT(user_id) AS user_count 
    FROM users 
    GROUP BY account_id
),
AccountSupport AS (
    SELECT 
        account_id, 
        COUNT(ticket_id) AS open_urgent_tickets 
    FROM support_tickets 
    WHERE ticket_status IN ('open', 'Open') 
      AND LOWER(priority) = 'urgent'
    GROUP BY account_id
),
AccountInvoices AS (
    SELECT 
        account_id, 
        SUM(amount) AS overdue_balance 
    FROM invoices 
    WHERE status IN ('open', 'Open') 
    GROUP BY account_id
)

SELECT 
    a.account_id,
    a.company_name,
    a.plan,
    s.mrr,
    ROUND(100.0 * COALESCE(aa.user_count, 0) / s.seats, 1) AS seat_utilization_pct,
    COALESCE(ai.overdue_balance, 0) AS overdue_balance,
    COALESCE(asup.open_urgent_tickets, 0) AS urgent_tickets
FROM accounts a
JOIN subscriptions s ON a.account_id = s.account_id
LEFT JOIN AccountAdoption aa ON a.account_id = aa.account_id
LEFT JOIN AccountInvoices ai ON a.account_id = ai.account_id
LEFT JOIN AccountSupport asup ON a.account_id = asup.account_id
WHERE s.status IN ('active', 'past_due')
  AND (
      ROUND(100.0 * COALESCE(aa.user_count, 0) / s.seats, 1) < 50.0
      OR COALESCE(ai.overdue_balance, 0) > 0
      OR COALESCE(asup.open_urgent_tickets, 0) > 0
  )
ORDER BY s.mrr DESC
LIMIT 10;