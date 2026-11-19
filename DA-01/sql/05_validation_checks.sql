USE AdventureWorks2022;
GO

-- Sales reconciliation
SELECT COUNT(*) AS fact_rows FROM dw.FactSales;
SELECT COUNT(*) AS source_rows FROM Sales.SalesOrderDetail;
SELECT SUM(SalesAmount) AS fact_total FROM dw.FactSales;
SELECT SUM(LineTotal) AS source_total FROM Sales.SalesOrderDetail;

-- Purchasing reconciliation
SELECT
  (SELECT COUNT(*) FROM dw.FactPurchasing) AS fact_rows,
  (SELECT COUNT(*) FROM Purchasing.PurchaseOrderDetail) AS source_rows,
  (SELECT SUM(PurchaseAmount) FROM dw.FactPurchasing) AS fact_total,
  (SELECT SUM(LineTotal) FROM Purchasing.PurchaseOrderDetail) AS source_total;

-- HR reconciliation
SELECT
  (SELECT COUNT(*) FROM dw.DimEmployee) AS dim_employee_rows,
  (SELECT COUNT(*) FROM dw.FactEmployee) AS fact_employee_rows,
  (SELECT COUNT(*) FROM HumanResources.Employee) AS source_rows;

-- Null and orphan key checks (all should be 0)
SELECT
  (SELECT COUNT(*) FROM dw.FactSales WHERE TerritoryID IS NULL) AS sales_null_territory,
  (SELECT COUNT(*) FROM dw.FactSales f LEFT JOIN dw.DimProduct p ON p.ProductID = f.ProductID WHERE p.ProductID IS NULL) AS sales_orphan_products,
  (SELECT COUNT(*) FROM dw.FactSales f LEFT JOIN dw.DimCustomer c ON c.CustomerID = f.CustomerID WHERE c.CustomerID IS NULL) AS sales_orphan_customers,
  (SELECT COUNT(*) FROM dw.FactPurchasing f LEFT JOIN dw.DimVendor v ON v.VendorID = f.VendorID WHERE v.VendorID IS NULL) AS purchasing_orphan_vendors;