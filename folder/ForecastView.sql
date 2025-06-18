CREATE VIEW ForecastAccuracyView AS
SELECT 
    Product_ID,
    ROUND(AVG(Demand_Forecast), 2) AS Avg_Demand,
    ROUND(AVG(Units_Sold), 2) AS Avg_Sales,
    ROUND(AVG(Units_Sold) - AVG(Demand_Forecast), 2) AS Forecast_Error
FROM dbo.inventory_forecasting
GROUP BY Product_ID;
