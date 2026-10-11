--------------------------------------------------
-- SWIGGY RESTAURANT ANALYSIS
-- Tool: SQLite / DB Browser for SQLite
-- Dataset: 148,541 restaurant records
--------------------------------------------------


--------------------------------------------------
-- DATASET OVERVIEW
--------------------------------------------------

-- Total number of restaurant records
SELECT COUNT(*) AS total_restaurants
FROM swiggy;


--------------------------------------------------
-- DATA QUALITY CHECK
--------------------------------------------------

-- Check missing values in important columns
SELECT
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS null_names,
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS null_ratings,
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS null_cities,
    SUM(CASE WHEN cost IS NULL THEN 1 ELSE 0 END) AS null_costs
FROM swiggy;


--------------------------------------------------
-- Q1: TOP 10 CITY/LOCALITY ENTRIES BY RESTAURANT COUNT
--------------------------------------------------

SELECT
    city,
    COUNT(*) AS total_restaurants
FROM swiggy
GROUP BY city
ORDER BY total_restaurants DESC
LIMIT 10;


--------------------------------------------------
-- Q2: TOP 10 CUISINE ENTRIES BY RESTAURANT COUNT
--------------------------------------------------

SELECT
    cuisine,
    COUNT(*) AS restaurant_count
FROM swiggy
WHERE cuisine IS NOT NULL
GROUP BY cuisine
ORDER BY restaurant_count DESC
LIMIT 10;


--------------------------------------------------
-- Q3: RESTAURANT NAMES WITH MOST RECORDS
--------------------------------------------------

SELECT
    name,
    COUNT(*) AS restaurant_count
FROM swiggy
WHERE name IS NOT NULL
GROUP BY name
ORDER BY restaurant_count DESC
LIMIT 10;


--------------------------------------------------
-- Q4: TOP-RATED CITY/LOCALITY ENTRIES
-- Only entries with at least 50 restaurants
--------------------------------------------------

SELECT
    city,
    ROUND(AVG(CAST(rating AS FLOAT)), 2) AS avg_rating,
    COUNT(*) AS total_restaurants
FROM swiggy
WHERE rating NOT IN ('NEW', '--')
  AND rating IS NOT NULL
GROUP BY city
HAVING COUNT(*) >= 50
ORDER BY avg_rating DESC
LIMIT 10;


--------------------------------------------------
-- Q5: HIGHEST AVERAGE COST FOR TWO
--------------------------------------------------

SELECT
    city,
    ROUND(
        AVG(
            CAST(
                REPLACE(
                    REPLACE(cost, '₹', ''),
                    ',', ''
                ) AS INTEGER
            )
        ), 0
    ) AS avg_cost
FROM swiggy
WHERE cost IS NOT NULL
GROUP BY city
ORDER BY avg_cost DESC
LIMIT 10;


--------------------------------------------------
-- Q6: HIGHEST-RATED CUISINE ENTRIES
-- Only entries with more than 100 restaurants
--------------------------------------------------

SELECT
    cuisine,
    ROUND(AVG(CAST(rating AS FLOAT)), 2) AS avg_rating,
    COUNT(*) AS restaurant_count
FROM swiggy
WHERE rating NOT IN ('NEW', '--')
  AND rating IS NOT NULL
  AND cuisine IS NOT NULL
GROUP BY cuisine
HAVING COUNT(*) > 100
ORDER BY avg_rating DESC
LIMIT 10;


--------------------------------------------------
-- Q7: HIGHLY RATED RESTAURANTS WITH STRONG ENGAGEMENT
-- Rating >= 4.5 and rating count shown in thousands
--------------------------------------------------

SELECT
    name,
    city,
    rating,
    rating_count,
    cost
FROM swiggy
WHERE CAST(rating AS FLOAT) >= 4.5
  AND rating_count LIKE '%K%'
ORDER BY CAST(rating AS FLOAT) DESC
LIMIT 20;


--------------------------------------------------
-- Q8: RATING VS COST COMPARISON
-- Only city/locality entries with at least 30 restaurants
--------------------------------------------------

SELECT
    city,
    ROUND(AVG(CAST(rating AS FLOAT)), 2) AS avg_rating,
    ROUND(
        AVG(
            CAST(
                REPLACE(
                    REPLACE(cost, '₹', ''),
                    ',', ''
                ) AS INTEGER
            )
        ), 0
    ) AS avg_cost,
    COUNT(*) AS restaurant_count
FROM swiggy
WHERE rating NOT IN ('NEW', '--')
  AND rating IS NOT NULL
  AND cost IS NOT NULL
GROUP BY city
HAVING COUNT(*) >= 30
ORDER BY avg_rating DESC, avg_cost ASC
LIMIT 10;