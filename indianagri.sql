USE INDIANAGRI;
SHOW TABLES;
SELECT * FROM indianagri_data;
SHOW COLUMNS FROM indianagri_data;


#1. Year-wise Trend of Rice Production Across States (Top 3)

SELECT `State Name`,
       SUM(`RICE PRODUCTION (1000 tons)`) AS Total_Rice_Production
FROM indianagri_data
GROUP BY `State Name`
ORDER BY SUM(`RICE PRODUCTION (1000 tons)`) DESC
LIMIT 3;
SELECT `Year`, 
       `State Name`,
       SUM(`RICE PRODUCTION (1000 tons)`) AS Rice_Production
FROM indianagri_data
WHERE `State Name` IN ('West Bengal', 'Uttar Pradesh', 'Punjab')  
GROUP BY `Year`, `State Name`
ORDER BY `Year`, `State Name`;


#2. Top 5 Districts by Wheat Yield Increase Over the Last 5 Years

SELECT `Dist Name`,
       (AVG(CASE WHEN `Year` = (SELECT MAX(`Year`) FROM indianagri_data) 
                 THEN `WHEAT YIELD (Kg per ha)` END) -
        AVG(CASE WHEN `Year` = (SELECT MAX(`Year`)-4 FROM indianagri_data) 
                 THEN `WHEAT YIELD (Kg per ha)` END)) AS Yield_Increase
FROM indianagri_data
GROUP BY `Dist Name`
ORDER BY Yield_Increase DESC
LIMIT 5;


#3. States with the Highest Growth in Oilseed Production (5-Year Growth Rate)

SELECT `State Name`,
       ( (SUM(CASE WHEN `Year` = (SELECT MAX(`Year`) FROM indianagri_data)
                   THEN `OILSEEDS PRODUCTION (1000 tons)` END) -
          SUM(CASE WHEN `Year` = (SELECT MAX(`Year`)-4 FROM indianagri_data)
                   THEN `OILSEEDS PRODUCTION (1000 tons)` END)
        )
        / NULLIF(SUM(CASE WHEN `Year` = (SELECT MAX(`Year`)-4 FROM indianagri_data)
                          THEN `OILSEEDS PRODUCTION (1000 tons)` END),0)
       ) * 100 AS Growth_Rate_Percent
FROM indianagri_data
GROUP BY `State Name`
ORDER BY Growth_Rate_Percent DESC
LIMIT 5;
 
 
 #4. District-wise Correlation Between Area and Production for Major Crops (Rice, Wheat, and Maize)
 
SELECT 
    `Dist Name`,

    IFNULL(
    (COUNT(*)*SUM(`RICE AREA (1000 ha)` * `RICE PRODUCTION (1000 tons)`)
     - SUM(`RICE AREA (1000 ha)`) * SUM(`RICE PRODUCTION (1000 tons)`))
    /
    NULLIF(SQRT(
        (COUNT(*)*SUM(POWER(`RICE AREA (1000 ha)`,2)) - POWER(SUM(`RICE AREA (1000 ha)`),2))
        *
        (COUNT(*)*SUM(POWER(`RICE PRODUCTION (1000 tons)`,2)) - POWER(SUM(`RICE PRODUCTION (1000 tons)`),2))
    ),0),0) AS Rice_Corr,

    IFNULL(
    (COUNT(*)*SUM(`WHEAT AREA (1000 ha)` * `WHEAT PRODUCTION (1000 tons)`)
     - SUM(`WHEAT AREA (1000 ha)`) * SUM(`WHEAT PRODUCTION (1000 tons)`))
    /
    NULLIF(SQRT(
        (COUNT(*)*SUM(POWER(`WHEAT AREA (1000 ha)`,2)) - POWER(SUM(`WHEAT AREA (1000 ha)`),2))
        *
        (COUNT(*)*SUM(POWER(`WHEAT PRODUCTION (1000 tons)`,2)) - POWER(SUM(`WHEAT PRODUCTION (1000 tons)`),2))
    ),0),0) AS Wheat_Corr,

    IFNULL(
    (COUNT(*)*SUM(`MAIZE AREA (1000 ha)` * `MAIZE PRODUCTION (1000 tons)`)
     - SUM(`MAIZE AREA (1000 ha)`) * SUM(`MAIZE PRODUCTION (1000 tons)`))
    /
    NULLIF(SQRT(
        (COUNT(*)*SUM(POWER(`MAIZE AREA (1000 ha)`,2)) - POWER(SUM(`MAIZE AREA (1000 ha)`),2))
        *
        (COUNT(*)*SUM(POWER(`MAIZE PRODUCTION (1000 tons)`,2)) - POWER(SUM(`MAIZE PRODUCTION (1000 tons)`),2))
    ),0),0) AS Maize_Corr

