CREATE OR REPLACE TABLE customer360.touchpoints AS
SELECT
  o.order_id, o.revenue, o.order_ts,
  s.session_key, s.channel, s.session_ts,
  ROW_NUMBER() OVER (PARTITION BY o.order_id ORDER BY s.session_ts) AS touch_no,
  COUNT(*) OVER (PARTITION BY o.order_id) AS touch_count
FROM customer360.orders o
JOIN customer360.sessions s
  ON s.user_pseudo_id = o.user_pseudo_id
 AND s.session_ts <= o.order_ts;
