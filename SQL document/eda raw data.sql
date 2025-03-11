create database demand_and_production_optimization;
use demand_and_production_optimization;
SELECT * FROM demand_and_production_optimization;

# mean
SELECT AVG(Order_Quantity) AS mean_column
FROM demand_and_production_optimization;

SELECT AVG(Inventory_Level) AS mean_column
FROM demand_and_production_optimization;

SELECT AVG(Lead_Time_Days) AS mean_column
FROM demand_and_production_optimization;

SELECT AVG(Delay_Days) AS mean_column
FROM demand_and_production_optimization;

# median
SELECT Order_Quantity AS median_Column
FROM (
SELECT Order_Quantity, ROW_NUMBER() OVER (ORDER BY Order_Quantity) AS row_num,
COUNT(*) OVER () AS total_count
FROM demand_and_production_optimization
) AS subquery
WHERE row_num = (total_count + 1) / 2 OR row_num = (total_count + 2) / 2;

SELECT Inventory_Level AS median_Column
FROM (
SELECT Inventory_Level, ROW_NUMBER() OVER (ORDER BY Inventory_Level) AS row_num,
COUNT(*) OVER () AS total_count
FROM demand_and_production_optimization
) AS subquery
WHERE row_num = (total_count + 1) / 2 OR row_num = (total_count + 2) / 2; 

SELECT Lead_Time_Days AS median_Column
FROM (
SELECT Lead_Time_Days, ROW_NUMBER() OVER (ORDER BY Lead_Time_Days) AS row_num,
COUNT(*) OVER () AS total_count
FROM demand_and_production_optimization
) AS subquery
WHERE row_num = (total_count + 1) / 2 OR row_num = (total_count + 2) / 2;


SELECT Delay_Days AS median_Column
FROM (
SELECT Delay_Days, ROW_NUMBER() OVER (ORDER BY Delay_Days) AS row_num,
COUNT(*) OVER () AS total_count
FROM demand_and_production_optimization
) AS subquery
WHERE row_num = (total_count + 1) / 2 OR row_num = (total_count + 2) / 2;

# mode
SELECT Warehouse AS mode_Column
FROM (
SELECT Warehouse, COUNT(*) AS frequency
FROM demand_and_production_optimization
GROUP BY Warehouse
ORDER BY frequency DESC
LIMIT 1
) AS subquery;

SELECT Dealer AS mode_Column
FROM (
SELECT Dealer, COUNT(*) AS frequency
FROM demand_and_production_optimization
GROUP BY Dealer
ORDER BY frequency DESC
LIMIT 1
) AS subquery;

SELECT Customer_ID AS mode_Column
FROM (
SELECT Customer_ID, COUNT(*) AS frequency
FROM demand_and_production_optimization
GROUP BY Customer_ID
ORDER BY frequency DESC
LIMIT 1
) AS subquery;

SELECT Machine_ID AS mode_Column
FROM (
SELECT Machine_ID, COUNT(*) AS frequency
FROM demand_and_production_optimization
GROUP BY Machine_ID
ORDER BY frequency DESC
LIMIT 1
) AS subquery;

SELECT Machine_Type AS mode_Column
FROM (
SELECT Machine_Type, COUNT(*) AS frequency
FROM demand_and_production_optimization
GROUP BY Machine_Type
ORDER BY frequency DESC
LIMIT 1
) AS subquery;

SELECT Order_Quantity AS mode_Column
FROM (
SELECT Order_Quantity, COUNT(*) AS frequency
FROM demand_and_production_optimization
GROUP BY Order_Quantity
ORDER BY frequency DESC
LIMIT 1
) AS subquery;

SELECT Production_Status AS mode_Column
FROM (
SELECT Production_Status, COUNT(*) AS frequency
FROM demand_and_production_optimization
GROUP BY Production_Status
ORDER BY frequency DESC
LIMIT 1
) AS subquery;

SELECT Inventory_Level AS mode_Column
FROM (
SELECT Inventory_Level, COUNT(*) AS frequency
FROM demand_and_production_optimization
GROUP BY Inventory_Level
ORDER BY frequency DESC
LIMIT 1
) AS subquery;

