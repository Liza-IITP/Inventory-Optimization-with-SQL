
-- Index to speed up filtering by product
CREATE INDEX idx_product ON dbo.inventory_forecasting(Product_ID);

-- Index to speed up filtering or grouping by store
CREATE INDEX idx_store ON dbo.inventory_forecasting(Store_ID);

-- Index for date-based analysis
CREATE INDEX idx_date ON dbo.inventory_forecasting(Date);

-- composite index
CREATE INDEX idx_store_product ON dbo.inventory_forecasting(Store_ID, Product_ID);
