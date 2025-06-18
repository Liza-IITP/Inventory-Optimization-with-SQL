CREATE VIEW SKU_TurnoverView AS
SELECT 
    Product_ID,
    SUM(Units_Sold) AS Total_Sold,
    AVG(Inventory_Level) AS Avg_Inventory,
    CAST(SUM(Units_Sold) AS FLOAT) / NULLIF(AVG(Inventory_Level), 0) AS Turnover_Ratio
FROM dbo.inventory_forecasting
GROUP BY Product_ID;
