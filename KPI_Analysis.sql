USE customer_support;


-- =====================================================
-- KPI ANALYSIS
-- Customer Support Operations Dashboard
-- =====================================================


-- =====================================================
-- 1. TOTAL TICKETS
-- =====================================================

SELECT
    COUNT(*) AS Total_Tickets
FROM customer_support_tickets;



-- =====================================================
-- 2. TICKET STATUS SUMMARY
-- =====================================================

SELECT
    Status,
    COUNT(*) AS Ticket_Count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM customer_support_tickets),
        2
    ) AS Percentage
FROM customer_support_tickets
GROUP BY Status
ORDER BY Ticket_Count DESC;



-- =====================================================
-- 3. RESOLUTION RATE
-- Closed tickets percentage
-- =====================================================

SELECT

ROUND(
    SUM(
        CASE 
            WHEN Status = 'Closed' THEN 1 
            ELSE 0 
        END
    ) * 100.0 / COUNT(*),
    2
) AS Resolution_Rate_Percentage

FROM customer_support_tickets;



-- =====================================================
-- 4. SLA ACHIEVEMENT RATE
-- =====================================================

SELECT

ROUND(
    SUM(
        CASE
            WHEN SLA_Met = 'Yes' THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*),
    2
) AS SLA_Achievement_Percentage

FROM customer_support_tickets;



-- =====================================================
-- 5. SLA PERFORMANCE SUMMARY
-- =====================================================

SELECT

SLA_Met,

COUNT(*) AS Ticket_Count,

ROUND(
COUNT(*) * 100.0 /
(SELECT COUNT(*) 
 FROM customer_support_tickets),
2
) AS Percentage

FROM customer_support_tickets

GROUP BY SLA_Met;



-- =====================================================
-- 6. AVERAGE FIRST RESPONSE TIME
-- =====================================================

SELECT

ROUND(
AVG(First_Response_Minutes),
2
) AS Average_First_Response_Minutes

FROM customer_support_tickets;



-- =====================================================
-- 7. AVERAGE RESOLUTION TIME
-- =====================================================

SELECT

ROUND(
AVG(Resolution_Hours),
2
) AS Average_Resolution_Hours

FROM customer_support_tickets;



-- =====================================================
-- 8. CUSTOMER SATISFACTION SCORE
-- =====================================================

SELECT

ROUND(
AVG(Customer_CSAT),
2
) AS Average_CSAT

FROM customer_support_tickets;



-- =====================================================
-- 9. CSAT DISTRIBUTION
-- =====================================================

SELECT

Customer_CSAT,

COUNT(*) AS Response_Count

FROM customer_support_tickets

GROUP BY Customer_CSAT

ORDER BY Customer_CSAT;



-- =====================================================
-- 10. ESCALATION RATE
-- =====================================================

SELECT

ROUND(

SUM(
CASE 
WHEN Escalated = 'Yes'
THEN 1
ELSE 0
END
) * 100.0 / COUNT(*),

2

) AS Escalation_Rate_Percentage

FROM customer_support_tickets;



-- =====================================================
-- 11. REOPEN RATE
-- =====================================================

SELECT

ROUND(

SUM(
CASE
WHEN Reopened = 'Yes'
THEN 1
ELSE 0
END
) * 100.0 / COUNT(*),

2

) AS Reopen_Rate_Percentage

FROM customer_support_tickets;



-- =====================================================
-- 12. PRIORITY KPI ANALYSIS
-- =====================================================

SELECT

Priority,

COUNT(*) AS Total_Tickets,

ROUND(
AVG(Resolution_Hours),
2
) AS Avg_Resolution_Hours,

ROUND(
AVG(Customer_CSAT),
2
) AS Avg_CSAT

FROM customer_support_tickets

GROUP BY Priority

ORDER BY Total_Tickets DESC;



-- =====================================================
-- 13. CHANNEL PERFORMANCE KPI
-- =====================================================

SELECT

Channel,

COUNT(*) AS Total_Tickets,

ROUND(
AVG(Customer_CSAT),
2
) AS Avg_CSAT,

ROUND(
AVG(Resolution_Hours),
2
) AS Avg_Resolution_Hours

FROM customer_support_tickets

GROUP BY Channel

ORDER BY Total_Tickets DESC;



-- =====================================================
-- 14. MONTHLY TICKET TREND
-- =====================================================

SELECT

YEAR(Ticket_Date) AS Ticket_Year,

MONTH(Ticket_Date) AS Ticket_Month,

COUNT(*) AS Total_Tickets

FROM customer_support_tickets

GROUP BY

YEAR(Ticket_Date),

MONTH(Ticket_Date)

ORDER BY

Ticket_Year,

Ticket_Month;



-- =====================================================
-- 15. EXECUTIVE KPI SUMMARY
-- Single dashboard card dataset
-- =====================================================

SELECT

COUNT(*) AS Total_Tickets,


SUM(
CASE
WHEN Status = 'Closed'
THEN 1
ELSE 0
END
) AS Closed_Tickets,


ROUND(
AVG(Resolution_Hours),
2
) AS Avg_Resolution_Hours,


ROUND(
AVG(First_Response_Minutes),
2
) AS Avg_Response_Minutes,


ROUND(
AVG(Customer_CSAT),
2
) AS Avg_CSAT,


ROUND(

SUM(
CASE
WHEN SLA_Met='Yes'
THEN 1
ELSE 0
END
)
*100.0/COUNT(*),

2

) AS SLA_Percentage,


ROUND(

SUM(
CASE
WHEN Escalated='Yes'
THEN 1
ELSE 0
END
)
*100.0/COUNT(*),

2

) AS Escalation_Percentage

FROM customer_support_tickets;