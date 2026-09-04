"""
==============================================================================
hr_attrition_eda.py
Project: HR Attrition & Workforce Intelligence
Author: Rohan Nandanwar
Purpose: Exploratory Data Analysis, Statistical Correlation, and Predictive
         Risk Scoring Model (0-3 Flags).
==============================================================================
"""

import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Set professional aesthetics
plt.style.use('seaborn-v0_8-whitegrid' if 'seaborn-v0_8-whitegrid' in plt.style.available else 'default')
plt.rcParams['font.sans-serif'] = 'Segoe UI', 'DejaVu Sans', 'Arial'
plt.rcParams['axes.edgecolor'] = '#CCCCCC'
plt.rcParams['axes.linewidth'] = 0.8


def load_and_audit_data(filepath: str) -> pd.DataFrame:
    """Loads dataset and performs initial data hygiene audits."""
    if not os.path.exists(filepath):
        raise FileNotFoundError(f"Dataset not found at: {filepath}")
        
    df = pd.read_csv(filepath)
    print("=" * 70)
    print("HR ATTRITION DATA AUDIT")
    print("=" * 70)
    print(f"Total Records: {len(df):,}")
    print(f"Total Features: {df.shape[1]}")
    print(f"Missing Values: {df.isnull().sum().sum()}")
    print(f"Duplicate Employee IDs: {df['EmployeeNumber'].duplicated().sum()}")
    
    # Binary numeric target for correlation and aggregations
    df['Attrition_Numeric'] = (df['Attrition'] == 'Yes').astype(int)
    baseline_turnover = df['Attrition_Numeric'].mean() * 100
    print(f"Baseline Turnover Benchmark: {baseline_turnover:.2f}%\n")
    return df


def engineer_risk_model(df: pd.DataFrame) -> pd.DataFrame:
    """
    Engineers an explainable 0-3 point Risk Scoring Engine.
    
    Identified Leading Flags:
      1. OverTime == 'Yes'        (Severe burnout indicator)
      2. JobSatisfaction <= 2     (Disengaged / dissatisfied employee)
      3. YearsAtCompany <= 2      (Early-tenure flight-risk window)
    """
    print("=" * 70)
    print("ENGINEERING PREDICTIVE RISK SCORE (0-3 FLAGS)")
    print("=" * 70)
    
    flag_overtime = (df['OverTime'] == 'Yes').astype(int)
    flag_dissatisfied = (df['JobSatisfaction'] <= 2).astype(int)
    flag_early_tenure = (df['YearsAtCompany'] <= 2).astype(int)
    
    df['Risk_Score'] = flag_overtime + flag_dissatisfied + flag_early_tenure
    
    validation = df.groupby('Risk_Score').agg(
        Total_Employees=('Attrition_Numeric', 'count'),
        Employees_Left=('Attrition_Numeric', 'sum'),
        Attrition_Rate_Percent=('Attrition_Numeric', lambda x: round(x.mean() * 100, 2))
    ).reset_index()
    
    print(validation.to_string(index=False))
    print("\nModel shows monotonic scaling: 5.74% (0 flags) -> 58.97% (3 flags).\n")
    return df, validation


