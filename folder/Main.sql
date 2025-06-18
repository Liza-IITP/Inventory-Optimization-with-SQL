-- Derive Product-wise Reorder Thresholds with 10% Buffer
IF OBJECT_ID('tempdb..#Product_Reorder_Thresholds') IS NOT NULL DROP TABLE #Product_Reorder_Thresholds;

SELECT 
    Product_ID, 
    CAST(AVG(Demand_Forecast) * 1.1 AS INT) AS Reorder_Threshold  -- ?? 10% buffer to prevent stockouts
INTO #Product_Reorder_Thresholds
FROM dbo.inventory_forecasting
GROUP BY Product_ID;

--Track Stock Levels Across Stores
SELECT 
    Store_ID, 
    Product_ID, 
    Inventory_Level
FROM dbo.inventory_forecasting
ORDER BY Store_ID, Product_ID;

--  Detect Low Inventory Based on Auto-Derived Thresholds
SELECT 
    f.Store_ID,
    f.Product_ID,
    f.Inventory_Level,
    t.Reorder_Threshold
FROM dbo.inventory_forecasting f
JOIN #Product_Reorder_Thresholds t ON f.Product_ID = t.Product_ID
WHERE f.Inventory_Level < t.Reorder_Threshold
ORDER BY f.Inventory_Level ASC;

-- Analyze SKU Turnover (Sales/Inventory)
-- High Turnover Ratio = Fast Moving Item
SELECT 
    Product_ID,
    SUM(Units_Sold) AS Total_Sold,
    AVG(Inventory_Level) AS Avg_Inventory,
    CAST(SUM(Units_Sold) AS FLOAT) / NULLIF(AVG(Inventory_Level), 0) AS Turnover_Ratio
FROM dbo.inventory_forecasting
GROUP BY Product_ID
ORDER BY Turnover_Ratio DESC;

--  Per Store Turnover
SELECT 
    Store_ID,
    Product_ID,
    SUM(Units_Sold) AS Total_Sold,
    AVG(Inventory_Level) AS Avg_Inventory,
    CAST(SUM(Units_Sold) AS FLOAT) / NULLIF(AVG(Inventory_Level), 0) AS Turnover_Ratio
FROM dbo.inventory_forecasting
GROUP BY Store_ID, Product_ID
ORDER BY Turnover_Ratio DESC;

-- Forecast Demand and Sales Trends
SELECT 
    Product_ID,
    AVG(Demand_Forecast) AS Avg_Demand,
    AVG(Units_Sold) AS Avg_Sales
FROM dbo.inventory_forecasting
GROUP BY Product_ID
ORDER BY Avg_Demand DESC;

-- Monthly Trends
SELECT 
    Product_ID,
    FORMAT(Date, 'yyyy-MM') AS Month,
    AVG(Demand_Forecast) AS Monthly_Avg_Demand,
    AVG(Units_Sold) AS Monthly_Avg_Sales
FROM dbo.inventory_forecasting
GROUP BY Product_ID, FORMAT(Date, 'yyyy-MM')
ORDER BY Product_ID, Month;
-- Identify Overstocked Products
SELECT 
    Store_ID, 
    Product_ID, 
    Inventory_Level, 
    Demand_Forecast
FROM dbo.inventory_forecasting
WHERE Inventory_Level > 1.5 * Demand_Forecast  -- Overstock: inventory exceeds 150% of forecast
ORDER BY Inventory_Level DESC;

-- Add Pricing and Seasonality Analysis
SELECT 
    Store_ID,
    Product_ID,
    Inventory_Level,
    Demand_Forecast,
    Price,
    Seasonality,
    Inventory_Level - Demand_Forecast AS Surplus,
    (Inventory_Level - Demand_Forecast) * Price AS Approx_Overstock_Value
FROM dbo.inventory_forecasting
WHERE Inventory_Level > 1.5 * Demand_Forecast
ORDER BY Approx_Overstock_Value DESC;

DROP TABLE #Product_Reorder_Thresholds;

SELECT * FROM LowInventoryView;
SELECT * FROM OverstockView;
SELECT * FROM SKU_TurnoverView;
SELECT * FROM ForecastAccuracyView;
