USE AdventureWorks2022;
GO
DROP TABLE IF EXISTS dw.DimEmployee;
DROP TABLE IF EXISTS dw.FactEmployee;
GO
SELECT e.BusinessEntityID AS EmployeeID,
       p.FirstName + ' ' + p.LastName AS EmployeeName,
       e.JobTitle, dep.Name AS Department, dep.GroupName AS DepartmentGroup,
       e.HireDate, e.CurrentFlag
INTO dw.DimEmployee
FROM HumanResources.Employee e
JOIN Person.Person p ON p.BusinessEntityID = e.BusinessEntityID
JOIN HumanResources.EmployeeDepartmentHistory h
     ON h.BusinessEntityID = e.BusinessEntityID AND h.EndDate IS NULL
JOIN HumanResources.Department dep ON dep.DepartmentID = h.DepartmentID;

SELECT e.BusinessEntityID AS EmployeeID,
       e.HireDate, e.VacationHours, e.SickLeaveHours, e.CurrentFlag
INTO dw.FactEmployee
FROM HumanResources.Employee e;