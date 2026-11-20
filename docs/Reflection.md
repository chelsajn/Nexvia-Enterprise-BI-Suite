# Reflection

I built this project end to end in BigQuery: session and order tables, identity resolution to a synthetic CRM, four attribution models, ROI and cost per acquisition, RFM segments and a Tableau dashboard.

The main problem was channel data. My first sessions table labelled almost every session Direct, because campaign details were not in the session start event. I found the source and medium on other events and rebuilt the table, which gave a realistic channel mix. I also hit a join failure when I loaded the CRM from a CSV, and fixed it by generating the CRM inside BigQuery.

I learned that the attribution model changes which channel looks best, and that reconciling totals across all four models catches mistakes early.

With more time I would use dbt with tests, real ad spend data and incremental loads.
