
![MySQL](https://img.shields.io/badge/mysql-%2300f.svg?style=for-the-badge&logo=mysql&logoColor=white)


# Global Employment Layoffs — SQL Data Cleaning & Analysis

This project demonstrates how to clean, standardize, and analyze global employment layoff data using SQL. The dataset contains records of layoffs across industries, companies, countries, and funding stages. 


## Dataset

- Source: [layoffs.csv](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/layoffs.csv)
- Columns: company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions

  
## Objectives for Cleaning

- Remove exact and near-duplicate records
- Standardize text fields (e.g., company, location, industry)
- Convert date strings to DATE type
- Handle missing and empty values in key fields
- Prepare data for downstream analysis

## Key SQL Techniques Used for Cleaning

- ROW_NUMBER() for duplicate detection
- STR_TO_DATE() for date conversion
- Indexing for performance on joins
- Conditional updates with JOIN for filling missing values

## SQL Script

See [Layoffs_Data_Cleaning_SQL.sql](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/Layoffs_Data_Cleaning_SQL.sql) for the full, well-commented SQL script.

## Example snippets
```sql
-- Identify duplicates using ROW_NUMBER()
WITH duplicate_cte AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
  FROM layoffs_staging
)
SELECT * FROM duplicate_cte WHERE row_num > 1;

-- Convert date strings to DATE type
UPDATE layoffs_staging2 
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
```

Example outputs:

```sql
-- Count of cleaned rows
SELECT COUNT(*) FROM layoffs_staging2;

-- Sample of cleaned data
SELECT * FROM layoffs_staging2 LIMIT 5;
```

## Results

- Original rows: Refer to layoffs.csv
- Cleaned rows: Run SELECT COUNT(*) FROM layoffs_staging2;
- Duplicates removed, dates standardized, and missing data addressed.
- [Download cleaned CSV](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/layoffs_cleaned.csv) — Contains the fully cleaned dataset for easy review.

## SQL Analysis

This section demonstrates SQL queries performed on the cleaned layoffs dataset (`layoffs_staging2`) to generate key business insights. The queries cover aggregation, trend analysis, and categorical breakdowns.

## Objectives

- Analyze layoffs by company, country, and industry.
- Identify trends over time (monthly, yearly).
- Understand layoffs by funding stage and funds raised.
- Provide metrics such as average percentage laid off by industry.

## SQL Analysis Script

See [Layoffs_Data_Analysis_SQL.sql](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/Layoffs_Data_Analysis_SQL.sql) for the full, well-commented SQL analysis queries.

## Example snippets

```sql
-- Total layoffs by company
SELECT 
    company, 
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY total_laid_off DESC
LIMIT 10;

-- Total layoffs by country
SELECT 
    country,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY country
ORDER BY total_laid_off DESC;

-- Monthly layoff trend
SELECT 
    YEAR(date) AS year,
    MONTH(date) AS month,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY year, month
ORDER BY year, month;
```

## Use Cases

The cleaned dataset and SQL analysis enable various real-world business insights and decision-making applications:

### Workforce Strategy
- Identify companies or industries with recurring large-scale layoffs to inform job-seeking strategies and workforce planning.
- Detect regions or countries most affected by layoffs to assess geographic employment risk.

### Investment Analysis
- Analyze layoffs in relation to funding stages and funds raised to evaluate startup stability and capital efficiency.
- Flag industries with high layoff percentages as potential high-risk sectors for investors.

### Trend Monitoring
- Track monthly or yearly layoff trends to study economic cycles and the impact of global events (e.g., pandemics, recessions).
- Compare layoffs across industries over time to identify sectors resilient to economic shocks.

### Product Development / Policy
- Support the development of career tools, job boards, or economic dashboards that use layoff data as an input.
- Inform policymakers and researchers on employment patterns for targeted interventions.



## Files
[Layoffs Dataset — Raw data](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/layoffs.csv)

[Layoffs_Data_Cleaning_script — SQL code for cleaning](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/Layoffs_Data_Cleaning_SQL.sql).

[Layoffs_Cleaned_Dataset - Cleaned dataset after SQL](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/layoffs_cleaned.csv)

[Layoffs_Analysis_Dataset - Qurries for analysing layoffs](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/Layoffs_Data_Analysis_SQL.sql)

