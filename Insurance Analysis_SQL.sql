CREATE DATABASE Insurance;
USE Insurance;
/*6 KPIs-
1. Yearly Meeting Count
2. No of Meetings by Account Executive
3. No of Invoices by Account Executive
4. Top Open Opportunity
5. Stage Funnel by Revenue
6. Cross Sell, New, Renewal - (Target, Achieved, New)
*/
------------------------------------------------------------------------------------------------------------------------------------------------------
 # KPI 1- Yearly Meeting Count
SELECT * FROM meeting;

SELECT 
    YEAR(STR_TO_DATE(meeting_date, '%d-%m-%Y')) AS Year,
    COUNT(*) AS 'Yearly Meeting Count'
FROM
    meeting
GROUP BY year
ORDER BY year;
------------------------------------------------------------------------------------------------------------------------------------------------------
# KPI 2- No of Meetings by Account Executive

SELECT `Account Executive`, 
       COUNT(*) AS Total_Meetings
FROM meeting
GROUP BY `Account Executive`
ORDER BY Total_Meetings DESC;
------------------------------------------------------------------------------------------------------------------------------------------------------
# KPI 3 - No of Invoices by Account Executive

SELECT `Account Executive`, COUNT(`invoice_number`) AS `Total Invoices`
FROM invoice
GROUP BY `Account Executive`
ORDER BY `Total Invoices` DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------
# KPI 4- Top 5 Opportunity by Revenue

SELECT `opportunity_name` AS "Opportunity", `Account Executive`,  `revenue_amount` AS "Revenue Amount"
FROM opportunity
ORDER BY `revenue_amount` DESC
LIMIT 5;
------------------------------------------------------------------------------------------------------------------------------------------------------
# KPI 5 - Stage Funnel by Revenue

SELECT stage AS "Stage", SUM(revenue_amount) AS "Total_Revenue"
FROM opportunity
GROUP BY stage
ORDER BY Total_Revenue DESC;
------------------------------------------------------------------------------------------------------------------------------------------------------
# KPI 6- Cross Sell, New, Renewal - (Target, Achieved, Invoice)

WITH CombinedData AS (
    SELECT `Account Exe ID`, Amount, income_class FROM brokerage
    UNION ALL
    SELECT `Account Exe ID`, Amount, income_class FROM fees
)

SELECT 
    Category,
    Target,
	Achieved,
	Invoice
   
    FROM (
   SELECT 
    'Cross Sell' AS Category,
    (SELECT SUM(`Cross sell bugdet`) FROM `individual budgets`) AS Target,
    ROUND((SELECT SUM(Amount) FROM `CombinedData` WHERE income_class = 'Cross Sell'),0) AS Achieved,
    (SELECT SUM(Amount) FROM `invoice` WHERE income_class = 'Cross Sell') AS Invoice
UNION ALL
SELECT 
    'New',
    (SELECT SUM(`New Budget`) FROM `individual budgets`),
    ROUND((SELECT SUM(Amount) FROM `CombinedData` WHERE income_class = 'New'),0),
    (SELECT SUM(Amount) FROM `invoice` WHERE income_class = 'New')
UNION ALL
SELECT 
    'Renewal',
    (SELECT SUM(`Renewal Budget`) FROM `individual budgets`),
    ROUND((SELECT SUM(Amount) FROM `CombinedData` WHERE income_class = 'Renewal'),0),
    (SELECT SUM(Amount) FROM `invoice` WHERE income_class = 'Renewal')
) AS KPI_Calculations;
-------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
    'Cross Sell' AS Category,
    (SELECT SUM(`Cross sell bugdet`) FROM `individual budgets`) AS Target,
    ROUND((SELECT SUM(Amount) FROM `append` WHERE income_class = 'Cross Sell'),2) AS Achieve,
    (SELECT SUM(Amount) FROM `invoice` WHERE income_class = 'Cross Sell') AS New
UNION ALL
SELECT 
    'New',
    (SELECT SUM(`New Budget`) FROM `individual budgets`),
    ROUND((SELECT SUM(Amount) FROM `append` WHERE income_class = 'New'),2),
    (SELECT SUM(Amount) FROM `invoice` WHERE income_class = 'New')
UNION ALL
SELECT 
    'Renewal',
    (SELECT SUM(`Renewal Budget`) FROM `individual budgets`),
    ROUND((SELECT SUM(Amount) FROM `append` WHERE income_class = 'Renewal'),2),
    (SELECT SUM(Amount) FROM `invoice` WHERE income_class = 'Renewal');