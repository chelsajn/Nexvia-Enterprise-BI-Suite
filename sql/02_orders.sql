CREATE OR REPLACE TABLE customer360.orders AS
SELECT
  ecommerce.transaction_id AS order_id,
  ARRAY_AGG(user_pseudo_id ORDER BY event_timestamp LIMIT 1)[OFFSET(0)] AS user_pseudo_id,
  MIN(TIMESTAMP_MICROS(event_timestamp)) AS order_ts,
  MAX(ecommerce.purchase_revenue) AS revenue
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase'
  AND ecommerce.transaction_id IS NOT NULL
  AND ecommerce.transaction_id != '(not set)'
GROUP BY order_id
HAVING MAX(ecommerce.purchase_revenue) > 0;
