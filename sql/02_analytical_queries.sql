-- ==============================================================================
-- 02_analytical_queries.sql
-- Project: HR Attrition & Workforce Intelligence
-- Author: Rohan Nandanwar
-- Purpose: Core analytical queries, workforce breakdowns, and turnover drivers
-- Source: Phase 2 (MySQL / phpMyAdmin Analysis)
-- ==============================================================================

USE hr_attrition_db;

-- -----------------------------------------------------------------------------
-- QUERY 1: Baseline Overall Attrition Rate
-- Purpose: Establishes company-wide turnover benchmark (16.12%)
-- -----------------------------------------------------------------------------
SELECT 
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Percent
FROM employees;


-- -----------------------------------------------------------------------------
-- QUERY 2: Attrition Rate by Department (GROUP BY)
-- Purpose: Identifies highest-flight department (Sales: 20.63%, HR: 19.05%, R&D: 13.84%)
-- Deliverable: dept_attrition.csv
-- -----------------------------------------------------------------------------
SELECT 
    Department,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Percent
FROM employees
GROUP BY Department
ORDER BY Attrition_Rate_Percent DESC;


-- -----------------------------------------------------------------------------
-- QUERY 3: Attrition by Overtime Status
-- Purpose: Proves overtime workers leave at ~3x higher rate (30.53% vs 10.44%)
-- Deliverable: overtime_attrition.csv
-- -----------------------------------------------------------------------------
SELECT 
    OverTime,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Percent
FROM employees
GROUP BY OverTime
ORDER BY Attrition_Rate_Percent DESC;


-- -----------------------------------------------------------------------------
-- QUERY 4: Job Role Breakdown (Filtered with HAVING COUNT(*) >= 20)
-- Purpose: Evaluates roles with reliable sample sizes (Sales Rep: 39.76%, Lab Tech: 23.94%)
-- Deliverable: jobrole_attrition.csv
-- -----------------------------------------------------------------------------
SELECT 
    JobRole,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Percent
FROM employees
GROUP BY JobRole
HAVING COUNT(*) >= 20
ORDER BY Attrition_Rate_Percent DESC;


-- -----------------------------------------------------------------------------
-- QUERY 5: Income & Experience Comparison (Stayed vs Left)
-- Purpose: Demonstrates departed employees earn $2,046 less on average ($4,787 vs $6,833)
-- Deliverable: income_comparison.csv
-- -----------------------------------------------------------------------------
SELECT 
    Attrition,
    COUNT(*) AS Employee_Count,
    ROUND(AVG(MonthlyIncome), 0) AS Avg_Monthly_Income,
    ROUND(AVG(YearsAtCompany), 1) AS Avg_Years_At_Company,
    ROUND(AVG(TotalWorkingYears), 1) AS Avg_Total_Working_Years
FROM employees
GROUP BY Attrition;


-- -----------------------------------------------------------------------------
-- QUERY 6: Department + Gender Cross-Analysis (2D Grouping)
-- Purpose: Granular breakdown revealing gender turnover patterns within departments
-- Deliverable: dept_gender_attrition.csv
-- -----------------------------------------------------------------------------
SELECT 
    Department,
    Gender,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Percent
FROM employees
GROUP BY Department, Gender
ORDER BY Department, Attrition_Rate_Percent DESC;
