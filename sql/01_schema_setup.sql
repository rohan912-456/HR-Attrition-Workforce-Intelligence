-- ==============================================================================
-- 01_schema_setup.sql
-- Project: HR Attrition & Workforce Intelligence
-- Author: Rohan Nandanwar
-- Purpose: Database schema definition, data typing, constraints, and indexation
-- Target RDBMS: MySQL 8.0+ / PostgreSQL / MariaDB
-- ==============================================================================

-- 1. Create Database
CREATE DATABASE IF NOT EXISTS hr_analytics_db;
USE hr_analytics_db;

-- 2. Drop existing table if recreating
DROP TABLE IF EXISTS employee_attrition;

-- 3. Create Main Employee Attrition Table
CREATE TABLE employee_attrition (
    -- Identification & Demographics
    EmployeeNumber INT NOT NULL,
    Age INT NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    MaritalStatus VARCHAR(15) NOT NULL,
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
    OverTime VARCHAR(5) NOT NULL,
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
    Attrition VARCHAR(5) NOT NULL,
    
    -- Primary Key Definition
    CONSTRAINT pk_employee_number PRIMARY KEY (EmployeeNumber)
);

-- 4. Recommended Indexes for Analytical Query Optimization
CREATE INDEX idx_attrition ON employee_attrition (Attrition);
CREATE INDEX idx_department_role ON employee_attrition (Department, JobRole);
CREATE INDEX idx_overtime ON employee_attrition (OverTime);
CREATE INDEX idx_income_tenure ON employee_attrition (MonthlyIncome, YearsAtCompany);

-- 5. Verification
-- SELECT COUNT(*) AS total_records FROM employee_attrition;
