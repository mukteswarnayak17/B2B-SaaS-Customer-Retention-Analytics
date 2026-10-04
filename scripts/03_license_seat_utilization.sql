-- ====================================================================
-- Script 03: Identify Under-Utilized Accounts (Adoption Risk)
-- File Name: 03_license_seat_utilization.sql
-- Business Question: Which active accounts are using less than 50% 
--                    of the user seats they purchased?
-- ====================================================================

USE saas_analytics;

SELECT 
    a.account_id,
    a.company_name,
    a.plan,
    s.seats AS purchased_seats,
    COUNT(u.user_id) AS active_assigned_users,
    ROUND(100.0 * COUNT(u.user_id) / s.seats, 1) AS seat_utilization_pct
FROM accounts a
JOIN subscriptions s ON a.account_id = s.account_id
LEFT JOIN users u ON a.account_id = u.account_id
WHERE s.status = 'active'
GROUP BY a.account_id, a.company_name, a.plan, s.seats
HAVING ROUND(100.0 * COUNT(u.user_id) / s.seats, 1) < 65.0
ORDER BY seat_utilization_pct ASC;