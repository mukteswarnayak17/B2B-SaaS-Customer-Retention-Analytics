-- ====================================================================
-- Script 02: Overdue Invoiced Balance by Company Size
-- File Name: 02_overdue_balance_by_company_size.sql
-- Business Question: Where is our unpaid invoice balance concentrated 
--                    across company sizes, excluding void invoices?
-- ====================================================================

USE saas_analytics;

SELECT 
    a.company_size,
    COUNT(i.invoice_id) AS open_invoice_count,
    SUM(i.amount) AS total_overdue_balance,
    ROUND(AVG(i.amount), 2) AS avg_invoice_size
FROM accounts a
JOIN invoices i ON a.account_id = i.account_id
WHERE i.status IN ('open', 'Open')
GROUP BY a.company_size
ORDER BY total_overdue_balance DESC;