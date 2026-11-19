USE AdventureWorks2022;
GO
CREATE SCHEMA dw;
GO

-- Territory
SELECT TerritoryID, Name AS Territory, CountryRegionCode, [Group] AS Region
INTO dw.DimTerritory
FROM Sales.SalesTerritory;

-- Product
SELECT p.ProductID, p.Name AS ProductName,
       ISNULL(sc.Name,'Unknown') AS Subcategory,
       ISNULL(c.Name,'Unknown') AS Category,
       p.StandardCost, p.ListPrice
INTO dw.DimProduct
FROM Production.Product p
LEFT JOIN Production.ProductSubcategory sc ON sc.ProductSubcategoryID = p.ProductSubcategoryID
LEFT JOIN Production.ProductCategory c ON c.ProductCategoryID = sc.ProductCategoryID;

-- Customer
SELECT c.CustomerID,
       COALESCE(s.Name, p.FirstName + ' ' + p.LastName, 'Unknown') AS CustomerName,
       CASE WHEN c.StoreID IS NULL THEN 'Individual' ELSE 'Store' END AS CustomerType
INTO dw.DimCustomer
FROM Sales.Customer c
LEFT JOIN Person.Person p ON p.BusinessEntityID = c.PersonID
LEFT JOIN Sales.Store s ON s.BusinessEntityID = c.StoreID;

-- Date
WITH d AS (
    SELECT CAST('2011-01-01' AS date) AS [Date]
    UNION ALL
    SELECT DATEADD(day,1,[Date]) FROM d WHERE [Date] < '2014-12-31'
)
SELECT [Date], YEAR([Date]) AS [Year], DATEPART(quarter,[Date]) AS [Quarter],
       MONTH([Date]) AS MonthNumber, DATENAME(month,[Date]) AS MonthName,
       FORMAT([Date],'yyyy-MM') AS YearMonth
INTO dw.DimDate
FROM d
OPTION (MAXRECURSION 0);