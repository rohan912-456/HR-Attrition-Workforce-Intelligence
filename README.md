# HR Attrition & Workforce Intelligence

Built an end-to-end data analytics project using Excel, SQL, Python, and Power BI to analyze HR data for 1,470 employees and find out why people leave the company.

The project uses a 35-column dataset to figure out what causes voluntary attrition and creates a watchlist to predict who might leave next.

### How it was done:
- **Excel:** Checked data quality and used pivot tables to find that overtime workers have nearly 3x higher turnover.
- **SQL (MySQL):** Created a rule-based risk model that groups employees into High, Medium, and Low risk segments, showing a huge difference in turnover rates between segments.
- **Python:** Used Pandas, Seaborn, and Matplotlib to calculate correlations and build a 0-to-3 point risk score that accurately maps to actual attrition (from 5.7% up to 59.0%).
- **Power BI:** Built a 3-page interactive dashboard to summarize the data, drill down into specific job roles, and show a live watchlist of at-risk employees.

## Key Findings
- **Overall Attrition:** 16.1% of employees (237 out of 1,470) left the company.
- **The Overtime Effect:** Employees working overtime have a 30.5% attrition rate, compared to 10.4% for those who don't.
- **Tenure Matters:** About 30% of employees leave within their first 2 years. This drops to ~17% for years 3-5 and ~11% after 6 years.
- **Pay Gap:** Employees who left made an average of $4,787/month, while those who stayed made $6,833/month (a $2,046 difference).
- **High-Risk Roles:** Sales Representatives (39.8% attrition) and Laboratory Technicians (23.9% attrition) are leaving the most.
- **Watchlist:** Identified 153 current employees who are at high risk of leaving based on the data.

## Power BI Dashboard
The project includes an interactive 3-page Power BI report.

### Page 1: Overview
![Overview](assets/dashboards/page1_executive_overview.png)

### Page 2: Deep Dive
![Deep Dive](assets/dashboards/page2_deep_dive.png)

### Page 3: Risk Watchlist
![Risk Watchlist](assets/dashboards/page3_risk_watchlist.png)

## Project Architecture & Analytics Lifecycle

### 📊 Phase 1: Excel
**Data Cleaning & Exploratory Analysis**<br>
Audited 1,470 employee records across 35 columns for quality issues. Used pivot tables to discover that overtime workers leave at nearly **3x the rate** (30.53% vs 10.44%) — the biggest signal in the entire dataset.
```excel
=IF(B2="Yes", 1, 0)
```
*(Binary attrition flag created for pivot analysis)*

### 🗄️ Phase 2: MySQL
**Relational Queries & Risk Engine**<br>
Wrote 8 SQL queries using GROUP BY, HAVING, and nested CASE WHEN to break down attrition by department, job role, overtime, and income. Built a 3-tier risk model — High Risk employees leave at **36.60%** vs just **8.46%** for Low Risk (~4.3x gap).
```sql
CASE WHEN OverTime = 'Yes' AND JobSatisfaction <= 2 THEN 'High Risk' WHEN OverTime = 'Yes' OR JobSatisfaction <= 2 THEN 'Medium Risk' ELSE 'Low Risk' END
```

### 🐍 Phase 3: Python
**Correlation Analysis & Risk Scoring**<br>
Used Pandas, Seaborn, and Matplotlib to compute a Pearson correlation matrix across 24 numeric features. Built a 0–3 point risk flag score that maps cleanly to real attrition rates: **5.74% (Score 0) → 14.79% (Score 1) → 32.21% (Score 2) → 58.97% (Score 3)**.
```python
corr_matrix = df_clean[key_cols].corr()
```

### 📈 Phase 4: Power BI
**Interactive 3-Page Dashboard**<br>
Built a 3-page Power BI report using DAX measures. Page 1 gives the executive overview (overall 16.1% attrition), Page 2 breaks down who is leaving and why, and Page 3 shows the live watchlist of **153 currently active at-risk employees**.
```dax
Attrition Rate = DIVIDE(CALCULATE(COUNTROWS('HR-Employee-Attrition'), 'HR-Employee-Attrition'[Attrition]="Yes"), COUNTROWS('HR-Employee-Attrition'))
```

## 💡 Strategic Recommendations for HR Leadership

