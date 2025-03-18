## Dataset Description
This dataset tracks workforce reductions across companies globally from 2020 to 2023, capturing trends during the COVID-19 pandemic and post-pandemic recovery phases. It includes the following columns:

    Company: Name of the organization.

    Location: City/region of the company's headquarters.

    Industry: Sector or field of operation (e.g., tech, healthcare, retail).

    total_laid_off: Absolute number of employees laid off.

    percentage_laid_off: Proportion of the workforce affected (%).

    date: Month/year of the layoff event.

    stage: Company maturity stage (e.g., Seed, Series A, IPO).

    country: Country of operation.

    funds_raised_millions: Capital raised by the company (in USD millions).


## Data Cleaning Process

This project involved cleaning and standardizing a dataset tracking global workforce layoffs (2020–2023). Below are the key steps performed using MySQL:

1. Removing Duplicates

    Staging Tables: Created layoffs_staging and layoffs_staging2 to preserve raw data integrity.

    CTEs & Window Functions: Identified duplicates using ROW_NUMBER() partitioned by all columns (company, location, industry, etc.).

    Deletion: Removed duplicate records where row_num > 1, ensuring unique entries.

2. Standardizing Data

    Trimming Whitespace: Standardized company names with TRIM().

    Industry Consolidation: Grouped variants like "Crypto Currency" and "Crypto" into a single category ("Crypto").

    Country Formatting: Fixed trailing punctuation (e.g., "United States." → "United States").

    Date Conversion: Transformed text-based date into a DATE type using STR_TO_DATE('%m/%d/%Y').

3. Handling Nulls & Blanks

    Industry Imputation: Used a self-join to populate missing industry values for companies with existing entries (e.g., filling Airbnb’s industry from non-null records).

    Null Filtering: Removed rows where both total_laid_off and percentage_laid_off were NULL, as they provided no actionable insights.

4. Column Cleanup

    Deprecated Columns: Dropped the temporary row_num column after deduplication.

**SQL Techniques Used:** CTEs, Window Functions (ROW_NUMBER()), String Manipulation (TRIM(), LIKE), Self-Joins, Date Conversion (STR_TO_DATE).

## Outcome

The cleaned dataset is now analysis-ready, with: No duplicates or inconsistent entries. Standardized categories and temporal data. Improved completeness (imputed missing industries). Valid, query-friendly data types (e.g., dates).
This workflow ensures reliable insights into layoff trends, company stages, and geographic impacts.
