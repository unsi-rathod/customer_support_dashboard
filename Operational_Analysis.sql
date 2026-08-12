USE customer_support;


-- =====================================================
-- OPERATIONAL ANALYSIS
-- Customer Support Operations Dashboard
-- =====================================================



-- =====================================================
-- 1. TEAM PERFORMANCE ANALYSIS
-- =====================================================

SELECT

Team,

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
AVG(Customer_CSAT),
2
) AS Avg_CSAT,


ROUND(

SUM(
CASE
WHEN SLA_Met = 'Yes'
THEN 1
ELSE 0
END
) * 100.0 / COUNT(*),

2

) AS SLA_Percentage


FROM customer_support_tickets

GROUP BY Team

ORDER BY Total_Tickets DESC;



-- =====================================================
-- 2. AGENT PERFORMANCE ANALYSIS
-- =====================================================

SELECT

Assigned_Agent,

Agent_ID,

COUNT(*) AS Tickets_Handled,


ROUND(
AVG(Resolution_Hours),
2
) AS Avg_Resolution_Hours,


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
)*100.0/COUNT(*),

2

) AS SLA_Percentage


FROM customer_support_tickets

GROUP BY

Assigned_Agent,

Agent_ID

ORDER BY Tickets_Handled DESC;



-- =====================================================
-- 3. TOP 10 HIGH VOLUME AGENTS
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
-- 4. AGENT MASTER DETAILS WITH PERFORMANCE
-- =====================================================

SELECT

a.agent_name,

a.team,

a.manager,

a.shift,

a.location,

a.experience_years,


COUNT(t.Ticket_ID) AS Tickets_Handled,


ROUND(
AVG(t.Customer_CSAT),
2
) AS Avg_CSAT


FROM agent_master_indian a

LEFT JOIN customer_support_tickets t

ON a.agent_id = t.Agent_ID


GROUP BY

a.agent_name,
a.team,
a.manager,
a.shift,
a.location,
a.experience_years

ORDER BY Tickets_Handled DESC;



-- =====================================================
-- 5. MANAGER PERFORMANCE ANALYSIS
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
WHEN SLA_Met='Yes'
THEN 1
ELSE 0
END
)*100.0/COUNT(*),

2

) AS SLA_Percentage


FROM customer_support_tickets

GROUP BY Manager

ORDER BY SLA_Percentage DESC;



-- =====================================================
-- 6. ISSUE CATEGORY ANALYSIS
-- =====================================================

SELECT

Issue_Category,

COUNT(*) AS Ticket_Count,


ROUND(
AVG(Resolution_Hours),
2
) AS Avg_Resolution_Hours,


ROUND(
AVG(Customer_CSAT),
2
) AS Avg_CSAT,


ROUND(

SUM(
CASE
WHEN Escalated='Yes'
THEN 1
ELSE 0
END
)*100.0/COUNT(*),

2

) AS Escalation_Rate


FROM customer_support_tickets


GROUP BY Issue_Category


ORDER BY Ticket_Count DESC;



-- =====================================================
-- 7. PRIORITY VS PERFORMANCE ANALYSIS
-- =====================================================

SELECT

Priority,

COUNT(*) AS Total_Tickets,


ROUND(
AVG(Resolution_Hours),
2
) AS Avg_Resolution_Hours,


ROUND(
AVG(First_Response_Minutes),
2
) AS Avg_Response_Time,


ROUND(
AVG(Customer_CSAT),
2
) AS Avg_CSAT


FROM customer_support_tickets

GROUP BY Priority

ORDER BY Total_Tickets DESC;



-- =====================================================
-- 8. SLA BREACH ANALYSIS
-- =====================================================

SELECT

Issue_Category,

Priority,

COUNT(*) AS SLA_Breaches,


ROUND(
AVG(Resolution_Hours),
2
) AS Avg_Breach_Time


FROM customer_support_tickets


WHERE SLA_Met='No'


GROUP BY

Issue_Category,

Priority


ORDER BY SLA_Breaches DESC;



-- =====================================================
-- 9. ESCALATION ANALYSIS
-- =====================================================

SELECT

Issue_Category,


COUNT(*) AS Total_Escalations,


ROUND(

COUNT(*)*100.0/

(
SELECT COUNT(*)
FROM customer_support_tickets
WHERE Escalated='Yes'
),

2

) AS Escalation_Percentage


FROM customer_support_tickets


WHERE Escalated='Yes'


GROUP BY Issue_Category


ORDER BY Total_Escalations DESC;



-- =====================================================
-- 10. PRODUCT ISSUE ANALYSIS
-- =====================================================

SELECT

Product,

COUNT(*) AS Complaints,


ROUND(
AVG(Customer_CSAT),
2
) AS Avg_CSAT,


ROUND(
AVG(Resolution_Hours),
2
) AS Avg_Resolution_Time


FROM customer_support_tickets


GROUP BY Product


ORDER BY Complaints DESC;



-- =====================================================
-- 11. SUPPORT CHANNEL ANALYSIS
-- =====================================================

SELECT

Channel,

COUNT(*) AS Tickets,


ROUND(
AVG(First_Response_Minutes),
2
) AS Avg_Response_Time,


ROUND(
AVG(Customer_CSAT),
2
) AS Avg_CSAT


FROM customer_support_tickets


GROUP BY Channel


ORDER BY Tickets DESC;



-- =====================================================
-- 12. SHIFT-WISE PERFORMANCE
-- =====================================================

SELECT

a.shift,


COUNT(t.Ticket_ID) AS Tickets_Handled,


ROUND(
AVG(t.Customer_CSAT),
2
) AS Avg_CSAT,


ROUND(
AVG(t.Resolution_Hours),
2
) AS Avg_Resolution_Time


FROM agent_master_indian a


LEFT JOIN customer_support_tickets t

ON a.agent_id = t.Agent_ID


GROUP BY a.shift


ORDER BY Tickets_Handled DESC;



-- =====================================================
-- 13. EXPERIENCE VS PERFORMANCE
-- =====================================================

SELECT

a.experience_years,


COUNT(t.Ticket_ID) AS Tickets_Handled,


ROUND(
AVG(t.Customer_CSAT),
2
) AS Avg_CSAT,


ROUND(
AVG(t.Resolution_Hours),
2
) AS Avg_Resolution_Time


FROM agent_master_indian a


LEFT JOIN customer_support_tickets t

ON a.agent_id=t.Agent_ID


GROUP BY a.experience_years


ORDER BY a.experience_years;



-- =====================================================
-- 14. CITY-WISE CUSTOMER ISSUE ANALYSIS
-- =====================================================

SELECT

City,

State,

COUNT(*) AS Ticket_Count,


ROUND(
AVG(Customer_CSAT),
2
) AS Avg_CSAT


FROM customer_support_tickets


GROUP BY

City,

State


ORDER BY Ticket_Count DESC;