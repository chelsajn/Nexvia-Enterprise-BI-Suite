-- Run each query separately and save results as CSV into /data
-- 1) attribution_by_channel.csv
SELECT channel, 'First touch' AS model, ROUND(SUM(first_touch)) AS revenue FROM customer360.attribution GROUP BY channel
UNION ALL
SELECT channel, 'Last touch', ROUND(SUM(last_touch)) FROM customer360.attribution GROUP BY channel
UNION ALL
SELECT channel, 'Linear', ROUND(SUM(linear)) FROM customer360.attribution GROUP BY channel
UNION ALL
SELECT channel, 'Time decay', ROUND(SUM(time_decay)) FROM customer360.attribution GROUP BY channel;

-- 2) channel_roi.csv
SELECT * FROM customer360.channel_roi;

-- 3) rfm_segments.csv
SELECT segment, COUNT(*) AS customers,
       ROUND(AVG(lifetime_value), 2) AS avg_ltv,
       ROUND(SUM(lifetime_value)) AS total_revenue
FROM customer360.customer_profile
GROUP BY segment;
