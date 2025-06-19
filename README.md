
![MySQL](https://img.shields.io/badge/mysql-%2300f.svg?style=for-the-badge&logo=mysql&logoColor=white)


# Global Employment Layoffs — SQL Data Cleaning

This project demonstrates how to clean and standardize global employment layoff data using SQL. The dataset contains records of layoffs across industries, companies, and countries. The goal is to prepare a reliable dataset for further analysis by removing duplicates, standardizing fields, handling missing values, and converting data types.


## Dataset

- Source: [layoffs.csv](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/layoffs.csv)
- Columns: company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions

  
## Objectives

- Remove exact and near-duplicate records
- Standardize text fields (e.g., company, location, industry)
- Convert date strings to DATE type
- Handle missing and empty values in key fields
- Prepare data for downstream analysis

## Key SQL Techniques Used

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

- Original rows: Refer to layoffs(1).csv
- Cleaned rows: Run SELECT COUNT(*) FROM layoffs_staging2;
- Duplicates removed, dates standardized, and missing data addressed.
- [Download cleaned CSV](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/layoffs_cleaned.csv) — Contains the fully cleaned dataset for easy review.

---
## Files
[Layoffs Dataset — Raw data](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/layoffs.csv)
[Layoffs_Data_Cleaning_script — SQL code for cleaning](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/Layoffs_Data_Cleaning_SQL.sql)
[Layoffs_Cleaned_Dataset - Cleaned dataset after SQL](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/layoffs_cleaned.csv)

