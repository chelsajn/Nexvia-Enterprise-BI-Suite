CREATE OR REPLACE TABLE customer360.crm_customers AS
WITH b AS (
  SELECT user_pseudo_id, MIN(session_ts) AS first_session_ts
  FROM customer360.sessions
  WHERE user_pseudo_id IN (SELECT user_pseudo_id FROM customer360.orders)
  GROUP BY user_pseudo_id
),
h AS (
  SELECT *, MOD(ABS(FARM_FINGERPRINT(user_pseudo_id)), 100) AS r FROM b
)
SELECT
  CONCAT('C', LPAD(CAST(ROW_NUMBER() OVER (ORDER BY user_pseudo_id) AS STRING), 6, '0')) AS customer_id,
  user_pseudo_id,
  CONCAT('customer', CAST(MOD(ABS(FARM_FINGERPRINT(user_pseudo_id)), 1000000) AS STRING), '@example.com') AS email,
  CASE
    WHEN r < 55 THEN 'United States'
    WHEN r < 63 THEN 'Canada'
    WHEN r < 71 THEN 'India'
    WHEN r < 77 THEN 'United Kingdom'
    WHEN r < 81 THEN 'Australia'
    ELSE 'Other'
  END AS country,
  DATE_SUB(DATE(first_session_ts), INTERVAL CAST(MOD(ABS(FARM_FINGERPRINT(CONCAT(user_pseudo_id, 's'))), 31) AS INT64) DAY) AS signup_date
FROM h;
