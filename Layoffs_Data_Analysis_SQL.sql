-- Layoffs Data Analysis SQL Queries
-- Description: Business analysis Layoffs cleaned dataset

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

-- Layoffs by industry
SELECT 
    industry,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY industry
ORDER BY total_laid_off DESC;

-- Average percentage laid off by industry
SELECT 
    industry,
    ROUND(AVG(percentage_laid_off), 2) AS avg_percentage_laid_off
FROM layoffs_staging2
GROUP BY industry
ORDER BY avg_percentage_laid_off DESC;

-- Total layoffs by funding stage
SELECT 
    stage,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY stage
ORDER BY total_laid_off DESC;

-- Top 5 companies by funds raised
SELECT 
    company,
    MAX(funds_raised_millions) AS max_funds_raised
FROM layoffs_staging2
GROUP BY company
ORDER BY max_funds_raised DESC
LIMIT 5;
