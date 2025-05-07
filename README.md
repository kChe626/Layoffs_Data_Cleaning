
# 🧼 SQL Data Cleaning Project: Global Layoffs Dataset

> A real-world SQL data cleaning project using MySQL to prepare workforce layoff data for analysis, featuring staging layers, deduplication, standardization, and NULL handling.

---

## 🛠️ Key Tasks & SQL Techniques Used

| Task                         | SQL Techniques & Functions                                |
|-----------------------------|------------------------------------------------------------|
| Create staging tables       | `CREATE TABLE LIKE`, `INSERT INTO SELECT`                 |
| Detect duplicates           | `ROW_NUMBER() OVER (PARTITION BY...)`, `CTEs`             |
| Remove duplicates           | `DELETE WHERE row_num > 1`                                |
| Standardize text fields     | `TRIM()`, `LIKE`, `UPDATE`                                |
| Convert date formats        | `STR_TO_DATE()`, `ALTER TABLE MODIFY COLUMN`              |
| Handle NULLs & blanks       | `UPDATE`, `IS NULL`, `SELF JOIN`                          |
| Drop temp columns           | `ALTER TABLE DROP COLUMN`                                 |

---

## 💡 What Was Cleaned

- ✅ Duplicate entries removed using `ROW_NUMBER()`
- ✅ Inconsistent text (e.g., extra spaces, casing) cleaned
- ✅ Standardized industry and country fields
- ✅ Converted date strings into SQL `DATE` format
- ✅ Filled missing industry values using self-join logic
- ✅ Dropped records lacking all layoff data

---

## 🗂️ Dataset Overview

This dataset tracks workforce reductions across global companies between 2020 and 2023, capturing trends during the COVID-19 pandemic and post-pandemic recovery. Key fields include:

- **Company** – Organization name  
- **Location** – City/region of headquarters  
- **Industry** – Sector (e.g., Tech, Retail, Healthcare)  
- **Total Laid Off** – Number of employees impacted  
- **% Laid Off** – Proportion of total workforce affected  
- **Date** – Layoff date (month/year)  
- **Stage** – Company maturity (Seed, Series A, IPO, etc.)  
- **Country** – Country of operation  
- **Funds Raised (M)** – Capital raised in millions (USD)

---

## 🧹 Data Cleaning Process (MySQL)

This project focused on preparing a reliable, analysis-ready version of the dataset using structured SQL techniques. Key steps:

### ✅ 1. Duplicate Removal
- Created staging tables (`layoffs_staging`, `layoffs_staging2`) to preserve raw data
- Used `ROW_NUMBER()` over partitioned columns to identify duplicates
- Removed records where `row_num > 1`

### ✅ 2. Standardization
- **Company Names**: Removed whitespace using `TRIM()`
- **Industries**: Consolidated similar entries (e.g., “Crypto” and “Crypto Currency” → “Crypto”)
- **Countries**: Removed trailing punctuation (e.g., “United States.” → “United States”)
- **Dates**: Converted text to `DATE` format using `STR_TO_DATE('%m/%d/%Y')`

### ✅ 3. Handling Missing Values
- **Industry Imputation**: Used a `SELF JOIN` to fill missing industries for companies with other non-null entries
- **Null Filtering**: Removed records where both `total_laid_off` and `percentage_laid_off` were NULL

### ✅ 4. Column Cleanup
- Dropped helper fields like `row_num` after use

> **SQL Skills Highlighted:**  
> CTEs, Window Functions (`ROW_NUMBER()`), `TRIM()`, `LIKE`, `STR_TO_DATE()`, `SELF JOIN`

---

## 📊 Final Outcome

The cleaned dataset is now ready for analysis and visualization, with:
- No duplicate or empty rows
- Standardized categories (industries, countries, stages)
- Valid and queryable date formats
- Improved completeness with imputed fields

> This cleaned dataset supports clear insights into layoff trends by geography, funding stage, and industry.

---

📁 [Download the full SQL cleaning script](https://github.com/kChe626/Layoffs_Data_Cleaning/blob/main/layoffs_data_cleaned.txt)
