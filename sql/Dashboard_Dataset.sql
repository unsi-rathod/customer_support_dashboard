USE customer_support;


-- =====================================================
-- DASHBOARD DATASET CREATION
-- Customer Support Operations Dashboard
-- =====================================================



-- =====================================================
-- 1. EXECUTIVE KPI DASHBOARD VIEW
-- =====================================================

CREATE OR REPLACE VIEW vw_support_kpi_summary AS

SELECT

COUNT(*) AS Total_Tickets,


SUM(
CASE
WHEN Status = 'Closed'
THEN 1
ELSE 0
END
) AS Closed_Tickets,


SUM(
CASE
WHEN Status <> 'Closed'
THEN 1
ELSE 0
END
) AS Open_Tickets,


ROUND(

SUM(
CASE
WHEN Status = 'Closed'
THEN 1
ELSE 0
END
)
*100.0/COUNT(*),

2

) AS Resolution_Rate_Percentage,


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

) AS SLA_Achievement_Percentage,


ROUND(
AVG(First_Response_Minutes),
2
) AS Avg_First_Response_Minutes,


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
)
*100.0/COUNT(*),

2

) AS Escalation_Rate,


ROUND(

SUM(
CASE
WHEN Reopened='Yes'
THEN 1
ELSE 0
END
)
*100.0/COUNT(*),

2

) AS Reopen_Rate


FROM customer_support_tickets;





-- =====================================================
-- 2. MONTHLY TICKET TREND DATASET
-- =====================================================

CREATE OR REPLACE VIEW vw_monthly_ticket_trend AS

SELECT

YEAR(Ticket_Date) AS Ticket_Year,

MONTH(Ticket_Date) AS Ticket_Month,


DATE_FORMAT(
Ticket_Date,
'%Y-%m'
) AS Month_Name,


COUNT(*) AS Total_Tickets,


ROUND(
AVG(Customer_CSAT),
2
) AS Avg_CSAT,


ROUND(
AVG(Resolution_Hours),
2
) AS Avg_Resolution_Hours,


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

) AS SLA_Percentage


FROM customer_support_tickets


GROUP BY

YEAR(Ticket_Date),

MONTH(Ticket_Date),

DATE_FORMAT(
Ticket_Date,
'%Y-%m'
)

ORDER BY Ticket_Year, Ticket_Month;





-- =====================================================
-- 3. TEAM PERFORMANCE DATASET
-- =====================================================

CREATE OR REPLACE VIEW vw_team_performance AS

SELECT

Team,


COUNT(*) AS Total_Tickets,


SUM(
CASE
WHEN Status='Closed'
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

) AS Escalation_Rate


FROM customer_support_tickets


GROUP BY Team;





-- =====================================================
-- 4. AGENT PERFORMANCE DATASET
-- =====================================================

CREATE OR REPLACE VIEW vw_agent_performance AS

SELECT


a.agent_id,

a.agent_name,

a.gender,

a.team,

a.manager,

a.shift,

a.location,

a.experience_years,


COUNT(t.Ticket_ID) AS Tickets_Handled,


SUM(
CASE
WHEN t.Status='Closed'
THEN 1
ELSE 0
END
) AS Closed_Tickets,


ROUND(
AVG(t.First_Response_Minutes),
2
) AS Avg_Response_Time,


ROUND(
AVG(t.Resolution_Hours),
2
) AS Avg_Resolution_Hours,


ROUND(
AVG(t.Customer_CSAT),
2
) AS Avg_CSAT,


ROUND(

SUM(
CASE
WHEN t.SLA_Met='Yes'
THEN 1
ELSE 0
END
)
*100.0/
COUNT(t.Ticket_ID),

2

) AS SLA_Percentage


FROM agent_master_indian a


LEFT JOIN customer_support_tickets t

ON a.agent_id=t.Agent_ID


GROUP BY

a.agent_id,

a.agent_name,

a.gender,

a.team,

a.manager,

a.shift,

a.location,

a.experience_years;





-- =====================================================
-- 5. ISSUE CATEGORY PERFORMANCE DATASET
-- =====================================================

CREATE OR REPLACE VIEW vw_issue_category_analysis AS


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

) AS Escalation_Rate


FROM customer_support_tickets


GROUP BY Issue_Category;





-- =====================================================
-- 6. PRIORITY ANALYSIS DATASET
-- =====================================================

CREATE OR REPLACE VIEW vw_priority_analysis AS


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

) AS SLA_Percentage


FROM customer_support_tickets


GROUP BY Priority;

SHOW FULL TABLES;

SELECT *
FROM vw_support_kpi_summary;
