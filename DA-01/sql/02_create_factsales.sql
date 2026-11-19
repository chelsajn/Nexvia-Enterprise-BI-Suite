USE AdventureWorks2022;
GO
SELECT d.SalesOrderID, d.SalesOrderDetailID,
       CAST(h.OrderDate AS date) AS OrderDate,
       d.ProductID, h.CustomerID, h.TerritoryID,
       d.OrderQty, d.UnitPrice, d.UnitPriceDiscount,
       d.LineTotal AS SalesAmount,
       d.OrderQty * p.StandardCost AS CostAmount
INTO dw.FactSales
FROM Sales.SalesOrderDetail d
JOIN Sales.SalesOrderHeader h ON h.SalesOrderID = d.SalesOrderID
JOIN Production.Product p ON p.ProductID = d.ProductID;