-- ==============================================================================
-- 03_risk_segmentation_watchlist.sql
-- Project: HR Attrition & Workforce Intelligence
-- Author: Rohan Nandanwar
-- Purpose: Rule-based multi-factor risk segmentation & active employee watchlist
-- Source: Phase 2 (MySQL / phpMyAdmin Analysis)
-- ==============================================================================

USE hr_attrition_db;

-- -----------------------------------------------------------------------------
-- QUERY 7 (Guide Query 6): Multi-Factor Risk Segments (Nested CASE WHEN)
-- Purpose: Evaluates turnover rate across 3 explainable business rule tiers
-- Logic:
--   - High Risk:   OverTime = 'Yes' AND JobSatisfaction <= 2 (Both burnout & dissatisfaction)
--   - Medium Risk: OverTime = 'Yes' OR JobSatisfaction <= 2 (Single risk factor present)
--   - Low Risk:    OverTime = 'No' AND JobSatisfaction > 2 (Stable baseline)
--
-- Statistical Outcome:
--   - High Risk:   153 employees | 56 left | 36.60% Attrition (~4.3x higher than Low Risk)
--   - Medium Risk: 679 employees | 127 left | 18.70% Attrition
--   - Low Risk:    638 employees | 54 left |  8.46% Attrition
--
-- Deliverable: risk_segments.csv
-- -----------------------------------------------------------------------------
SELECT 
    CASE 
        WHEN OverTime = 'Yes' AND JobSatisfaction <= 2 THEN 'High Risk'
        WHEN OverTime = 'Yes' OR JobSatisfaction <= 2 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS Risk_Segment,
    COUNT(*) AS Employee_Count,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Actually_Left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Percent
FROM employees
GROUP BY 
    CASE 
        WHEN OverTime = 'Yes' AND JobSatisfaction <= 2 THEN 'High Risk'
        WHEN OverTime = 'Yes' OR JobSatisfaction <= 2 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END
ORDER BY Attrition_Rate_Percent DESC;


-- -----------------------------------------------------------------------------
-- QUERY 8 (Guide Query 8): Actionable Watch-List of Current Employees at Highest Risk
-- Purpose: Filters specifically for CURRENTLY ACTIVE employees (Attrition = 'No')
--         matching all top flight-risk drivers for immediate HR intervention
-- Deliverable: watchlist_employees.csv
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
FROM employees
WHERE Attrition = 'No'
  AND OverTime = 'Yes'
  AND JobSatisfaction <= 2
  AND WorkLifeBalance <= 2
ORDER BY YearsAtCompany ASC;
