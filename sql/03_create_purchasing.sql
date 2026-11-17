USE AdventureWorks2022;
GO
DROP TABLE IF EXISTS dw.DimVendor;
DROP TABLE IF EXISTS dw.FactPurchasing;
GO
SELECT BusinessEntityID AS VendorID, Name AS VendorName,
       CreditRating, PreferredVendorStatus, ActiveFlag
INTO dw.DimVendor
FROM Purchasing.Vendor;

SELECT d.PurchaseOrderID, d.PurchaseOrderDetailID,
       CAST(h.OrderDate AS date) AS OrderDate,
       CAST(h.ShipDate AS date) AS ShipDate,
       CAST(d.DueDate AS date) AS DueDate,
       h.VendorID, d.ProductID,
       d.OrderQty, d.ReceivedQty, d.RejectedQty,
       d.LineTotal AS PurchaseAmount
INTO dw.FactPurchasing
FROM Purchasing.PurchaseOrderDetail d
JOIN Purchasing.PurchaseOrderHeader h ON h.PurchaseOrderID = d.PurchaseOrderID;