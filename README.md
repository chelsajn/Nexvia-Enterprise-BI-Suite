# Nexvia-Enterprise-BI-Suite - Project 1
# Enterprise BI Suite for a Multi-Region Company

One reporting system combining sales, purchasing (supply chain), finance and HR data from AdventureWorks2022, with region-based row-level security.

## Architecture
(docs/architecture.png)

## Tech stack
SQL Server 2025 Developer, SQL Server Agent, Power BI Desktop, Power Query, DAX

## What I built
- Star schema in a `dw` schema: FactSales, FactPurchasing, FactEmployee and dimensions for date, product, customer, territory, vendor and employee
- Stored procedure `dw.usp_LoadWarehouse` that rebuilds every table and logs row counts to `dw.LoadLog`
- SQL Agent job that runs the load nightly at 2 AM
- Power BI model with 9 relationships and a dedicated measures table
- DAX measures: Total Sales, Margin %, YTD, YoY growth, 3-month rolling average, Rejection Rate, Headcount, Average Tenure
- Executive Summary page, Sales Detail drill-through page and an Operations page
- Row-level security with three roles: North America, Europe, Pacific

## Setup
1. Install SQL Server and restore AdventureWorks2022.bak
2. Run the scripts in /sql in order (01 to 06)
3. Run `EXEC dw.usp_LoadWarehouse;` to build the warehouse
4. Open `powerbi/nexvia_bi_suite.pbix` and point the data source to your server

## Testing
Reconciliation checks compare the warehouse against the source tables (row counts, totals, orphan keys). Results are in `screenshots`. Power BI totals tie to the SQL totals ($109,846,381 in sales).

## Design decisions and limitations
- Azure Data Factory was not available, so data movement uses a stored procedure and a SQL Agent job (allowed by the brief). It does a full reload nightly, not an incremental load.
- RLS applies to sales data. AdventureWorks purchasing and HR tables have no region field.
- Margin is about 8.5% because AdventureWorks standard costs are high relative to selling prices.
- Average tenure is measured as of 31 Dec 2014, the end of the dataset.

## Next steps
Incremental loading, region mapping for purchasing and HR data, refresh alerts.
