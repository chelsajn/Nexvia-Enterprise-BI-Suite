Reflection

I built this project end to end: restoring AdventureWorks2022, designing the star schema, writing the SQL load procedure with a load log, scheduling it with SQL Agent, building the Power BI model, writing the DAX measures, and creating the executive, drill-through and operations pages. I also set up row-level security for three regions and wrote the test checks that compare my warehouse against the source data.

The hardest part was getting the numbers to tie out. My first validation queries failed because I ran them against the wrong database, and my date table started too late for the HR data, so I had to rebuild it. Fixing these taught me to make every SQL script safe to re-run and to reconcile totals before building any visuals.

I learned how a clean star schema makes DAX much simpler, how relationships decide what a slicer can filter, and why testing the data matters more than polishing the dashboard.

With more time I would add incremental loading, a region mapping for purchasing and HR data so security could cover them, and move the refresh to Power BI Service.
