
![MySQL](https://img.shields.io/badge/mysql-%2300f.svg?style=for-the-badge&logo=mysql&logoColor=white)


# SQL Data Cleaning Project: Global Layoffs Dataset

This project showcases my SQL data cleaning process on a dataset of company layoffs. The goal was to prepare the dataset for analysis by addressing duplicates, standardizing values, handling missing data, and ensuring overall data quality.

---
## Dataset

The dataset contains information about layoffs at various companies, including:

    company — name of the company

    location — city of the company

    industry — industry sector

    total_laid_off — number of employees laid off

    percentage_laid_off — percentage of workforce laid off

    date — date of the layoff

    stage — funding stage

    country — country of the company

    funds_raised_millions — funds raised prior to layoff

  ---
  
## Cleaning Objectives

- Remove duplicate records
- Standardize text fields (e.g. trim spaces, fix casing)
- Convert date fields to proper DATE type
- Handle missing values (e.g. fill industry where possible)
- Remove rows without any layoff data
- Optimize for future analysis
- Cleaning Process
- Create staging tables

## Cleaning Process

### Create staging tables
I created staging tables to preserve the original data while performing cleaning operations.
```sql
CREATE TABLE layoffs_staging LIKE layoffs;
INSERT INTO layoffs_staging SELECT * FROM layoffs;
```

### Standardize text fields
I trimmed spaces, converted text to lowercase for consistency, and cleaned up special cases.
```sql
UPDATE layoffs_staging
SET company = LOWER(TRIM(company)),
    location = LOWER(TRIM(location)),
    industry = LOWER(TRIM(industry)),
    country = LOWER(TRIM(TRAILING '.' FROM country));
```

### Remove duplicates
I used a CTE with ROW_NUMBER() to identify and delete exact duplicates.
```sql
WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company, location, industry, total_laid_off,
                            percentage_laid_off, `date`, stage, country,
                            funds_raised_millions
           ) AS row_num
    FROM layoffs_staging
)
DELETE FROM layoffs_staging2
WHERE row_num > 1;
```

### Convert date field
I converted the string dates (MM/DD/YYYY) to MySQL DATE type for easier time-based analysis.
```sql
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;
```

### Handle missing industries
I filled missing industries where possible by matching the company field.
```sql
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2 
  ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;
```

### Remove incomplete records
I deleted rows where no layoff data was provided (both total_laid_off and percentage_laid_off were NULL).
```sql
DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL 
  AND percentage_laid_off IS NULL;
```
### See full [SQL cleaning script](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/Layoffs_Data_Cleaning_script_SQL.sql)
---
## Key SQL Techniques Used
- CTEs + ROW_NUMBER() for deduplication
- TRIM(), LOWER(), STR_TO_DATE() for data standardization
- JOIN updates for filling missing data
- Temporary indexing for performance

---
## Files
[Layoffs Dataset — Raw data](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/layoffs.csv)
[Layoffs_Data_Cleaning_script — SQL code for cleaning](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/Layoffs_Data_Cleaning_script_SQL.sql)




[Download the full SQL cleaning script](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/Layoffs_Data_Cleaning_script_SQL.sql)
