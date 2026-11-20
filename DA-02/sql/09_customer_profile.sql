-- Recency is measured as of 2021-01-31, the end of the dataset
CREATE OR REPLACE TABLE customer360.customer_profile AS
WITH o AS (
  SELECT
    c.customer_id, c.country, c.signup_date,
    COUNT(*) AS frequency,
    SUM(ord.revenue) AS monetary,
    MAX(DATE(ord.order_ts)) AS last_order_date,
    DATE_DIFF(DATE '2021-01-31', MAX(DATE(ord.order_ts)), DAY) AS recency_days
  FROM customer360.crm_customers c
  JOIN customer360.orders ord USING (user_pseudo_id)
  GROUP BY c.customer_id, c.country, c.signup_date
),
sc AS (
  SELECT *,
    6 - NTILE(5) OVER (ORDER BY recency_days) AS r_score,
    NTILE(5) OVER (ORDER BY frequency, monetary) AS f_score,
    NTILE(5) OVER (ORDER BY monetary) AS m_score
  FROM o
)
SELECT *,
  monetary AS lifetime_value,
  CASE
    WHEN r_score >= 4 AND f_score >= 4 THEN 'Champions'
    WHEN r_score >= 3 AND f_score >= 3 THEN 'Loyal'
    WHEN r_score >= 4 THEN 'New or Recent'
    WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk'
    WHEN r_score <= 2 THEN 'Lost'
    ELSE 'Needs Attention'
  END AS segment
FROM sc;
