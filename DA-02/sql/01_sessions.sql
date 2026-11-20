CREATE OR REPLACE TABLE customer360.sessions AS
WITH e AS (
  SELECT
    user_pseudo_id,
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS ga_session_id,
    event_timestamp,
    (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'source') AS source,
    (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'medium') AS medium,
    (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'campaign') AS campaign
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
),
s AS (
  SELECT
    user_pseudo_id,
    ga_session_id,
    MIN(TIMESTAMP_MICROS(event_timestamp)) AS session_ts,
    ARRAY_AGG(source   IGNORE NULLS ORDER BY event_timestamp LIMIT 1)[SAFE_OFFSET(0)] AS source,
    ARRAY_AGG(medium   IGNORE NULLS ORDER BY event_timestamp LIMIT 1)[SAFE_OFFSET(0)] AS medium,
    ARRAY_AGG(campaign IGNORE NULLS ORDER BY event_timestamp LIMIT 1)[SAFE_OFFSET(0)] AS campaign
  FROM e
  WHERE ga_session_id IS NOT NULL
  GROUP BY user_pseudo_id, ga_session_id
)
SELECT
  user_pseudo_id,
  CONCAT(user_pseudo_id, '-', CAST(ga_session_id AS STRING)) AS session_key,
  session_ts,
  source,
  medium,
  campaign,
  CASE
    WHEN medium IN ('cpc', 'ppc', 'paidsearch') THEN 'Paid Search'
    WHEN medium = 'organic' THEN 'Organic Search'
    WHEN medium = 'referral' THEN 'Referral'
    WHEN medium = 'email' THEN 'Email'
    WHEN medium IN ('social', 'paid_social') THEN 'Social'
    WHEN medium IS NULL OR medium IN ('(none)', '(not set)', '(direct)') THEN 'Direct'
    ELSE 'Other'
  END AS channel
FROM s;
