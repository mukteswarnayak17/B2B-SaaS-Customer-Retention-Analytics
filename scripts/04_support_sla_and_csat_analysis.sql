-- ====================================================================
-- Script 04: Support Efficiency and Customer Satisfaction Diagnostics
-- File Name: 04_support_sla_and_csat_analysis.sql
-- Business Question: Which support issue categories take the longest 
--                    to resolve and suffer from lowest CSAT scores?
-- ====================================================================

USE saas_analytics;

SELECT 
    category,
    COUNT(ticket_id) AS total_tickets,
    SUM(CASE WHEN LOWER(priority) = 'urgent' THEN 1 ELSE 0 END) AS urgent_tickets,
    ROUND(AVG(CAST(resolution_hours AS DECIMAL(6,2))), 1) AS avg_resolution_hours,
    ROUND(AVG(CAST(satisfaction_score AS DECIMAL(4,2))), 2) AS avg_csat_score
FROM support_tickets
WHERE ticket_status IN ('resolved', 'Resolved')
GROUP BY category
ORDER BY avg_resolution_hours DESC;