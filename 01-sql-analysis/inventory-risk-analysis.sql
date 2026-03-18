/*
Inventory Status Analysis
Dataset: WideWorldImporters

Goal:
Show how a basic inventory lookup can be expanded into a more useful
operational report by adding supplier context and inventory status logic.

Each step reflects a more specific business request.
*/


---------------------------------------------------------
-- Step 1
-- Business Request:
-- "I just need a simple list showing every Product Name
-- and exactly how many we have in the building right now."
--
-- Purpose:
-- Establish a base inventory view using the stock item table
-- and the holdings table. This gives a simple product-level
-- snapshot of on-hand inventory.
---------------------------------------------------------

SELECT wsi.StockItemName AS ProductName, wsih.QuantityOnHand
FROM Warehouse.StockItems wsi
JOIN Warehouse.StockItemHoldings wsih
	ON wsi.StockItemID = wsih.StockItemID
ORDER BY ProductName



---------------------------------------------------------
-- Step 2
-- Business Request:
-- "I need a list of every product with less than 100 units
-- in stock. Include the Supplier Name so we know who to
-- call to get more."
--
-- Purpose:
-- Refine the report to focus only on low-stock items and
-- add supplier information for follow-up and replenishment.
---------------------------------------------------------

SELECT wsi.StockItemName AS ProductName, wsih.QuantityOnHand, ps.SupplierName
FROM Warehouse.StockItems wsi
JOIN Warehouse.StockItemHoldings wsih
	ON wsi.StockItemID = wsih.StockItemID
JOIN Purchasing.Suppliers ps
	ON wsi.SupplierID = ps.SupplierID
WHERE wsih.QuantityOnHand < 100
ORDER BY wsih.QuantityOnHand



---------------------------------------------------------
-- Step 3
-- Business Request:
-- "I need the same report, but I want a new column called Status.
-- If QuantityOnHand is 0, the status should say 'OUT OF STOCK'.
-- If it's between 1 and 50, it should say 'CRITICAL'.
-- Otherwise, it should say 'LOW'."
--
-- Purpose:
-- Add business logic using a CASE expression so the report
-- becomes more actionable for operations and inventory review.
--
-- Additional context:
-- BinLocation is included to show where the item is physically
-- stored in the warehouse.
---------------------------------------------------------

SELECT wsi.StockItemName AS ProductName, wsih.QuantityOnHand, wsih.BinLocation, ps.SupplierName, 'Status' =
CASE 
WHEN wsih.QuantityOnHand = 0 THEN 'OUT OF STOCK'
WHEN wsih.QuantityOnHand BETWEEN 1 AND 50 THEN 'CRITICAL'
ELSE 'LOW'
END
FROM Warehouse.StockItems wsi
JOIN Warehouse.StockItemHoldings wsih
	ON wsi.StockItemID = wsih.StockItemID
JOIN Purchasing.Suppliers ps
	ON wsi.SupplierID = ps.SupplierID
WHERE wsih.QuantityOnHand < 100
ORDER BY wsih.BinLocation
