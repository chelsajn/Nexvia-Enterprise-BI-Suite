CREATE OR REPLACE TABLE customer360.attribution AS
WITH t AS (
  SELECT *,
    POW(0.5, TIMESTAMP_DIFF(order_ts, session_ts, HOUR) / 24.0 / 7) AS w
  FROM customer360.touchpoints
),
n AS (
  SELECT *, w / SUM(w) OVER (PARTITION BY order_id) AS w_norm FROM t
)
SELECT
  order_id, session_key, channel, touch_no, touch_count, revenue,
  IF(touch_no = 1, revenue, 0)           AS first_touch,
  IF(touch_no = touch_count, revenue, 0) AS last_touch,
  revenue / touch_count                  AS linear,
  revenue * w_norm                       AS time_decay
FROM n;
