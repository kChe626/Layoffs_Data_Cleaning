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

## Car Sales Data Analysis Summary

This analysis explores key trends and patterns in car sales data using SQL. Below are the objectives, methods, and insights derived:
Objective 1: Sales Performance

    Sales by Company
    sql
    Copy

    SELECT company, COUNT(*) AS company_sales  
    FROM car_staging  
    GROUP BY company  
    ORDER BY company_sales DESC;  

        Insight: Identified top-performing companies by total sales volume (e.g., Toyota, Ford).

    Most Popular Car Model
    sql
    Copy

    SELECT company, model, COUNT(*) AS total_sales  
    FROM car_staging  
    GROUP BY company, model  
    ORDER BY total_sales DESC;  

        Insight: Highlighted the best-selling models (e.g., Honda Civic, Ford F-150).

    Top 5 Dealer Regions
    sql
    Copy

    SELECT dealer_region, COUNT(car_id) AS total_sales  
    FROM car_staging  
    GROUP BY dealer_region  
    ORDER BY total_sales DESC  
    LIMIT 5;  

        Insight: Revealed regions with the highest sales activity (e.g., California, Texas).

Objective 2: Customer Preferences

    Most Common Body Style
    sql
    Copy

    SELECT body_style, COUNT(*) AS total_purchases  
    FROM car_staging  
    GROUP BY body_style  
    ORDER BY total_purchases DESC;  

        Insight: SUVs and sedans dominated customer preferences.

    Price Range Analysis (Mid-Range Cars)
    sql
    Copy

    SELECT company, model, COUNT(*) AS total_sales  
    FROM car_staging  
    WHERE price_usd BETWEEN 15000 AND 40000  
    GROUP BY company, model  
    ORDER BY total_sales DESC;  

        Insight: Mid-range cars (e.g., Toyota Camry) accounted for the majority of sales.

Objective 3: Premium Sales & Luxury Market

    Highest-Priced Car Sold
    sql
    Copy

    SELECT company, model, price_usd  
    FROM car_staging  
    WHERE price_usd = (SELECT MAX(price_usd) FROM car_staging);  

        Insight: Luxury brands like Porsche or Ferrari had the highest single-sale values.

    BMW Sales in 2023
    sql
    Copy

    SELECT * FROM car_staging  
    WHERE company = 'BMW' AND sale_year = 2023;  

        Insight: Analyzed BMW’s recent sales performance and popular models.

Key SQL Techniques Used

    Aggregation: COUNT(), GROUP BY, ORDER BY.

    Subqueries: Identified max price for luxury car analysis.

    Filtering: WHERE, BETWEEN, and LIMIT for targeted insights.

    Window Functions: RANK() to determine top body styles by company.

Business Impact

    Identified top-selling brands/models to optimize inventory.

    Highlighted geographic hotspots for marketing focus.

    Uncovered customer preferences (body styles, price ranges) for strategic pricing.