SELECT Order_Volatility AS mode_Column
FROM (
SELECT Order_Volatility, COUNT(*) AS frequency
FROM demand_and_production_optimization
GROUP BY Order_Volatility
ORDER BY frequency DESC
LIMIT 1
) AS subquery;

SELECT Lead_Time_Days AS mode_Column
FROM (
SELECT Lead_Time_Days, COUNT(*) AS frequency
FROM demand_and_production_optimization
GROUP BY Lead_Time_Days
ORDER BY frequency DESC
LIMIT 1
) AS subquery;

SELECT Delay_Days AS mode_Column
FROM (
SELECT Delay_Days, COUNT(*) AS frequency
FROM demand_and_production_optimization
GROUP BY Delay_Days
ORDER BY frequency DESC
LIMIT 1
) AS subquery;

-- Standard Deviation for all columns
SELECT 
    STDDEV(Order_Quantity) AS Order_Quantity_stddev,
    STDDEV(Inventory_Level) AS Inventory_Level_stddev,
    STDDEV(Lead_Time_Days) AS Lead_Time_Days_stddev,
    STDDEV(Delay_Days) AS Delay_Days_stddev
FROM demand_and_production_optimization;

-- Variance for all columns
SELECT 
    VARIANCE(Order_Quantity) AS Order_Quantity_variance,
    VARIANCE(Inventory_Level) AS Inventory_Level_variance,
    VARIANCE(Lead_Time_Days) AS Lead_Time_Days_variance,
    VARIANCE(Delay_Days) AS Delay_Days_variance
FROM demand_and_production_optimization;

-- Range for all columns
SELECT 
    MAX(Order_Quantity) - MIN(Order_Quantity) AS Order_Quantity_range,
    MAX(Inventory_Level) - MIN(Inventory_Level) AS Inventory_Level_range,
    MAX(Lead_Time_Days) - MIN(Lead_Time_Days) AS Lead_Time_Days_range,
    MAX(Delay_Days) - MIN(Delay_Days) AS Delay_Days_range
FROM demand_and_production_optimization;

-- skewness

-- Skewness for all 4 columns
SELECT 
    (
        SUM(POWER(Order_Quantity - (SELECT AVG(Order_Quantity) FROM demand_and_production_optimization), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(Order_Quantity) FROM demand_and_production_optimization), 3))
    ) AS Order_Quantity_skewness,

    (
        SUM(POWER(Inventory_Level - (SELECT AVG(Inventory_Level) FROM demand_and_production_optimization), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(Inventory_Level) FROM demand_and_production_optimization), 3))
    ) AS Inventory_Level_skewness,

    (
        SUM(POWER(Lead_Time_Days - (SELECT AVG(Lead_Time_Days) FROM demand_and_production_optimization), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(Lead_Time_Days) FROM demand_and_production_optimization), 3))
    ) AS Lead_Time_Days_skewness,

    (
        SUM(POWER(Delay_Days - (SELECT AVG(Delay_Days) FROM demand_and_production_optimization), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(Delay_Days) FROM demand_and_production_optimization), 3))
    ) AS Delay_Days_skewness

FROM demand_and_production_optimization;

 -- kurtosis
 
 -- Kurtosis for all 4 columns
SELECT 
    (
        (SUM(POWER(Order_Quantity - (SELECT AVG(Order_Quantity) FROM demand_and_production_optimization), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(Order_Quantity) FROM demand_and_production_optimization), 4))) - 3
    ) AS Order_Quantity_kurtosis,

    (
        (SUM(POWER(Inventory_Level - (SELECT AVG(Inventory_Level) FROM demand_and_production_optimization), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(Inventory_Level) FROM demand_and_production_optimization), 4))) - 3
    ) AS Inventory_Level_kurtosis,

    (
        (SUM(POWER(Lead_Time_Days - (SELECT AVG(Lead_Time_Days) FROM demand_and_production_optimization), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(Lead_Time_Days) FROM demand_and_production_optimization), 4))) - 3
    ) AS Lead_Time_Days_kurtosis,

    (
        (SUM(POWER(Delay_Days - (SELECT AVG(Delay_Days) FROM demand_and_production_optimization), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(Delay_Days) FROM demand_and_production_optimization), 4))) - 3
    ) AS Delay_Days_kurtosis

FROM demand_and_production_optimization;



