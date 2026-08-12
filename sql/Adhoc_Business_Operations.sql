USE customer_support;


-- =====================================================
-- ADHOC BUSINESS QUESTIONS
-- Customer Support Operations Dashboard
-- =====================================================



-- =====================================================
-- 1. Which issue categories generate the highest ticket volume?
-- Business Use: Identify major customer pain points
-- =====================================================

SELECT

Issue_Category,

COUNT(*) AS Total_Tickets

FROM customer_support_tickets

GROUP BY Issue_Category

ORDER BY Total_Tickets DESC;



-- =====================================================
-- 2. Which issue categories have the lowest customer satisfaction?
-- Business Use: Identify improvement areas
-- =====================================================

SELECT

Issue_Category,

ROUND(
AVG(Customer_CSAT),
2
) AS Average_CSAT,

COUNT(*) AS Ticket_Count

FROM customer_support_tickets

GROUP BY Issue_Category

ORDER BY Average_CSAT ASC;



-- =====================================================
-- 3. Which teams have the highest SLA breach rate?
-- Business Use: Monitor operational efficiency
-- =====================================================

SELECT

Team,

COUNT(*) AS Total_Tickets,


SUM(
CASE
WHEN SLA_Met='No'
THEN 1
ELSE 0
END
) AS SLA_Breaches,


ROUND(

SUM(
CASE
WHEN SLA_Met='No'
THEN 1
ELSE 0
END
)
*100.0/COUNT(*),

2

) AS SLA_Breach_Percentage


FROM customer_support_tickets

GROUP BY Team

ORDER BY SLA_Breach_Percentage DESC;



-- =====================================================
-- 4. Which agents handle the highest ticket volume?
-- Business Use: Workload distribution
-- =====================================================

SELECT

Assigned_Agent,

Agent_ID,

COUNT(*) AS Tickets_Handled

FROM customer_support_tickets

GROUP BY

Assigned_Agent,

Agent_ID

ORDER BY Tickets_Handled DESC

LIMIT 10;



-- =====================================================
-- 5. Which agents have poor customer satisfaction scores?
-- Business Use: Coaching requirement
-- =====================================================

SELECT

Assigned_Agent,

Agent_ID,

COUNT(*) AS Tickets_Handled,


ROUND(
AVG(Customer_CSAT),
2
) AS Average_CSAT


FROM customer_support_tickets

GROUP BY

Assigned_Agent,

Agent_ID


HAVING COUNT(*) >= 20


ORDER BY Average_CSAT ASC

LIMIT 10;



-- =====================================================
-- 6. Which products receive the most complaints?
-- Business Use: Product improvement
-- =====================================================

SELECT

Product,

COUNT(*) AS Complaint_Count

FROM customer_support_tickets

GROUP BY Product

ORDER BY Complaint_Count DESC;



-- =====================================================
-- 7. Which priority level consumes the most operational effort?
-- Business Use: Resource planning
-- =====================================================

SELECT

Priority,

COUNT(*) AS Total_Tickets,


ROUND(
AVG(Resolution_Hours),
2
) AS Avg_Resolution_Time,


ROUND(
AVG(First_Response_Minutes),
2
) AS Avg_Response_Time


FROM customer_support_tickets

GROUP BY Priority

ORDER BY Total_Tickets DESC;



-- =====================================================
-- 8. Which channels create maximum support workload?
-- Business Use: Channel optimization
-- =====================================================

SELECT

Channel,

COUNT(*) AS Total_Tickets,


ROUND(
AVG(Customer_CSAT),
2
) AS Average_CSAT


FROM customer_support_tickets

GROUP BY Channel

ORDER BY Total_Tickets DESC;



-- =====================================================
-- 9. What are the top reasons for escalations?
-- Business Use: Reduce escalations
-- =====================================================

SELECT

Issue_Category,

COUNT(*) AS Escalation_Count


FROM customer_support_tickets


WHERE Escalated='Yes'


GROUP BY Issue_Category


ORDER BY Escalation_Count DESC;



-- =====================================================
-- 10. Are reopened tickets affecting customer satisfaction?
-- Business Use: Quality monitoring
-- =====================================================

SELECT

Reopened,


COUNT(*) AS Ticket_Count,


ROUND(
AVG(Customer_CSAT),
2
) AS Average_CSAT,


ROUND(
AVG(Resolution_Hours),
2
) AS Avg_Resolution_Hours


FROM customer_support_tickets


GROUP BY Reopened;



-- =====================================================
-- 11. Which month had the highest ticket load?
-- Business Use: Workforce forecasting
-- =====================================================

SELECT


DATE_FORMAT(
Ticket_Date,
'%Y-%m'
) AS Ticket_Month,


COUNT(*) AS Ticket_Volume


FROM customer_support_tickets


GROUP BY Ticket_Month


ORDER BY Ticket_Volume DESC;



-- =====================================================
-- 12. Identify high-risk tickets
-- Criteria:
-- High priority + SLA breach + Escalated
-- =====================================================

SELECT

Ticket_ID,

Customer_Name,

Issue_Category,

Priority,

Assigned_Agent,

Resolution_Hours,

SLA_Hours


FROM customer_support_tickets


WHERE Priority='High'

AND SLA_Met='No'

AND Escalated='Yes'

ORDER BY Resolution_Hours DESC;



-- =====================================================
-- 13. Which managers need operational attention?
-- Business Use: Management review
-- =====================================================

SELECT

Manager,


COUNT(*) AS Total_Tickets,


ROUND(
AVG(Customer_CSAT),
2
) AS Avg_CSAT,


ROUND(

SUM(
CASE
WHEN SLA_Met='No'
THEN 1
ELSE 0
END
)
*100.0/COUNT(*),

2

) AS SLA_Breach_Rate


FROM customer_support_tickets


GROUP BY Manager


ORDER BY SLA_Breach_Rate DESC;



-- =====================================================
-- 14. Customer location-wise complaint analysis
-- Business Use: Regional trends
-- =====================================================

SELECT

State,

City,

COUNT(*) AS Ticket_Count,


ROUND(
AVG(Customer_CSAT),
2
) AS Avg_CSAT


FROM customer_support_tickets


GROUP BY

State,

City


ORDER BY Ticket_Count DESC;



-- =====================================================
-- 15. Final Business Insight Dataset
-- Identify improvement priorities
-- =====================================================

SELECT


Issue_Category,


COUNT(*) AS Ticket_Volume,


ROUND(
AVG(Customer_CSAT),
2
) AS Avg_CSAT,


ROUND(
AVG(Resolution_Hours),
2
) AS Avg_Resolution_Time,


ROUND(

SUM(
CASE
WHEN SLA_Met='No'
THEN 1
ELSE 0
END
)
*100.0/COUNT(*),

2

) AS SLA_Breach_Percentage


FROM customer_support_tickets


GROUP BY Issue_Category


ORDER BY SLA_Breach_Percentage DESC;
