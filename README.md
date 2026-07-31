# Global-Layoffs-Analysis
This project focuses on cleaning and analyzing a global layoffs dataset using MySQL.

The objective was to transform raw data into a clean dataset and perform Exploratory Data Analysis (EDA) to uncover trends and business insights about layoffs across different companies, industries, countries, and years.

---

## Tools Used

- MySQL 8.0
- MySQL Workbench
- SQL

---

## Dataset

The dataset contains information about company layoffs, including:

- Company
- Industry
- Location
- Country
- Date
- Total Laid Off
- Percentage Laid Off
- Funding Raised
- Stage

---

# Data Cleaning Process

The following data cleaning steps were performed:

### 1. Created a staging table
- Created duplicate tables to preserve the original dataset.

### 2. Removed duplicate records
- Identified duplicates using ROW_NUMBER().
- Deleted duplicate rows.

### 3. Standardized text values
- Standardized inconsistent values in:
  - Industry
  - Country
  - Company names

### 4. Removed extra spaces
- Used TRIM() to remove leading and trailing spaces.

### 5. Fixed NULL values
- Filled missing industry values where possible.
- Verified NULL values in other columns.

### 6. Converted date format
- Converted the date column from Text to DATE datatype using STR_TO_DATE().

### 7. Removed unnecessary rows
- Deleted records where both:
  - total_laid_off
  - percentage_laid_off
  were NULL.

---

# Exploratory Data Analysis (EDA)

The following business questions were answered:

1. What time period does the dataset cover?
2. How many unique companies are included?
3. How many industries are represented?
4. How many countries experienced layoffs?
5. How many locations are included?
6. Which company had the largest single layoff event?
7. Which companies had the highest total layoffs?
8. Which industry experienced the most layoffs?
9. Which countries recorded the highest layoffs?
10. Which funding stage had the highest layoffs?
11. How did layoffs change by year?
12. How did layoffs change by month?
13. What is the rolling monthly total of layoffs?
14. Which company had the highest layoffs each year?
15. Which industry had the highest layoffs each year?
16. Which companies laid off 100% of their workforce?
17. Which companies raised the most funding before layoffs?

---

# Key Business Insights

- The dataset covers layoffs from *March 2020 to March 2023*.
- Layoffs were reported across *52 countries*.
- *Google* recorded the largest single layoff event with *12,000 employees*.
- *Consumer* and *Retail* industries experienced the highest layoffs.
- The *United States* recorded the largest number of layoffs.
- Layoffs peaked during *2023*.
- Several companies laid off *100% of their workforce*.
- Companies like *Netflix, Meta, and Uber* had raised significant funding but still announced major layoffs, showing that high funding does not always prevent workforce reductions.


---

# Skills Demonstrated

- SQL
- Data Cleaning
- Data Validation
- Exploratory Data Analysis (EDA)
- Window Functions
- Common Table Expressions (CTEs)
- Aggregate Functions
- Date Functions
- Data Transformation

---

# Future Improvements

- Build an interactive Power BI dashboard.
- Create Tableau visualizations.
- Perform predictive analysis on layoff trends.

---

## 👨‍💻 Author

*Your Name*
