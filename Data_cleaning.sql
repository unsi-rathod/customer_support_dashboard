USE customer_support;


-- =====================================================
-- DATA CLEANING & VALIDATION REPORT
-- Customer Support Operations Dashboard
-- =====================================================


-- =====================================================
-- 1. CHECK DUPLICATE TICKET IDs
-- =====================================================

SELECT
    Ticket_ID,
    COUNT(*) AS Duplicate_Count
FROM customer_support_tickets
GROUP BY Ticket_ID
HAVING COUNT(*) > 1;



-- =====================================================
-- 2. CHECK MISSING CRITICAL FIELDS
-- =====================================================

SELECT
    COUNT(*) AS Missing_Ticket_ID
FROM customer_support_tickets
WHERE Ticket_ID IS NULL;


SELECT
    COUNT(*) AS Missing_Customer_ID
FROM customer_support_tickets
WHERE Customer_ID IS NULL;


SELECT
    COUNT(*) AS Missing_Agent_ID
FROM customer_support_tickets
WHERE Agent_ID IS NULL;



-- =====================================================
-- 3. CHECK MISSING CATEGORICAL DATA
-- =====================================================

SELECT
    COUNT(*) AS Missing_Issue_Category
FROM customer_support_tickets
WHERE Issue_Category IS NULL;


SELECT
    COUNT(*) AS Missing_Priority
FROM customer_support_tickets
WHERE Priority IS NULL;


SELECT
    COUNT(*) AS Missing_Status
FROM customer_support_tickets
WHERE Status IS NULL;



-- =====================================================
-- 4. CHECK INVALID PRIORITY VALUES
-- =====================================================

SELECT DISTINCT
    Priority
FROM customer_support_tickets
WHERE Priority NOT IN
(
    'Low',
    'Medium',
    'High'
);



-- =====================================================
-- 5. CHECK INVALID STATUS VALUES
-- =====================================================

SELECT DISTINCT
    Status
FROM customer_support_tickets;



-- =====================================================
-- 6. CHECK NEGATIVE RESPONSE TIME
-- =====================================================

SELECT
    Ticket_ID,
    First_Response_Minutes
FROM customer_support_tickets
WHERE First_Response_Minutes < 0;



-- =====================================================
-- 7. CHECK NEGATIVE RESOLUTION HOURS
-- =====================================================

SELECT
    Ticket_ID,
    Resolution_Hours
FROM customer_support_tickets
WHERE Resolution_Hours < 0;



-- =====================================================
-- 8. CHECK SLA LOGIC
-- Resolution time should not exceed SLA when SLA is met
-- =====================================================

SELECT
    Ticket_ID,
    Resolution_Hours,
    SLA_Hours,
    SLA_Met
FROM customer_support_tickets
WHERE SLA_Met = 'Yes'
AND Resolution_Hours > SLA_Hours;



-- =====================================================
-- 9. CHECK SLA BREACH RECORDS
-- =====================================================

SELECT
    Ticket_ID,
    Resolution_Hours,
    SLA_Hours
FROM customer_support_tickets
WHERE SLA_Met = 'No'
AND Resolution_Hours <= SLA_Hours;



-- =====================================================
-- 10. CHECK CSAT RANGE
-- Expected range: 1-5
-- =====================================================

SELECT
    Ticket_ID,
    Customer_CSAT
FROM customer_support_tickets
WHERE Customer_CSAT < 1
OR Customer_CSAT > 5;



-- =====================================================
-- 11. CHECK RESOLUTION DATE LOGIC
-- Resolution date should not be before ticket date
-- =====================================================

SELECT
    Ticket_ID,
    Ticket_Date,
    Resolution_Date
FROM customer_support_tickets
WHERE Resolution_Date < Ticket_Date;



-- =====================================================
-- 12. CHECK REOPENED TICKETS
-- =====================================================

SELECT
    Reopened,
    COUNT(*) AS Ticket_Count
FROM customer_support_tickets
GROUP BY Reopened;



-- =====================================================
-- 13. CHECK AGENT MASTER DUPLICATES
-- =====================================================

SELECT
    agent_id,
    COUNT(*) AS Duplicate_Count
FROM agent_master_indian
GROUP BY agent_id
HAVING COUNT(*) > 1;



-- =====================================================
-- 14. CHECK UNMATCHED AGENTS
-- Tickets with agents missing in master table
-- =====================================================

SELECT
    t.Agent_ID,
    t.Assigned_Agent
FROM customer_support_tickets t
LEFT JOIN agent_master_indian a
ON t.Agent_ID = a.agent_id
WHERE a.agent_id IS NULL;



-- =====================================================
-- 15. DATA COMPLETENESS SUMMARY
-- =====================================================

SELECT

COUNT(*) AS Total_Records,

SUM(
CASE WHEN Ticket_ID IS NULL 
THEN 1 ELSE 0 END
) AS Missing_Ticket_ID,

SUM(
CASE WHEN Agent_ID IS NULL 
THEN 1 ELSE 0 END
) AS Missing_Agent_ID,

SUM(
CASE WHEN Customer_CSAT IS NULL 
THEN 1 ELSE 0 END
) AS Missing_CSAT

FROM customer_support_tickets;