| Strategic Pillar | Identified Root Cause | Proposed HR Intervention | Expected Business ROI |
| :--- | :--- | :--- | :--- |
| **1. Stop Too Much Overtime** | People working overtime quit at a 30.5% rate (nearly 3 times more than normal). | Put a strict limit on how much overtime people can work in a row, and make sure they get enough rest. | Fewer people will quit from burnout, which saves us money on hiring replacements. |
| **2. Help New Hires Better** | About 30% of all people who quit leave within their first 2 years. | Managers should talk to new hires at 30, 60, and 90 days to see how they are feeling and catch problems early. | New people will be happier and stick around longer instead of leaving right away. |
| **3. Fix Unfair Pay** | People who quit were making $2,046 less per month than those who stayed. | Check the salaries of our lowest-paid workers (especially Sales Reps and Lab Techs) and pay them a fair wage. | Stops our best people from leaving just to get a better paycheck somewhere else. |
| **4. Talk to At-Risk Staff Now** | We found 153 current employees who are at very high risk of quitting right now. | HR needs to sit down and talk to these 153 people immediately to find out what's bothering them and try to fix it. | We keep our experienced staff and don't have to scramble when they suddenly quit. |

## Repository Directory Structure
```text
HR-Attrition-Workforce-Intelligence/
├── README.md                                 <-- Executive case study & business r
├── LICENSE                                   <-- MIT License
├── .gitignore                                <-- Ignores temp Excel (~$*), Python
│
├── assets/                                   <-- Visual assets rendered in README
│   ├── dashboards/
│   │   ├── page1_executive_overview.png
│   │   ├── page2_deep_dive.png
│   │   └── page3_risk_watchlist.png
│   └── python_visuals/
│       ├── 01_attrition_overview.png
│       ├── 02_jobrole_satisfaction.png
│       ├── 03_correlation_heatmap.png
│       └── 04_risk_score_validation.png
│
├── data/
│   ├── raw/
│   │   └── HR-Employee-Attrition.csv         <-- Original raw dataset (1,470 recor
│   └── processed/
│       ├── dept_attrition.csv                <-- Departmental summary
│       ├── dept_attrition_python.csv         <-- Departmental summary (Python)
│       ├── dept_gender_attrition.csv         <-- Cross-demographic metrics
│       ├── hr_data_with_risk_score.csv       <-- Full dataset with Python risk scores
│       ├── income_comparison.csv             <-- Salary comparison metrics
│       ├── jobrole_attrition.csv             <-- Role-level matrix
│       ├── overtime_attrition.csv            <-- Overtime breakdown
│       ├── risk_score_validation.csv         <-- Python score validation
│       ├── risk_segments.csv                 <-- SQL risk segmentation results
│       ├── watchlist_employees.csv           <-- 23 high-priority active intervent
│       └── watchlist_from_python.csv         <-- High-priority active interventions (Python)
│
├── excel/
│   └── HR_Attrition_Analysis.xlsx            <-- Excel workbook with formulas & pi
│
├── power_bi/
│   └── HR_Attrition_Visualization.pbix       <-- Interactive 3-page Power BI dashb
│
├── python/
│   ├── HR_Attrition_Employee_Data_Analyst_Project.ipynb <-- Jupyter notebook for EDA & Risk Scoring
│   └── requirements.txt                      <-- Python environment dependencies
│
└── sql/
    ├── 01_schema_setup.sql                   <-- Database creation & table schema
    ├── 02_analytical_queries.sql             <-- Core analytical queries (GROUP BY
    └── 03_risk_segmentation_watchlist.sql    <-- Nested CASE WHEN & active wat
```

## 👨‍💻 Author & Contact

**Rohan Nandanwar**  
*Data Analyst | Class of 2026 Graduate*

If your team is hiring, or if you'd just like to chat about this project or data analytics in general, I would love to connect!

- 💼 **LinkedIn:** [linkedin.com/in/rohan4560](https://www.linkedin.com/in/rohan4560/)
- 💻 **GitHub:** [github.com/rohan912-456](https://github.com/rohan912-456)
- 📧 **Email:** [rohnandanwar456@gmail.com](mailto:rohnandanwar456@gmail.com)

---
⭐ *If you found this project interesting, a star on the repository is greatly appreciated!*
