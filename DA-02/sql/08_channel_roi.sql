CREATE OR REPLACE TABLE customer360.channel_roi AS
WITH a AS (
  SELECT channel,
    SUM(first_touch) AS rev_first,
    SUM(last_touch)  AS rev_last,
    SUM(linear)      AS rev_linear,
    SUM(time_decay)  AS rev_decay,
    SUM(1 / touch_count) AS conversions_linear
  FROM customer360.attribution
  GROUP BY channel
),
s AS (
  SELECT channel, SUM(spend) AS spend
  FROM customer360.ad_spend
  GROUP BY channel
),
j AS (
  SELECT a.*, IFNULL(s.spend, 0) AS spend
  FROM a LEFT JOIN s USING (channel)
)
SELECT
  channel,
  ROUND(spend) AS spend,
  ROUND(rev_first)  AS rev_first,
  ROUND(rev_last)   AS rev_last,
  ROUND(rev_linear) AS rev_linear,
  ROUND(rev_decay)  AS rev_decay,
  ROUND(SAFE_DIVIDE(rev_first  - spend, spend), 2) AS roi_first,
  ROUND(SAFE_DIVIDE(rev_last   - spend, spend), 2) AS roi_last,
  ROUND(SAFE_DIVIDE(rev_linear - spend, spend), 2) AS roi_linear,
  ROUND(SAFE_DIVIDE(rev_decay  - spend, spend), 2) AS roi_decay,
  ROUND(SAFE_DIVIDE(spend, conversions_linear), 2) AS cpa_linear
FROM j
ORDER BY rev_linear DESC;
