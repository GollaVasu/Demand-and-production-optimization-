use demand_and_production_optimization;
SELECT * FROM demand_and_production_optimization;
 -- typecasting
 
 SELECT 
    CAST(Date AS DATETIME) AS Date_datetime
FROM demand_and_production_optimization;

-- Handling duplicates 

SELECT 
    Order_ID, COUNT(*) AS duplicate_count
FROM demand_and_production_optimization
GROUP BY Order_ID
HAVING COUNT(*) > 1;

-- Step 1: Create a temporary table with unique records
CREATE TABLE temp_demand_and_production AS
SELECT * 
FROM demand_and_production_optimization
WHERE Order_ID IN (
    SELECT MIN(Order_ID) 
    FROM demand_and_production_optimization 
    GROUP BY Order_ID
);

-- Step 2: Remove all data from the original table
TRUNCATE TABLE demand_and_production_optimization;

-- Step 3: Reinsert unique records
INSERT INTO demand_and_production_optimization
SELECT * FROM temp_demand_and_production;

-- Step 4: Drop the temporary table
DROP TABLE temp_demand_and_production; 

-- outliers treatment  
WITH row_counts AS (
    SELECT COUNT(*) AS total_rows FROM demand_and_production_optimization
),
quartiles AS (
    SELECT 
        Machine_ID,
        Order_Quantity,
        Inventory_Level,
        Order_Volatility,
        Lead_Time_Days,
        Delay_Days,
        NTILE(4) OVER (ORDER BY Order_Quantity) AS Order_Quantity_Q,
        NTILE(4) OVER (ORDER BY Inventory_Level) AS Inventory_Level_Q,
        NTILE(4) OVER (ORDER BY Order_Volatility) AS Order_Volatility_Q,
        NTILE(4) OVER (ORDER BY Lead_Time_Days) AS Lead_Time_Days_Q,
        NTILE(4) OVER (ORDER BY Delay_Days) AS Delay_Days_Q
    FROM demand_and_production_optimization
),
median_values AS (
    SELECT 
        AVG(Order_Quantity) AS Order_Quantity_Median,
        AVG(Inventory_Level) AS Inventory_Level_Median,
        AVG(Order_Volatility) AS Order_Volatility_Median,
        AVG(Lead_Time_Days) AS Lead_Time_Days_Median,
        AVG(Delay_Days) AS Delay_Days_Median
    FROM demand_and_production_optimization t
    JOIN row_counts r
    ON (SELECT COUNT(*) FROM demand_and_production_optimization WHERE Order_Quantity <= t.Order_Quantity) 
       BETWEEN (r.total_rows / 2) AND (r.total_rows / 2 + 1)
)
UPDATE demand_and_production_optimization AS e
JOIN quartiles q ON e.Machine_ID = q.Machine_ID
JOIN median_values m
SET 
    e.Order_Quantity = CASE 
        WHEN q.Order_Quantity_Q = 1 OR q.Order_Quantity_Q = 4 
        THEN m.Order_Quantity_Median ELSE e.Order_Quantity 
    END,
    e.Inventory_Level = CASE 
        WHEN q.Inventory_Level_Q = 1 OR q.Inventory_Level_Q = 4 
        THEN m.Inventory_Level_Median ELSE e.Inventory_Level 
    END,
    e.Order_Volatility = CASE 
        WHEN q.Order_Volatility_Q = 1 OR q.Order_Volatility_Q = 4 
        THEN m.Order_Volatility_Median ELSE e.Order_Volatility 
    END,
    e.Lead_Time_Days = CASE 
        WHEN q.Lead_Time_Days_Q = 1 OR q.Lead_Time_Days_Q = 4 
        THEN m.Lead_Time_Days_Median ELSE e.Lead_Time_Days 
    END,
    e.Delay_Days = CASE 
        WHEN q.Delay_Days_Q = 1 OR q.Delay_Days_Q = 4 
        THEN m.Delay_Days_Median ELSE e.Delay_Days 
    END;

-- missing values 

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN Warehouse IS NULL THEN 1 ELSE 0 END) AS Warehouse_missing,
    SUM(CASE WHEN Dealer IS NULL THEN 1 ELSE 0 END) AS Dealer_missing,
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Customer_ID_missing,
    SUM(CASE WHEN Machine_ID IS NULL THEN 1 ELSE 0 END) AS Machine_ID_missing,
    SUM(CASE WHEN Machine_Type IS NULL THEN 1 ELSE 0 END) AS Machine_Type_missing,
    SUM(CASE WHEN Order_Quantity IS NULL THEN 1 ELSE 0 END) AS Order_Quantity_missing,
    SUM(CASE WHEN Production_Status IS NULL THEN 1 ELSE 0 END) AS Production_Status_missing,
    SUM(CASE WHEN Inventory_Level IS NULL THEN 1 ELSE 0 END) AS Inventory_Level_missing,
    SUM(CASE WHEN Order_Volatility IS NULL THEN 1 ELSE 0 END) AS Order_Volatility_missing,
    SUM(CASE WHEN Lead_Time_Days IS NULL THEN 1 ELSE 0 END) AS Lead_Time_Days_missing,
    SUM(CASE WHEN Delay_Days IS NULL THEN 1 ELSE 0 END) AS Delay_Days_missing
FROM demand_and_production_optimization;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM demand_and_production_optimization 
WHERE Warehouse IS NULL 
   OR Dealer IS NULL 
   OR Customer_ID IS NULL 
   OR Machine_ID IS NULL 
   OR Machine_Type IS NULL 
   OR Order_Quantity IS NULL 
   OR Production_Status IS NULL 
   OR Inventory_Level IS NULL 
   OR Order_Volatility IS NULL 
   OR Lead_Time_Days IS NULL 
   OR Delay_Days IS NULL;

SET SQL_SAFE_UPDATES = 1;  -- Re-enable safe mode

UPDATE demand_and_production_optimization
SET 
    Warehouse = COALESCE(Warehouse, 'Unknown'),
    Dealer = COALESCE(Dealer, 'Unknown'),
    Customer_ID = COALESCE(Customer_ID, 'Not Available'),
    Machine_ID = COALESCE(Machine_ID, 'Not Available'),
    Machine_Type = COALESCE(Machine_Type, 'Unknown'),
    Order_Quantity = COALESCE(Order_Quantity, 0),
    Production_Status = COALESCE(Production_Status, 'Pending'),
    Inventory_Level = COALESCE(Inventory_Level, 0),
    Order_Volatility = COALESCE(Order_Volatility, 0),
    Lead_Time_Days = COALESCE(Lead_Time_Days, 0),
    Delay_Days = COALESCE(Delay_Days, 0);




