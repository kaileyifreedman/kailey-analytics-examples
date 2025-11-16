-- salesco_queries.sql
-- Sample SQL queries for the SalesCo database
-- Author: Kailey Freedman-Setaro
-- Course: TAC 249 – Introduction to Data Analytics (Fall 2025)

USE salesco;

-- 1) List all customers’ first names and the date they made the purchase.
SELECT 
    c.CUS_FNAME,
    i.INV_DATE
FROM CUSTOMER c
JOIN INVOICE i ON c.CUS_CODE = i.CUS_CODE;

-- 2) Find the average price of products for each vendor and display
--    the results in descending order of the average price.
SELECT 
    V_CODE,
    AVG(P_PRICE) AS AveragePrice
FROM PRODUCT
GROUP BY V_CODE
ORDER BY AveragePrice DESC;

-- 3) List the orders placed by each customer along with the product
--    description and order date, ordered by the customer's last name and date.
SELECT 
    c.CUS_LNAME,
    p.P_DESCRIPT,
    i.INV_DATE
FROM INVOICE i
JOIN CUSTOMER c ON c.CUS_CODE = i.CUS_CODE
JOIN LINE l ON i.INV_NUMBER = l.INV_NUMBER
JOIN PRODUCT p ON l.P_CODE = p.P_CODE
ORDER BY c.CUS_LNAME, i.INV_DATE;

-- 4) List the product code, product description, vendor name, and vendor state
--    for all products sourced from vendors located in Georgia (GA).
--    Order the results by product code.
SELECT 
    p.P_CODE,
    p.P_DESCRIPT,
    v.V_NAME,
    v.V_STATE
FROM PRODUCT p
JOIN VENDOR v ON p.V_CODE = v.V_CODE
WHERE v.V_STATE = 'GA'
ORDER BY p.P_CODE ASC;

-- 5) Summarize the products currently in inventory, ordered by replenishment
--    demand. Include product code, description, current stock, minimum stock,
--    and extra items above minimum.
SELECT 
    P_CODE,
    P_DESCRIPT,
    P_QOH,
    P_MIN,
    P_QOH - P_MIN AS ExtraItems
FROM PRODUCT
ORDER BY ExtraItems ASC;

-- 6) Calculate the total dollar sales, total items sold, and average item price
--    for each area.
SELECT 
    c.CUS_AREACODE AS Area,
    SUM(l.LINE_UNITS * l.LINE_PRICE) AS TotalDolSales,
    SUM(l.LINE_UNITS) AS TotalItemsSold,
    SUM(l.LINE_UNITS * l.LINE_PRICE) / NULLIF(SUM(l.LINE_UNITS), 0) AS AvgItemPrice
FROM CUSTOMER c
JOIN INVOICE i ON i.CUS_CODE = c.CUS_CODE
JOIN LINE l ON l.INV_NUMBER = i.INV_NUMBER
GROUP BY c.CUS_AREACODE
ORDER BY Area;

-- 7) Calculate the average quantity of products purchased per order by each customer.
SELECT 
    c.CUS_CODE,
    SUM(l.LINE_UNITS) AS TotalQuantityPurchased,
    COUNT(DISTINCT i.INV_NUMBER) AS NumberOfOrders,
    SUM(l.LINE_UNITS) / COUNT(DISTINCT i.INV_NUMBER) AS AvgQuantityPerOrder
FROM CUSTOMER c
JOIN INVOICE i ON i.CUS_CODE = c.CUS_CODE
JOIN LINE l ON l.INV_NUMBER = i.INV_NUMBER
GROUP BY c.CUS_CODE
ORDER BY c.CUS_CODE;

-- 8) List customers who have purchased cloth or pipe.
SELECT DISTINCT
    c.CUS_CODE,
    c.CUS_LNAME,
    c.CUS_FNAME
FROM CUSTOMER c
JOIN INVOICE i ON c.CUS_CODE = i.CUS_CODE
JOIN LINE l ON i.INV_NUMBER = l.INV_NUMBER
JOIN PRODUCT p ON l.P_CODE = p.P_CODE
WHERE p.P_DESCRIPT LIKE '%cloth%'
   OR p.P_DESCRIPT LIKE '%pipe%';

-- 9) List the difference between each customer’s balance and the average balance.
SELECT 
    CUS_CODE,
    CUS_BALANCE,
    (SELECT AVG(CUS_BALANCE) FROM CUSTOMER) AS Avg_Balance,
    CUS_BALANCE - (SELECT AVG(CUS_BALANCE) FROM CUSTOMER) AS Balance_Difference
FROM CUSTOMER
ORDER BY CUS_CODE;

-- 10) Find the vendor with the highest total sales amount.
SELECT 
    v.V_NAME,
    SUM(l.LINE_UNITS * l.LINE_PRICE) AS TotalSalesAmount
FROM LINE l
JOIN PRODUCT p ON p.P_CODE = l.P_CODE
JOIN VENDOR v ON v.V_CODE = p.V_CODE
GROUP BY v.V_CODE, v.V_NAME
ORDER BY TotalSalesAmount DESC
LIMIT 1;
