-- Test 1: all four attribution models equal total order revenue
SELECT
  ROUND(SUM(first_touch), 2) AS first_touch_total,
  ROUND(SUM(last_touch), 2)  AS last_touch_total,
  ROUND(SUM(linear), 2)      AS linear_total,
  ROUND(SUM(time_decay), 2)  AS time_decay_total,
  (SELECT ROUND(SUM(revenue), 2) FROM customer360.orders
    WHERE order_id IN (SELECT order_id FROM customer360.touchpoints)) AS orders_total,
  (SELECT COUNT(*) FROM customer360.orders
    WHERE order_id NOT IN (SELECT order_id FROM customer360.touchpoints)) AS orders_without_touchpoints
FROM customer360.attribution;

-- Test 2: every buyer has a CRM record
SELECT COUNT(DISTINCT o.user_pseudo_id) AS buyers,
       COUNTIF(c.customer_id IS NULL) AS buyers_without_crm
FROM (SELECT DISTINCT user_pseudo_id FROM customer360.orders) o
LEFT JOIN customer360.crm_customers c USING (user_pseudo_id);

-- Test 3: no duplicate orders
SELECT COUNT(*) AS orders, COUNT(DISTINCT order_id) AS distinct_orders
FROM customer360.orders;
