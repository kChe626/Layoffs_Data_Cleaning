
-- Create and populate the staging table
CREATE TABLE layoffs_staging LIKE layoffs;

INSERT INTO layoffs_staging
SELECT * 
FROM layoffs;

-- Identify duplicates
WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company, location, industry, total_laid_off, 
                            percentage_laid_off, date, stage, country, 
                            funds_raised_millions
           ) AS row_num
    FROM layoffs_staging
)
SELECT * FROM duplicate_cte WHERE row_num > 1;

-- Check for a specific company
SELECT * FROM layoffs_staging WHERE company = 'Casper';

-- Create a secondary staging table
CREATE TABLE layoffs_staging2 (
    company TEXT,
    location TEXT,
    industry TEXT,
    total_laid_off INT DEFAULT NULL,
    percentage_laid_off TEXT,
    date TEXT,
    stage TEXT,
    country TEXT,
    funds_raised_millions INT DEFAULT NULL,
    row_num INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Populate the second staging table with row numbers
INSERT INTO layoffs_staging2
SELECT *, 
       ROW_NUMBER() OVER (
           PARTITION BY company, location, industry, total_laid_off, 
                        percentage_laid_off, date, stage, country, 
                        funds_raised_millions
       ) AS row_num
FROM layoffs_staging;

-- Identify and remove duplicates
SELECT * 
FROM layoffs_staging2 
WHERE row_num > 1;

DELETE FROM layoffs_staging2 WHERE row_num > 1;

-- Standardizing data
UPDATE layoffs_staging2 SET company = TRIM(company);
UPDATE layoffs_staging2 SET industry = 'Crypto' WHERE industry LIKE 'Crypto%';
UPDATE layoffs_staging2 
SET country = TRIM(TRAILING '.' FROM country) 
WHERE country LIKE 'United States%';

-- Convert date field to proper format
UPDATE layoffs_staging2 
SET date = STR_TO_DATE(date, '%m/%d/%Y');

ALTER TABLE layoffs_staging2 MODIFY COLUMN date DATE;

-- Handle NULL and blank values
UPDATE layoffs_staging2 SET industry = NULL WHERE industry = '';

-- Propagate industry data where missing
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2 
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

-- Remove records with no layoffs data
DELETE FROM layoffs_staging2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- Final cleanup
ALTER TABLE layoffs_staging2 DROP COLUMN row_num;

-- Verify final dataset
SELECT * FROM layoffs_staging2;