FROM indianagri_data
GROUP BY `Dist Name`;


#5. Yearly Production Growth of Cotton in Top 5 Cotton Producing States

SELECT `State Name`,
       SUM(`COTTON PRODUCTION (1000 tons)`) AS Total_Cotton_Production
FROM indianagri_data
GROUP BY `State Name`
ORDER BY Total_Cotton_Production DESC
LIMIT 5;
SELECT 
    `Year`,
    `State Name`,
    SUM(`COTTON PRODUCTION (1000 tons)`) AS Yearly_Cotton_Production
FROM indianagri_data
WHERE `State Name` IN ('Maharashtra', 'Gujarat', 'Andhra Pradesh', 'Punjab', 'Haryana')  -- replace with your top 5
GROUP BY `Year`, `State Name`
ORDER BY `Year`, `State Name`;
SELECT 
    `State Name`,
    `Year`,
    SUM(`COTTON PRODUCTION (1000 tons)`) AS Yearly_Cotton_Production,
    LAG(SUM(`COTTON PRODUCTION (1000 tons)`)) OVER (PARTITION BY `State Name` ORDER BY `Year`) AS Prev_Year_Production,
    ROUND(
        ( (SUM(`COTTON PRODUCTION (1000 tons)`) - 
           LAG(SUM(`COTTON PRODUCTION (1000 tons)`)) OVER (PARTITION BY `State Name` ORDER BY `Year`)
          ) / NULLIF(LAG(SUM(`COTTON PRODUCTION (1000 tons)`)) OVER (PARTITION BY `State Name` ORDER BY `Year`),0)
        ) * 100,2
    ) AS Growth_Percent
FROM indianagri_data
WHERE `State Name` IN ('Maharashtra', 'Gujarat', 'Andhra Pradesh', 'Punjab', 'Haryana') -- replace with your 5
GROUP BY `State Name`, `Year`
ORDER BY `State Name`, `Year`;

#6.Districts with the Highest Groundnut Production in 2017

SELECT 
    `Dist Name`,
    SUM(`GROUNDNUT PRODUCTION (1000 tons)`) AS Groundnut_Production_2017
FROM indianagri_data
WHERE `Year` = 2017
GROUP BY `Dist Name`
ORDER BY Groundnut_Production_2017 DESC
LIMIT 10;   -- top 10 districts

#7.Annual Average Maize Yield Across All States

SELECT 
    `Year`,
    AVG(`MAIZE YIELD (Kg per ha)`) AS Avg_Maize_Yield
FROM indianagri_data
GROUP BY `Year`
ORDER BY `Year`;

#8.Total Area Cultivated for Oilseeds in Each State

SELECT 
    `State Name`,
    SUM(`OILSEEDS AREA (1000 ha)`) AS Total_Oilseeds_Area
FROM indianagri_data
GROUP BY `State Name`
ORDER BY Total_Oilseeds_Area DESC;

#9.Districts with the Highest Rice Yield

SELECT 
    `Dist Name`,
    AVG(`RICE YIELD (Kg per ha)`) AS Avg_Rice_Yield
FROM indianagri_data
GROUP BY `Dist Name`
ORDER BY Avg_Rice_Yield DESC
LIMIT 10;   -- Top 10 districts

#10.Compare the Production of Wheat and Rice for the Top 5 States Over 10 Years

SELECT 
    `State Name`,
    SUM(`RICE PRODUCTION (1000 tons)` + `WHEAT PRODUCTION (1000 tons)`) AS Total_Production
FROM indianagri_data
GROUP BY `State Name`
ORDER BY Total_Production DESC
LIMIT 5;
SELECT 
    `Year`,
    `State Name`,
    SUM(`RICE PRODUCTION (1000 tons)`) AS Rice_Production,
    SUM(`WHEAT PRODUCTION (1000 tons)`) AS Wheat_Production
FROM indianagri_data
WHERE `State Name` IN ('Uttar Pradesh', 'Punjab', 'Madhya Pradesh', 'Bihar', 'West Bengal') -- replace with your top 5
  AND `Year` >= (SELECT MAX(`Year`) - 9 FROM indianagri_data)  -- last 10 years
GROUP BY `Year`, `State Name`
ORDER BY `Year`, `State Name`;
