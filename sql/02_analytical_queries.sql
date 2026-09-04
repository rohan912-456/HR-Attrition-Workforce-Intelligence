-- ==============================================================================
-- 02_analytical_queries.sql
-- Project: HR Attrition & Workforce Intelligence
-- Author: Rohan Nandanwar
-- Purpose: Core analytical queries, workforce breakdowns, and turnover drivers
-- ==============================================================================

USE hr_analytics_db;

-- -----------------------------------------------------------------------------
-- QUERY 1: Baseline Turnover Benchmark & Headcount Metrics
-- -----------------------------------------------------------------------------
SELECT 
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Total_Left,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Total_Active,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0.0 END) / COUNT(*) * 100, 2) AS Attrition_Rate_Percent,
    ROUND(AVG(MonthlyIncome), 2) AS Overall_Avg_Monthly_Income
FROM employee_attrition;


-- -----------------------------------------------------------------------------
-- QUERY 2: Attrition Rate by Department
-- Result: Sales (20.63%), HR (19.05%), R&D (13.84%)
-- -----------------------------------------------------------------------------
SELECT 
    Department,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0.0 END) / COUNT(*) * 100, 2) AS Attrition_Rate_Percent
FROM employee_attrition
GROUP BY Department
ORDER BY Attrition_Rate_Percent DESC;


-- -----------------------------------------------------------------------------
-- QUERY 3: OverTime Impact Analysis (The ~3x Multiplier)
-- Result: Overtime Yes = 30.53% vs Overtime No = 10.44%
-- -----------------------------------------------------------------------------
SELECT 
    OverTime,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0.0 END) / COUNT(*) * 100, 2) AS Attrition_Rate_Percent
FROM employee_attrition
GROUP BY OverTime
ORDER BY Attrition_Rate_Percent DESC;


-- -----------------------------------------------------------------------------
-- QUERY 4: Job Role Granular Breakdown with Leaver Tenure
-- Identifies critical vulnerability in Sales Reps (39.76%) and Lab Techs (23.94%)
-- -----------------------------------------------------------------------------
SELECT 
    JobRole,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(AVG(CASE WHEN Attrition = 'Yes' THEN YearsAtCompany ELSE NULL END), 1) AS Avg_Tenure_of_Leavers,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0.0 END) / COUNT(*) * 100, 2) AS Attrition_Rate_Percent
FROM employee_attrition
GROUP BY JobRole
ORDER BY Attrition_Rate_Percent DESC;


-- -----------------------------------------------------------------------------
-- QUERY 5: Income & Experience Disparity (Leavers vs Retained)
-- Proves departing employees earn $2,046 less on average ($4,787 vs $6,833)
-- -----------------------------------------------------------------------------
SELECT 
    Attrition,
    COUNT(*) AS Employee_Count,
    ROUND(AVG(MonthlyIncome), 0) AS Avg_Monthly_Income,
    ROUND(AVG(YearsAtCompany), 1) AS Avg_Years_At_Company,
    ROUND(AVG(TotalWorkingYears), 1) AS Avg_Total_Working_Years
FROM employee_attrition
GROUP BY Attrition;


-- -----------------------------------------------------------------------------
-- QUERY 6: Cross-Departmental Gender Analysis
-- -----------------------------------------------------------------------------
SELECT 
    Department,
    Gender,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0.0 END) / COUNT(*) * 100, 2) AS Attrition_Rate_Percent
FROM employee_attrition
GROUP BY Department, Gender
ORDER BY Department, Attrition_Rate_Percent DESC;


-- -----------------------------------------------------------------------------
-- QUERY 7: Tenure Zone Vulnerability Window
-- Demonstrates flight risk concentrated in the 0-2 year window (~30%)
-- -----------------------------------------------------------------------------
SELECT 
    CASE 
        WHEN YearsAtCompany <= 2 THEN '0-2 yrs (Highest Risk)'
        WHEN YearsAtCompany <= 5 THEN '3-5 yrs (Medium Risk)'
        ELSE '6+ yrs (Stable)'
    END AS Tenure_Zone,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0.0 END) / COUNT(*) * 100, 2) AS Attrition_Rate_Percent
FROM employee_attrition
GROUP BY 
    CASE 
        WHEN YearsAtCompany <= 2 THEN '0-2 yrs (Highest Risk)'
        WHEN YearsAtCompany <= 5 THEN '3-5 yrs (Medium Risk)'
        ELSE '6+ yrs (Stable)'
    END
ORDER BY Attrition_Rate_Percent DESC;
