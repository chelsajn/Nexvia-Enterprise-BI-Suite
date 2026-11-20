-- Cost per session is an assumption: Paid Search 1.80, Email 0.40, Referral 0.15
CREATE OR REPLACE TABLE customer360.ad_spend AS
SELECT
  DATE(session_ts) AS date,
  channel,
  COUNT(*) AS clicks,
  ROUND(COUNT(*) * CASE channel
      WHEN 'Paid Search' THEN 1.80
      WHEN 'Email'       THEN 0.40
      WHEN 'Referral'    THEN 0.15
  END, 2) AS spend
FROM customer360.sessions
WHERE channel IN ('Paid Search', 'Email', 'Referral')
GROUP BY date, channel;
