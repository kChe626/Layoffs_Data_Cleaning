# **Global Employment Layoffs — SQL Data Cleaning & Analysis**  
![MySQL](https://img.shields.io/badge/mysql-%2300f.svg?style=for-the-badge&logo=mysql&logoColor=white)

---

## **Overview**  
This project demonstrates **data cleaning, standardization, and analysis** of a global layoffs dataset using **MySQL**. The dataset tracks layoffs across industries, companies, countries, and funding stages.  
The goal: transform raw CSV data into a reliable, analysis-ready dataset and extract business insights for workforce strategy, investment analysis, and trend monitoring.

---

## **Dataset**
- **Source:** [layoffs.csv](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/layoffs.csv)  
- **Columns:** company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions

---

## **Data Cleaning Process (SQL)**
**Objectives:**
- Remove duplicates  
- Standardize text formats  
- Convert date strings to DATE type  
- Handle missing values in key fields  
- Prepare data for downstream analysis  

**Key SQL Techniques:**
- `ROW_NUMBER()` for duplicate detection  
- `STR_TO_DATE()` for date conversion  
- Conditional updates with `JOIN`  
- Indexing for performance

**Example Snippets:**  
```sql
-- Identify duplicates
WITH duplicate_cte AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
         ) AS row_num
  FROM layoffs_staging
)
SELECT * FROM duplicate_cte WHERE row_num > 1;

-- Convert date strings to DATE type
UPDATE layoffs_staging2 
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
```  

**Full Cleaning Script:** [Layoffs_Data_Cleaning_SQL.sql](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/Layoffs_Data_Cleaning_SQL.sql)  
**Cleaned Dataset:** [layoffs_cleaned.csv](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/layoffs_cleaned.csv)

---

## **SQL Analysis**
**Objectives:**
- Analyze layoffs by company, country, and industry  
- Track trends over time (monthly, yearly)  
- Explore layoffs by funding stage and amount raised  

**Example Queries:**
```sql
-- Total layoffs by company
SELECT company, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY total_laid_off DESC
LIMIT 10;

-- Monthly layoff trend
SELECT YEAR(date) AS year, MONTH(date) AS month, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY year, month
ORDER BY year, month;
```

**Full Analysis Script:** [Layoffs_Data_Analysis_SQL.sql](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/Layoffs_Data_Analysis_SQL.sql)

---

## **Key Insights**
- Certain industries (e.g., tech startups) experienced higher layoff rates relative to funding stage.  
- Peak layoff periods often align with broader economic downturns.  
- Some high-funded companies still had significant layoffs, indicating potential misallocation of resources or market shifts.

---

## **Use Cases**
- **Workforce Strategy:** Identify high-risk sectors for job seekers and HR planning  
- **Investment Analysis:** Link layoffs to funding stages for risk assessment  
- **Economic Monitoring:** Track macroeconomic impacts on employment  

---

## **Business Relevance**

This dataset cleaning and analysis process supports HR and operations teams in workforce planning by identifying high-risk sectors, tracking layoff trends over time, and flagging companies with recurring workforce reductions. These insights help optimize staffing strategies and inform location-based hiring or downsizing decisions.

---

## **Files**
- [Raw Dataset](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/layoffs.csv)  
- [SQL Cleaning Script](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/Layoffs_Data_Cleaning_SQL.sql)
- [Cleaned Dataset](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/layoffs_cleaned.csv)
- [SQL Analysis Script](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/Layoffs_Data_Analysis_SQL.sql)  

