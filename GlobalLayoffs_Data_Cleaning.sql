-- CREATE A DATABASE 

CREATE DATABASE Global_Layoffs;

USE Global_Layoffs;

-- CREATE A DUPLICATE TABLE SO THAT ORIGINAL DATASET REMAIN AS IT IS

CREATE TABLE layoffs_staging
LIKE layoffs;

-- COPY THE DATA FROM THE ORIGINAL TABLE

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

-- DATA CLEANING 
-- 1. FIX DUPLICATES

SELECT *,
ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off,
								percentage_laid_off, date, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging;


WITH duplicate_cte AS
( SELECT *,
ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off,
								percentage_laid_off, date, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging)

SELECT *
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE layoffs_staging2 (
    company TEXT,
    location TEXT,
    industry TEXT,
    total_laid_off INT,
    percentage_laid_off TEXT,
    date TEXT,
    stage TEXT,
    country TEXT,
    funds_raised_millions INT,
    row_num INT
);

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
    PARTITION BY company,
                 location,
                 industry,
                 total_laid_off,
                 percentage_laid_off,
                 date,
                 stage,
                 country,
                 funds_raised_millions
) AS row_num
FROM layoffs_staging;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

SELECT COUNT(*)
FROM layoffs_staging2;

-- 2. STANDARDIZE TEXT

SELECT DISTINCT company
FROM layoffs_staging2
ORDER BY company;

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY industry;

SELECT industry,
COUNT(*) AS total_records
FROM layoffs_staging2
GROUP BY industry
ORDER BY total_records DESC;

SELECT *
FROM layoffs_staging2
WHERE industry IN ('Crypto Currency', 'CryptoCurrency');

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry IN ('Crypto Currency', 'CryptoCurrency');

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY industry;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY country;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY country;

SELECT DISTINCT stage
FROM layoffs_staging2
ORDER BY stage;

SELECT DISTINCT company
FROM layoffs_staging2
ORDER BY company;

SELECT company
FROM layoffs_staging2
WHERE company != TRIM(company);

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY location;

SELECT location
FROM layoffs_staging2
WHERE location != TRIM(location);

UPDATE layoffs_staging2
SET location = TRIM(location);

SELECT location,
COUNT(*) AS total_records
FROM layoffs_staging2
GROUP BY location
ORDER BY total_records DESC;

UPDATE layoffs_staging2
SET location = 'Dusseldorf'
WHERE location = 'DÃ¼sseldorf';

UPDATE layoffs_staging2
SET location = 'Malmo'
WHERE location = 'MalmÃ¶';

UPDATE layoffs_staging2
SET location = 'Florianopolis'
WHERE location = 'FlorianÃ³polis';

-- 3. REMOVE EXTRA SPACE

SELECT country
FROM layoffs_staging2
WHERE country != TRIM(country);

SELECT location
FROM layoffs_staging2
WHERE location != TRIM(location);

SELECT industry
FROM layoffs_staging2
WHERE industry != TRIM(industry);

SELECT stage
FROM layoffs_staging2
WHERE stage != TRIM(stage);

SELECT company
FROM layoffs_staging2
WHERE company != TRIM(company);

-- 4. FIX NULL VALUE

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
	OR industry = '';
    
SELECT *
FROM layoffs_staging2
WHERE company IN ('Airbnb', 'Bally''s Interactive', 'Carvana', 'Juul')
ORDER BY company;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
	OR industry = '';
    
SELECT company, industry
FROM layoffs_staging2
WHERE company IN ('Airbnb', 'Carvana', 'Juul', 'Bally''s Interactive')
ORDER BY company;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT company, industry
FROM layoffs_staging2
WHERE company IN ('Airbnb', 'Carvana', 'Juul', 'Bally''s Interactive')
ORDER BY company;

SELECT company, location, industry
FROM layoffs_staging2
WHERE company IN ('Airbnb', 'Carvana', 'Juul')
ORDER BY company;

SELECT company,
       location,
       industry,
       row_num
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT company,
       location,
       industry
FROM layoffs_staging2
WHERE company = 'Airbnb';

UPDATE layoffs_staging2
SET industry = 'Travel'
WHERE company = 'Airbnb'
AND industry IS NULL;

SELECT company, industry
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT company,
       industry,
       industry IS NULL AS is_null,
       LENGTH(industry) AS len
FROM layoffs_staging2
WHERE company = 'Airbnb';

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT company,
       industry,
       industry IS NULL AS is_null
FROM layoffs_staging2
WHERE company = 'Airbnb';

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT company, industry
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company IS NULL
   OR company = '';
   
SELECT *
FROM layoffs_staging2
WHERE location IS NULL
   OR location = '';

SELECT *
FROM layoffs_staging2
WHERE stage IS NULL
   OR stage = '';
   
-- 5. REMOVE USELESS ROWS

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- 6. CONVERT DATE FORMAT

DESCRIBE layoffs_staging2;

UPDATE layoffs_staging2
SET date = STR_TO_DATE(date, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN date DATE;

DESCRIBE layoffs_staging2;

-- REMOVE THE ROW_NUM COLUMN because it was created only to identify duplicates

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

DESCRIBE layoffs_staging2;

-- THANKYOU
