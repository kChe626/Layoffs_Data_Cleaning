-- Layoffs Data Cleaning SQL Script
-- Description: Cleans and prepares layoffs dataset by standardizing fields, deduplicating rows, and handling missing data

--- Create and populate the initial staging table
CREATE TABLE layoffs_staging LIKE layoffs;

INSERT INTO layoffs_staging
SELECT * 
FROM layoffs;

--- Standardize text columns: lowercase, trim spaces, remove punctuation
UPDATE layoffs_staging 
SET company = LOWER(TRIM(company)),
    location = LOWER(TRIM(location)),
    industry = LOWER(TRIM(industry)),
    country = LOWER(TRIM(TRAILING '.' FROM country));

--- Identify duplicates using ROW_NUMBER over key fields
WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company, location, industry, total_laid_off, 
                            percentage_laid_off, `date`, stage, country, 
                            funds_raised_millions
           ) AS row_num
    FROM layoffs_staging
)
SELECT COUNT(*) AS duplicate_count 
FROM duplicate_cte 
WHERE row_num > 1;

--- Create second staging table with row numbers for easy dedupe
CREATE TABLE layoffs_staging2 (
    company TEXT,
    location TEXT,
    industry TEXT,
    total_laid_off INT DEFAULT NULL,
    percentage_laid_off TEXT,
    `date` TEXT,
    stage TEXT,
    country TEXT,
    funds_raised_millions INT DEFAULT NULL,
    row_num INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging2
SELECT *, 
       ROW_NUMBER() OVER (
           PARTITION BY company, location, industry, total_laid_off, 
                        percentage_laid_off, `date`, stage, country, 
                        funds_raised_millions
       ) AS row_num
FROM layoffs_staging;

--- Log how many duplicate rows will be deleted
SELECT COUNT(*) AS duplicates_to_delete 
FROM layoffs_staging2 
WHERE row_num > 1;

--- Delete duplicate rows
DELETE FROM layoffs_staging2 
WHERE row_num > 1;

--- Create index to speed up joins for filling industry
CREATE INDEX idx_company ON layoffs_staging2 (company(100));

--- Further standardization
UPDATE layoffs_staging2 
SET industry = 'crypto' 
WHERE industry LIKE 'crypto%';

--- Convert `date` field to DATE type
UPDATE layoffs_staging2 
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2 
MODIFY COLUMN `date` DATE;

--- Handle NULL and blank values
UPDATE layoffs_staging2 
SET industry = NULL 
WHERE industry = '';

--- Fill missing industry based on company
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2 
  ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
  AND t2.industry IS NOT NULL;

--- Remove rows without layoffs data
SELECT COUNT(*) AS rows_to_delete
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
  AND percentage_laid_off IS NULL;

DELETE FROM layoffs_staging2 
WHERE total_laid_off IS NULL 
  AND percentage_laid_off IS NULL;

--- Cleanup - drop helper column and index
ALTER TABLE layoffs_staging2 
DROP COLUMN row_num;

DROP INDEX idx_company ON layoffs_staging2;

--- Final check
SELECT * FROM layoffs_staging2;
