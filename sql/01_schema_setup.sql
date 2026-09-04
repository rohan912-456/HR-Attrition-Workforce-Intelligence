-- ==============================================================================
-- 01_schema_setup.sql
-- Project: HR Attrition & Workforce Intelligence
-- Author: Rohan Nandanwar
-- Purpose: Database schema definition, data typing, constraints, and indexation
-- Target RDBMS: MySQL / phpMyAdmin / MariaDB / PostgreSQL
-- ==============================================================================

-- 1. Create Database
CREATE DATABASE IF NOT EXISTS hr_attrition_db;
USE hr_attrition_db;

-- 2. Drop existing table if recreating
DROP TABLE IF EXISTS employees;

-- 3. Create Main Employees Table
CREATE TABLE employees (
    -- Identification & Demographics
    EmployeeNumber INT NOT NULL,
    Age INT NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    MaritalStatus VARCHAR(20) NOT NULL,
    Education INT NOT NULL,
    EducationField VARCHAR(50) NOT NULL,
    
    -- Department & Role
    Department VARCHAR(50) NOT NULL,
    JobRole VARCHAR(50) NOT NULL,
    JobLevel INT NOT NULL,
    
    -- Engagement & Satisfaction (Scale 1-4)
    EnvironmentSatisfaction INT NOT NULL,
    JobSatisfaction INT NOT NULL,
    JobInvolvement INT NOT NULL,
    RelationshipSatisfaction INT NOT NULL,
    WorkLifeBalance INT NOT NULL,
    PerformanceRating INT NOT NULL,
    
    -- Compensation & Stock
    MonthlyIncome INT NOT NULL,
    DailyRate INT,
    HourlyRate INT,
    MonthlyRate INT,
    PercentSalaryHike INT NOT NULL,
    StockOptionLevel INT NOT NULL,
    
    -- Working Pattern & Mobility
    OverTime VARCHAR(3) NOT NULL,
    BusinessTravel VARCHAR(30) NOT NULL,
    DistanceFromHome INT NOT NULL,
    
    -- Experience & Tenure
    TotalWorkingYears INT NOT NULL,
    NumCompaniesWorked INT NOT NULL,
    YearsAtCompany INT NOT NULL,
    YearsInCurrentRole INT NOT NULL,
    YearsSinceLastPromotion INT NOT NULL,
    YearsWithCurrManager INT NOT NULL,
    TrainingTimesLastYear INT NOT NULL,
    
    -- Primary Target Variable
    Attrition VARCHAR(3) NOT NULL,
    
    -- Primary Key Definition
    CONSTRAINT pk_employee_number PRIMARY KEY (EmployeeNumber)
);

-- 4. Recommended Indexes for Analytical Query Optimization
CREATE INDEX idx_attrition ON employees (Attrition);
CREATE INDEX idx_department_role ON employees (Department, JobRole);
CREATE INDEX idx_overtime ON employees (OverTime);
CREATE INDEX idx_income_tenure ON employees (MonthlyIncome, YearsAtCompany);

-- 5. Verification Check
-- SELECT COUNT(*) AS Total_Employees FROM employees; -- Expected: 1470
