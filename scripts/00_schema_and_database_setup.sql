-- ====================================================================
-- Script 00: Database & Schema Setup
-- Database: saas_analytics
-- Project: B2B SaaS Customer Retention Analytics
-- ====================================================================

-- Run this line ONLY if you want to reset and start from scratch:
-- DROP DATABASE IF EXISTS saas_analytics;

CREATE DATABASE IF NOT EXISTS saas_analytics;
USE saas_analytics;

-- Disable strict checks during CSV import
SET FOREIGN_KEY_CHECKS = 0;

-- 1. accounts (Dimension Table)
CREATE TABLE IF NOT EXISTS accounts (
    account_id INT PRIMARY KEY,
    company_name VARCHAR(100),
    industry VARCHAR(50),
    country VARCHAR(50),
    employee_count INT,
    signup_date VARCHAR(50),      
    plan VARCHAR(50),
    company_size VARCHAR(50)
);

-- 2. subscriptions (Fact Table)
CREATE TABLE IF NOT EXISTS subscriptions (
    subscription_id INT PRIMARY KEY,
    account_id INT,
    seats INT,
    status VARCHAR(50),
    mrr DECIMAL(10, 2),
    started_on VARCHAR(50),    
    ended_on VARCHAR(50),          
    is_churned INT,
    is_past_due INT
);

-- 3. invoices (Fact Table)
CREATE TABLE IF NOT EXISTS invoices (
    invoice_id INT PRIMARY KEY,
    account_id INT,
    invoice_date VARCHAR(50),     
    amount DECIMAL(10, 2),
    status VARCHAR(50),
    is_unpaid INT
);

-- 4. support_tickets (Fact Table)
CREATE TABLE IF NOT EXISTS support_tickets (
    ticket_id INT PRIMARY KEY,
    account_id INT,
    opened_at VARCHAR(50),        
    priority VARCHAR(50),
    category VARCHAR(50),
    satisfaction_score VARCHAR(10), 
    resolution_hours VARCHAR(20),  
    resolved_at VARCHAR(50),      
    ticket_status VARCHAR(50)
);

-- 5. users (Dimension Table)
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY,
    account_id INT,
    full_name VARCHAR(100),
    role VARCHAR(50),
    email VARCHAR(100)
);

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- ====================================================================
-- Verification Query: Check total imported rows
-- ====================================================================
SELECT 'accounts' AS table_name, COUNT(*) AS total_rows FROM accounts
UNION ALL
SELECT 'subscriptions', COUNT(*) FROM subscriptions
UNION ALL
SELECT 'invoices', COUNT(*) FROM invoices
UNION ALL
SELECT 'support_tickets', COUNT(*) FROM support_tickets
UNION ALL
SELECT 'users', COUNT(*) FROM users;