/*
Customer Order Analysis: WideWorldImporters
Author: Reed Chandler
Purpose: 
This script demonstrates the evolution of a business request from basic 
data retrieval to complex, aggregated financial analysis using CTEs.
*/

---------------------------------------------------------
-- Step 1: Base Data Retrieval
-- Business Request: "I need a list of every Customer and their Invoice Dates."
-- Technical Goal: Establish the grain of the data (one row per invoice).
---------------------------------------------------------

SELECT 
    sc.CustomerName, 
    si.InvoiceDate
FROM Sales.Customers sc
JOIN Sales.Invoices si ON sc.CustomerID = si.CustomerID;


---------------------------------------------------------
-- Step 2: Basic Aggregation
-- Business Request: "How many total orders has each customer placed?"
-- Technical Goal: Use COUNT and GROUP BY to transform transactional 
-- rows into summarized insights.
---------------------------------------------------------

SELECT 
    sc.CustomerName, 
    COUNT(si.InvoiceID) AS TotalOrders
FROM Sales.Customers sc
JOIN Sales.Invoices si ON sc.CustomerID = si.CustomerID
GROUP BY sc.CustomerName
ORDER BY TotalOrders DESC;


---------------------------------------------------------
-- Step 3: Result Filtering
-- Business Request: "Focus only on our high-frequency customers (10+ orders)."
-- Technical Goal: Demonstrate the use of the HAVING clause to filter 
-- aggregated results (post-grouping).
---------------------------------------------------------

SELECT 
    sc.CustomerName, 
    COUNT(si.InvoiceID) AS TotalOrders
FROM Sales.Customers sc
JOIN Sales.Invoices si ON sc.CustomerID = si.CustomerID
GROUP BY sc.CustomerName
HAVING COUNT(si.InvoiceID) > 10
ORDER BY TotalOrders DESC;


---------------------------------------------------------
-- Step 4: Advanced Financial Analysis (Final Model)
-- Business Request: "Show Total Orders and Total Spend for high-frequency 
-- customers in 2016. Format for a business report."
--
-- Technical Logic: 
-- 1. Use a CTE to isolate 2016 data and ensure a linear join path 
--    (Customer -> Invoice -> Transaction) to prevent data fan-out.
-- 2. Join on InvoiceID instead of CustomerID to maintain 1:1 integrity.
-- 3. Apply COUNT(DISTINCT) as a fail-safe for accurate order counts.
---------------------------------------------------------

WITH CustomerRevenue AS (
    SELECT 
        sc.CustomerName,
        si.InvoiceID,
        ct.TransactionAmount
    FROM Sales.Customers sc
    JOIN Sales.Invoices si ON sc.CustomerID = si.CustomerID
    -- Joining on InvoiceID prevents duplicate transaction sums
    JOIN Sales.CustomerTransactions ct ON si.InvoiceID = ct.InvoiceID
    WHERE si.InvoiceDate BETWEEN '2016-01-01' AND '2016-12-31'
)
SELECT 
    CustomerName,
    FORMAT(COUNT(DISTINCT InvoiceID), 'N0') AS TotalOrders,
    FORMAT(SUM(TransactionAmount), 'C') AS TotalSpent
FROM CustomerRevenue
GROUP BY CustomerName
HAVING COUNT(DISTINCT InvoiceID) > 10
ORDER BY SUM(TransactionAmount) DESC;
