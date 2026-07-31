-- EXPLORATORY DATA ANALYSIS --

-- 1. What time period does this dataset cover?
SELECT MIN(date) AS earliest_date,
	   MAX(date) AS latest_date
FROM layoffs_staging2;
-- The dataset covers layoffs from 2020-03-11 to 2023-03-06

-- 2. How many companies are there?
SELECT COUNT(DISTINCT company) AS Total_companies
FROM layoffs_staging2;
-- There are 1628 unique companies in dataset.

-- 3. How many different industries are represented in the layoffs dataset?
SELECT COUNT(DISTINCT industry) AS Total_industries
FROM layoffs_staging2;
-- There are 30 different industries in the dataset.

-- 4. In how many countries these layoffs occur?
SELECT COUNT(DISTINCT country) AS Total_countries
FROM layoffs_staging2;
-- There are 52 different countries in the dataset.

-- 5. How many different locations are represented in the layoffs dataset?
SELECT COUNT(DISTINCT location) AS Total_location
FROM layoffs_staging2;
-- There are 168 diff location present in dataset.

-- 6. Which company laid off the most people in single layoff event?
SELECT company, total_laid_off
FROM layoffs_staging2
ORDER BY total_laid_off DESC
LIMIT 1;
-- Google has the highest single layoff event with 12000 employees being laid off.

-- 7. Which are the top 10 companies by total layoffs?
SELECT company, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY company
ORDER BY total_layoffs DESC
LIMIT 10; 
-- The top 10 companies with the highest cumulative layoffs are displayed above.

-- 8. Which industry had the highest layoffs?
SELECT industry, SUM(total_laid_off) AS total_layoff
FROM layoffs_staging2
GROUP BY industry
ORDER BY total_layoff DESC
LIMIT 1;
-- Consumer industry had the highest lay offs with over 45182 people getting laid off.

-- 9. Which 10 countries had the highest layoffs? 
SELECT country, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY country
ORDER BY total_layoffs DESC
LIMIT 10;
-- United states had the highest layoff with over 254874 people getting laid off, followed by India Netherlands Sweden and Brazil.

-- 10. Which funding stage had the highest layoffs? 
SELECT stage, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY stage
ORDER BY total_layoffs DESC
LIMIT 5;
-- Post-IPO had the highest layoffs followed by Acquired, Series C, Series D.

-- 11. How many layoffs occurred each year? 
SELECT YEAR(date) AS layoff_year, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY YEAR(date) 
ORDER BY layoff_year DESC;
-- We can see 2023 was the worst year for layoffs.

-- 12. How many layoffs occurred each month?
SELECT DATE_FORMAT(date, '%Y-%m') AS layoff_months, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY DATE_FORMAT(date, '%Y-%m')
ORDER BY layoff_months ;
-- So jan in 2023 saw the highest no of layoffs.

-- 13. What is the rolling monthly total of layoffs? 
WITH monthly_layoffs AS
(
    SELECT DATE_FORMAT(date, '%Y-%m') AS layoff_month,
           SUM(total_laid_off) AS monthly_total
    FROM layoffs_staging2
    GROUP BY DATE_FORMAT(date, '%Y-%m')
)

SELECT layoff_month,
       monthly_total,
       SUM(monthly_total) OVER (ORDER BY layoff_month) AS rolling_total
FROM monthly_layoffs;
-- The running total increases month by month throughout the dataset.

-- 14.Which companies had the highest layoffs in each year?
WITH company_year AS
(
    SELECT YEAR(date) AS layoff_year,
           company,
           SUM(total_laid_off) AS total_layoffs
    FROM layoffs_staging2
    GROUP BY YEAR(date), company
),

company_rank AS
(
    SELECT *,
           DENSE_RANK() OVER(
               PARTITION BY layoff_year
               ORDER BY total_layoffs DESC
           ) AS ranking
    FROM company_year
)

SELECT layoff_year,
       company,
       total_layoffs
FROM company_rank
WHERE ranking = 1
ORDER BY layoff_year;
-- The top company for each year is shown above.

-- 15. Which industries had the highest layoff in each year?
WITH industry_year AS
(
    SELECT YEAR(date) AS layoff_year,
           industry,
           SUM(total_laid_off) AS total_layoffs
    FROM layoffs_staging2
    GROUP BY YEAR(date), industry
),

industry_rank AS
(
    SELECT *,
           DENSE_RANK() OVER(
               PARTITION BY layoff_year
               ORDER BY total_layoffs DESC
           ) AS ranking
    FROM industry_year
)

SELECT layoff_year,
       industry,
       total_layoffs
FROM industry_rank
WHERE ranking = 1
ORDER BY layoff_year;
-- The top industry for each year is displayed above.

-- 16. Which companies laid off 100% of their employee?
SELECT company, industry, percentage_laid_off
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
-- Companies like Britishvolt Quilbi and Deliveroo Australia laid off 100% of their employee.

-- 17. Which companies raised the most funding before layoffs?
SELECT company,
       funds_raised_millions,
       total_laid_off,
       percentage_laid_off,
       stage,
       country,
       date
FROM layoffs_staging2
ORDER BY funds_raised_millions DESC,
		total_laid_off DESC;
-- Companies with substantial funding, such as Netflix, Meta, and Uber, also experienced significant layoffs,
-- suggesting that layoffs were driven by business strategy and market conditions rather than a lack of funding.

-- FINAL BUSINESS INSIGHTS --

-- The dataset covers layoff events from March 2020 to March 2023.

-- Layoffs were reported across 52 countries, highlighting the global impact.

-- Google recorded the largest single layoff event, laying off 12,000 employees.

-- Consumer and Retail industries experienced the highest number of layoffs.

-- The United States accounted for the largest share of total layoffs.

-- Layoffs peaked in 2023, indicating the most severe workforce reductions during the period.

-- Several companies laid off 100% of their workforce, resulting in complete shutdowns or business closures.

-- Even highly funded companies such as Netflix, Meta, and Uber announced major layoffs,
-- suggesting that strong funding alone did not protect companies from workforce reductions.

--  The rolling monthly analysis shows a steady increase in layoffs after the COVID-19 pandemic.