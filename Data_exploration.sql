USE customer_support;


-- =====================================================
-- 1. CHECK TOTAL RECORDS
-- =====================================================

SELECT 
    COUNT(*) AS Total_Tickets
FROM customer_support_tickets;


-- =====================================================
-- 2. VIEW SAMPLE DATA
-- =====================================================

SELECT *
FROM customer_support_tickets
LIMIT 10;


-- =====================================================
-- 3. CHECK DATE RANGE
-- =====================================================

SELECT
    MIN(Ticket_Date) AS First_Ticket_Date,
    MAX(Ticket_Date) AS Last_Ticket_Date
FROM customer_support_tickets;


-- =====================================================
-- 4. UNIQUE ISSUE CATEGORIES
-- =====================================================

SELECT DISTINCT
    Issue_Category
FROM customer_support_tickets
ORDER BY Issue_Category;


-- =====================================================
-- 5. UNIQUE PRODUCTS
-- =====================================================

SELECT DISTINCT
    Product
FROM customer_support_tickets
ORDER BY Product;


-- =====================================================
-- 6. TICKET STATUS DISTRIBUTION
-- =====================================================

SELECT
    Status,
    COUNT(*) AS Ticket_Count
FROM customer_support_tickets
GROUP BY Status
ORDER BY Ticket_Count DESC;


-- =====================================================
-- 7. PRIORITY DISTRIBUTION
-- =====================================================

SELECT
    Priority,
    COUNT(*) AS Ticket_Count
FROM customer_support_tickets
GROUP BY Priority
ORDER BY Ticket_Count DESC;


-- =====================================================
-- 8. CHANNEL DISTRIBUTION
-- =====================================================

SELECT
    Channel,
    COUNT(*) AS Ticket_Count
FROM customer_support_tickets
GROUP BY Channel
ORDER BY Ticket_Count DESC;


-- =====================================================
-- 9. TEAM DISTRIBUTION
-- =====================================================

SELECT
    Team,
    COUNT(*) AS Ticket_Count
FROM customer_support_tickets
GROUP BY Team
ORDER BY Ticket_Count DESC;


-- =====================================================
-- 10. SLA PERFORMANCE OVERVIEW
-- =====================================================

SELECT
    SLA_Met,
    COUNT(*) AS Ticket_Count
FROM customer_support_tickets
GROUP BY SLA_Met;


-- =====================================================
-- 11. ESCALATION OVERVIEW
-- =====================================================

SELECT
    Escalated,
    COUNT(*) AS Ticket_Count
FROM customer_support_tickets
GROUP BY Escalated;


-- =====================================================
-- 12. CSAT SUMMARY
-- =====================================================

SELECT
    AVG(Customer_CSAT) AS Average_CSAT,
    MIN(Customer_CSAT) AS Lowest_CSAT,
    MAX(Customer_CSAT) AS Highest_CSAT
FROM customer_support_tickets;


-- =====================================================
-- 13. CHECK AGENT COVERAGE
-- =====================================================

SELECT
    COUNT(DISTINCT Agent_ID) AS Total_Assigned_Agents
FROM customer_support_tickets;


-- =====================================================
-- 14. AGENT MASTER RECORD COUNT
-- =====================================================
    SELECT COUNT(*) AS Total_Agents
FROM agent_master_indian;