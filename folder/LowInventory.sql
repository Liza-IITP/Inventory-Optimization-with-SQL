CREATE VIEW LowInventoryView AS
SELECT 
    f.Store_ID,
    f.Product_ID,
    f.Inventory_Level,
    t.Reorder_Threshold
FROM dbo.inventory_forecasting f
JOIN (
    SELECT 
        Product_ID, 
        CAST(AVG(Demand_Forecast) * 1.1 AS INT) AS Reorder_Threshold
    FROM dbo.inventory_forecasting
    GROUP BY Product_ID
) t ON f.Product_ID = t.Product_ID
WHERE f.Inventory_Level < t.Reorder_Threshold;
