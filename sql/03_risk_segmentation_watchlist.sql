-- ==============================================================================
-- 03_risk_segmentation_watchlist.sql
-- Project: HR Attrition & Workforce Intelligence
-- Author: Rohan Nandanwar
-- Purpose: Rule-based risk segmentation (nested CASE WHEN) and active watchlist
-- ==============================================================================

USE hr_analytics_db;

-- -----------------------------------------------------------------------------
-- QUERY 8: Rule-Based Multi-Tier Risk Segmentation
-- Logic:
--   - High Risk:   OverTime = 'Yes' AND JobSatisfaction <= 2 (Both burnout & dissatisfaction)
--   - Medium Risk: OverTime = 'Yes' OR JobSatisfaction <= 2 (Single risk factor present)
--   - Low Risk:    OverTime = 'No' AND JobSatisfaction > 2 (Stable work conditions)
--
-- Statistical Outcome:
--   - High Risk:   153 employees | 56 left | 36.60% Attrition (~4.3x higher than Low Risk)
--   - Medium Risk: 679 employees | 127 left | 18.70% Attrition
--   - Low Risk:    638 employees | 54 left |  8.46% Attrition
-- -----------------------------------------------------------------------------
SELECT 
    CASE 
        WHEN OverTime = 'Yes' AND JobSatisfaction <= 2 THEN 'High Risk'
        WHEN OverTime = 'Yes' OR JobSatisfaction <= 2 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS Risk_Segment,
    COUNT(*) AS Employee_Count,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Actually_Left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0.0 END) / COUNT(*) * 100, 2) AS Attrition_Rate_Percent
FROM employee_attrition
GROUP BY 
    CASE 
        WHEN OverTime = 'Yes' AND JobSatisfaction <= 2 THEN 'High Risk'
        WHEN OverTime = 'Yes' OR JobSatisfaction <= 2 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END
ORDER BY Attrition_Rate_Percent DESC;


-- -----------------------------------------------------------------------------
-- QUERY 9: Preventative HR Intervention Watch-List (Active At-Risk Employees)
-- Target: Currently active employees (Attrition = 'No') exhibiting high risk
--         (OverTime = 'Yes', JobSatisfaction <= 2, WorkLifeBalance <= 2)
-- Action: Immediate manager 1-on-1s, workload rebalancing, and retention packages
-- -----------------------------------------------------------------------------
SELECT 
    EmployeeNumber,
    Department,
    JobRole,
    Age,
    MonthlyIncome,
    YearsAtCompany,
    OverTime,
    JobSatisfaction,
    WorkLifeBalance
FROM employee_attrition
WHERE Attrition = 'No'
  AND OverTime = 'Yes'
  AND JobSatisfaction <= 2
  AND WorkLifeBalance <= 2
ORDER BY MonthlyIncome ASC, YearsAtCompany ASC;
