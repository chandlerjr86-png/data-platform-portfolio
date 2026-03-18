/*
========================================================
INVENTORY ANALYSIS – WIDEWORLDIMPORTERS
========================================================

Objective:
Explore the company's warehouse inventory and identify
products that may require replenishment.

Tables Used:
Warehouse.StockItems
    → Product catalog information (names and pricing)

Warehouse.StockItemHoldings
    → Current inventory levels and stocking targets
*/



--------------------------------------------------------
-- STEP 1 – Inventory Overview
--------------------------------------------------------
-- Business Question:
-- What products do we currently have in the warehouse
-- and how many units are available?
--
-- Purpose:
-- Establish a baseline view of inventory levels across
-- all products.
--
-- Key Fields:
-- StockItemName   → product name
-- QuantityOnHand  → number of units currently in stock
--------------------------------------------------------

SELECT  wsi.StockItemName
       ,wsih.QuantityOnHand
FROM Warehouse.StockItems wsi
INNER JOIN Warehouse.StockItemHoldings wsih
       ON wsi.StockItemID = wsih.StockItemID
ORDER BY wsih.QuantityOnHand DESC;



--------------------------------------------------------
-- STEP 2 – Inventory With Pricing Context
--------------------------------------------------------
-- Business Question:
-- What products do we have, how many units are in stock,
-- and what is their list price?
--
-- Purpose:
-- Adding price information provides economic context to
-- inventory levels and helps identify higher-value items.
--
-- Key Field Added:
-- UnitPrice → list price of the product
--------------------------------------------------------

SELECT  wsi.StockItemName
       ,wsi.UnitPrice
       ,wsih.QuantityOnHand
FROM Warehouse.StockItems wsi
INNER JOIN Warehouse.StockItemHoldings wsih
       ON wsi.StockItemID = wsih.StockItemID
ORDER BY wsih.QuantityOnHand DESC;



--------------------------------------------------------
-- STEP 3 – Inventory Replenishment Risk
--------------------------------------------------------
-- Business Question:
-- Which products are currently at or below their target
-- inventory level, and what is their reorder threshold?
--
-- Purpose:
-- Identify products that may require replenishment by
-- comparing current stock levels to the company's
-- inventory targets.
--
-- Key Fields Added:
-- TargetStockLevel → desired inventory level
-- ReorderLevel     → level at which purchasing should begin
--------------------------------------------------------

SELECT  wsi.StockItemName
       ,wsi.UnitPrice
       ,wsih.QuantityOnHand
       ,wsih.TargetStockLevel
       ,wsih.ReorderLevel
FROM Warehouse.StockItems wsi
INNER JOIN Warehouse.StockItemHoldings wsih
       ON wsi.StockItemID = wsih.StockItemID
WHERE wsih.QuantityOnHand <= wsih.TargetStockLevel
ORDER BY wsih.QuantityOnHand DESC;
