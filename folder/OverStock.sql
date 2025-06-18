CREATE VIEW OverstockView AS
SELECT 
    Store_ID, 
    Product_ID, 
    Inventory_Level, 
    Demand_Forecast
FROM dbo.inventory_forecasting
WHERE Inventory_Level > 1.5 * Demand_Forecast;