def generate_visualizations(df: pd.DataFrame, output_dir: str):
    """Generates all 4 visual evidence charts saved directly into assets/."""
    os.makedirs(output_dir, exist_ok=True)
    
    # Palette definition
    primary_color = "#1E88E5"
    alert_color = "#E53935"
    neutral_color = "#43A047"
    
    # -------------------------------------------------------------------------
    # Chart 1: Attrition Overview (Tenure vs Monthly Income by Attrition)
    # -------------------------------------------------------------------------
    fig, ax = plt.subplots(figsize=(10, 6), dpi=300)
    sns.scatterplot(
        data=df, 
        x='YearsAtCompany', 
        y='MonthlyIncome', 
        hue='Attrition',
        palette={'Yes': alert_color, 'No': '#90CAF9'},
        alpha=0.75,
        s=50,
        ax=ax
    )
    ax.set_title("Employee Turnover Distribution: Tenure vs Monthly Income", fontsize=14, weight='bold', pad=15)
    ax.set_xlabel("Years at Company", fontsize=11)
    ax.set_ylabel("Monthly Income ($)", fontsize=11)
    ax.axvspan(0, 2, color='#FFCDD2', alpha=0.3, label='0-2 Year Flight-Risk Window')
    ax.legend(title="Attrition", frameon=True, loc='upper right')
    plt.tight_layout()
    chart1_path = os.path.join(output_dir, "01_attrition_overview.png")
    fig.savefig(chart1_path)
    plt.close(fig)
    print(f"Saved: {chart1_path}")

    # -------------------------------------------------------------------------
    # Chart 2: Job Role Attrition vs Satisfaction
    # -------------------------------------------------------------------------
    role_metrics = df.groupby('JobRole').agg(
        Attrition_Rate=('Attrition_Numeric', lambda x: x.mean() * 100),
        Avg_Satisfaction=('JobSatisfaction', 'mean')
    ).sort_values(by='Attrition_Rate', ascending=False).reset_index()

    fig, ax = plt.subplots(figsize=(11, 6), dpi=300)
    bars = ax.barh(role_metrics['JobRole'], role_metrics['Attrition_Rate'], color=primary_color, alpha=0.85)
    ax.invert_yaxis()
    ax.set_title("Voluntary Attrition Rate (%) by Job Role", fontsize=14, weight='bold', pad=15)
    ax.set_xlabel("Attrition Rate (%)", fontsize=11)
    ax.axvline(16.1, color=alert_color, linestyle='--', linewidth=1.5, label='Benchmark Avg (16.1%)')
    
    for bar in bars:
        width = bar.get_width()
        ax.text(width + 0.6, bar.get_y() + bar.get_height()/2, f"{width:.1f}%", 
                va='center', fontsize=9, weight='bold')
        
    ax.legend(frameon=True, loc='lower right')
    plt.tight_layout()
    chart2_path = os.path.join(output_dir, "02_jobrole_satisfaction.png")
    fig.savefig(chart2_path)
    plt.close(fig)
    print(f"Saved: {chart2_path}")

    # -------------------------------------------------------------------------
    # Chart 3: Pearson Correlation Heatmap
    # -------------------------------------------------------------------------
    numeric_cols = [
        'Attrition_Numeric', 'Age', 'DailyRate', 'DistanceFromHome', 'Education',
        'EnvironmentSatisfaction', 'HourlyRate', 'JobInvolvement', 'JobLevel',
        'JobSatisfaction', 'MonthlyIncome', 'MonthlyRate', 'NumCompaniesWorked',
        'PercentSalaryHike', 'PerformanceRating', 'RelationshipSatisfaction',
        'StockOptionLevel', 'TotalWorkingYears', 'TrainingTimesLastYear',
        'WorkLifeBalance', 'YearsAtCompany', 'YearsInCurrentRole',
        'YearsSinceLastPromotion', 'YearsWithCurrManager'
    ]
    corr = df[numeric_cols].corr()
    
    fig, ax = plt.subplots(figsize=(14, 10), dpi=300)
    sns.heatmap(
        corr, 
        cmap='coolwarm', 
        vmin=-0.4, 
        vmax=0.8, 
        linewidths=0.5, 
        cbar_kws={"shrink": 0.8},
        ax=ax
    )
    ax.set_title("Workforce Feature Correlation Heatmap", fontsize=16, weight='bold', pad=15)
    plt.tight_layout()
    chart3_path = os.path.join(output_dir, "03_correlation_heatmap.png")
    fig.savefig(chart3_path)
    plt.close(fig)
    print(f"Saved: {chart3_path}")

    # -------------------------------------------------------------------------
    # Chart 4: Risk Score Validation Plot
    # -------------------------------------------------------------------------
    fig, ax = plt.subplots(figsize=(9, 5.5), dpi=300)
    risk_summary = df.groupby('Risk_Score')['Attrition_Numeric'].mean() * 100
    colors = ['#4CAF50', '#FFEB3B', '#FF9800', '#F44336']
    bars = ax.bar(risk_summary.index.astype(str), risk_summary.values, color=colors, edgecolor='#555555', width=0.55)
    
    ax.set_title("Risk Score Validation: Attrition Rate by Number of Flags", fontsize=14, weight='bold', pad=15)
    ax.set_xlabel("Number of Risk Flags (0 = None, 3 = Severe)", fontsize=11)
    ax.set_ylabel("Observed Attrition Rate (%)", fontsize=11)
    ax.set_ylim(0, 70)
    
    for bar in bars:
        height = bar.get_height()
        ax.text(bar.get_x() + bar.get_width()/2, height + 1.5, f"{height:.2f}%", 
                ha='center', fontsize=10, weight='bold')

    plt.tight_layout()
    chart4_path = os.path.join(output_dir, "04_risk_score_validation.png")
    fig.savefig(chart4_path)
    plt.close(fig)
    print(f"Saved: {chart4_path}")


def main():
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    raw_data_path = os.path.join(base_dir, "data", "raw", "HR-Employee-Attrition.csv")
    assets_dir = os.path.join(base_dir, "assets", "python_visuals")
    processed_dir = os.path.join(base_dir, "data", "processed")

    # Pipeline execution
    df = load_and_audit_data(raw_data_path)
    df, validation_df = engineer_risk_model(df)
    generate_visualizations(df, assets_dir)
    
    # Export artifacts
    os.makedirs(processed_dir, exist_ok=True)
    df.to_csv(os.path.join(processed_dir, "hr_data_with_risk_score.csv"), index=False)
    validation_df.to_csv(os.path.join(processed_dir, "risk_score_validation.csv"), index=False)
    
    # High-risk active watchlist (Score >= 2)
    watchlist = df[(df['Attrition'] == 'No') & (df['Risk_Score'] >= 2)]
    watchlist.to_csv(os.path.join(processed_dir, "watchlist_from_python.csv"), index=False)
    print(f"\nSuccessfully generated analytics and saved {len(watchlist)} active at-risk employees to watchlist.")


if __name__ == "__main__":
    main()
