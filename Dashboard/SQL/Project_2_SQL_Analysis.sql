/*
==============================================================
Project: Inventory Optimization & Demand Analytics
Author: Alan Leo
Tools: SQLite, Power BI
Description:
SQL analysis performed to understand inventory levels,
product demand, stock availability and supply chain performance.
==============================================================
*/

--------------------------------------------------------------
-- 1. View all records
--------------------------------------------------------------

SELECT * FROM stock;

SELECT * FROM past_orders;

--------------------------------------------------------------
-- 2. Total number of products
--------------------------------------------------------------

SELECT COUNT(*) AS Total_SKUs
FROM stock;

--------------------------------------------------------------
-- 3. Total Units Sold
--------------------------------------------------------------

SELECT
    SUM(`Order Quantity`) AS Total_Units_Sold
FROM past_orders;

--------------------------------------------------------------
-- 4. Top 10 Selling Products
--------------------------------------------------------------

SELECT
    `SKU ID`,
    SUM(`Order Quantity`) AS Total_Sold
FROM past_orders
GROUP BY `SKU ID`
ORDER BY Total_Sold DESC
LIMIT 10;

--------------------------------------------------------------
-- 5. Products Selling More Than 500 Units
--------------------------------------------------------------

SELECT
    `SKU ID`,
    SUM(`Order Quantity`) AS Total_Sold
FROM past_orders
GROUP BY `SKU ID`
HAVING SUM(`Order Quantity`) > 500;

--------------------------------------------------------------
-- 6. Current Inventory
--------------------------------------------------------------

SELECT
    `SKU ID`,
    `Current Stock Quantity`
FROM stock;

--------------------------------------------------------------
-- 7. Inventory Value
--------------------------------------------------------------

SELECT
    `SKU ID`,
    `Current Stock Quantity`,
    `Unit Price`,
    (`Current Stock Quantity` * `Unit Price`) AS Inventory_Value
FROM stock;

--------------------------------------------------------------
-- 8. Top Inventory Value Products
--------------------------------------------------------------

SELECT
    `SKU ID`,
    (`Current Stock Quantity` * `Unit Price`) AS Inventory_Value
FROM stock
ORDER BY Inventory_Value DESC
LIMIT 10;

--------------------------------------------------------------
-- 9. Average Lead Time
--------------------------------------------------------------

SELECT
    AVG(`Average Lead Time (days)`) AS Avg_Lead_Time
FROM stock;

--------------------------------------------------------------
-- 10. Maximum Lead Time
--------------------------------------------------------------

SELECT
    MAX(`Maximum Lead Time (days)`) AS Max_Lead_Time
FROM stock;

--------------------------------------------------------------
-- 11. Low Stock Products
--------------------------------------------------------------

SELECT
    `SKU ID`,
    `Current Stock Quantity`
FROM stock
WHERE `Current Stock Quantity` < 200;

--------------------------------------------------------------
-- 12. Stock Status Classification
--------------------------------------------------------------

SELECT
    `SKU ID`,
    `Current Stock Quantity`,
    CASE
        WHEN `Current Stock Quantity` < 200 THEN 'Low'
        WHEN `Current Stock Quantity` <= 500 THEN 'Medium'
        ELSE 'High'
    END AS Stock_Status
FROM stock;

--------------------------------------------------------------
-- 13. Join Orders with Inventory
--------------------------------------------------------------

SELECT
    past_orders.`SKU ID`,
    SUM(past_orders.`Order Quantity`) AS Total_Sold,
    stock.`Current Stock Quantity`
FROM past_orders
INNER JOIN stock
ON past_orders.`SKU ID` = stock.`SKU ID`
GROUP BY
    past_orders.`SKU ID`,
    stock.`Current Stock Quantity`;

--------------------------------------------------------------
-- 14. Products with High Sales and Low Stock
--------------------------------------------------------------

SELECT
    past_orders.`SKU ID`,
    SUM(past_orders.`Order Quantity`) AS Total_Sold,
    stock.`Current Stock Quantity`
FROM past_orders
INNER JOIN stock
ON past_orders.`SKU ID` = stock.`SKU ID`
GROUP BY
    past_orders.`SKU ID`,
    stock.`Current Stock Quantity`
HAVING
    SUM(past_orders.`Order Quantity`) > 500
    AND stock.`Current Stock Quantity` < 200;

--------------------------------------------------------------
-- End of SQL Analysis
--------------------------------------------------------------