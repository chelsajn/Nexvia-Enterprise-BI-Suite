# DA-02: Customer 360 and Marketing Attribution Platform

Combines website sessions, a CRM and ad spend into one customer view, and shows which marketing channels bring revenue under four attribution models.

## Architecture
(docs/architecture.png)
GA4 public sample (BigQuery) -> SQL transformations (sessions, orders, touchpoints) -> attribution models -> ROI and CPA by channel -> Tableau dashboard. Synthetic CRM and ad spend join in through user ID and channel.

## Tech stack
BigQuery (SQL), Tableau Public

## Data
- GA4 Obfuscated Sample E-commerce (BigQuery public dataset), Nov 2020 to Jan 2021, about 355K sessions
- Synthetic CRM (3,702 customers, one per buyer), generated in SQL from the user ID
- Synthetic ad spend, built from real daily session counts times an assumed cost per session

## What I built
- **Sessions:** one row per session with its channel, read from the source and medium parameters in the GA4 events (channels: Direct, Organic Search, Referral, Other, Paid Search, Email)
- **Orders:** one row per transaction, deduplicated by transaction_id, orders, $308,200 revenue)
- **Identity resolution:** links anonymous sessions to CRM customers through user_pseudo_id
- **Touchpoints:** every session a buyer had before purchasing
- **Four attribution models:** first touch, last touch, linear, time decay (7-day half-life)
- **Campaign ROI and cost per acquisition** by channel
- **RFM scores and lifetime value** with six customer segments
- **Tableau dashboard** with recommendations on where to move budget

## Key findings
- The model changes the answer. Organic Search gets $130K under first touch but $99K under last touch. Referral gets $120K under first touch and $166K under last touch.
- Referral: spend $12.6K, ROI 8.5x to 12.2x, cost per acquisition $6.10
- Email: best ROI (11.9x to 20.5x) but only 197 sessions, so it cannot scale much
- Paid Search: spend $13.8K, revenue only $3.0K to $5.5K, ROI between -60% and -79%, cost per acquisition $261.55. Break-even is about $0.39 to $0.72 per session, against the $1.80 assumed
- 66% of repeat users (31,342 of 47,364) touched more than one channel, so attribution choice matters
- At Risk customers are the biggest segment by revenue (878 customers, $103K). Champions have the highest average value ($143)

## Tests
- All four attribution models total $308,200, equal to total order revenue, with 0 orders missing touchpoints
- Segment totals add up to 3,702 customers and $308,200, confirming the CRM join covers every buyer
- Screenshots are in /screenshots

## Limitations and assumptions
- The CRM and ad spend are synthetic. Cost per session is an assumption (Paid Search $1.80, Email $0.40, Referral $0.15, others $0). ROI figures show the method, not real Google Merchandise Store economics.
- The Referral and Email ROI depend most on the assumed costs, but their ranking above Paid Search holds across all four models.
- The "Other" channel (33K sessions) is the dataset's masked source label and is kept as its own channel.
- Recency is measured as of 31 Jan 2021, the end of the data.
- dbt and Segment were not used because of the time limit. The transformations are SQL scripts in /sql, numbered in run order, and map onto the dbt models in the brief (sessions, orders, customer profile). Attribution is done in SQL.

## Setup
1. Create a BigQuery project and a dataset called customer360 in the US location
2. Run the scripts in /sql in order (01 to 09)
3. Export the three CSVs in /data and open them in Tableau

## Next steps
Move the SQL into dbt with tests, use real ad platform exports, add Segment event data, and test lower-cost Paid Search.
