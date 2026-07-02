-- ============================================================
-- 05_validation_queries.sql
-- Project: E-Commerce Sales Performance Dashboard
-- Purpose: Validate Looker Studio dashboard numbers using BigQuery
-- Platform: Google BigQuery
-- ============================================================

-- ------------------------------------------------------------
-- 1. Validate Main KPI Cards
-- Expected dashboard cards:
-- - Total Revenue
-- - Total Orders
-- - Total Customers
-- - Average Order Value
-- - Average Delivery Days
-- ------------------------------------------------------------
SELECT
  ROUND(SUM(total_item_value), 2) AS total_revenue,
  COUNT(DISTINCT order_id) AS total_orders,
  COUNT(DISTINCT customer_id) AS total_customers,
  ROUND(SAFE_DIVIDE(SUM(total_item_value), COUNT(DISTINCT order_id)), 2) AS avg_order_value,
  ROUND(AVG(delivery_days), 2) AS avg_delivery_days
FROM `asraf-project-501103.ecommerce_mart.vw_sales_dashboard`;

-- ------------------------------------------------------------
-- 2. Validate Monthly Revenue Trend
-- ------------------------------------------------------------
SELECT
  order_purchase_month,
  ROUND(SUM(total_item_value), 2) AS total_revenue
FROM `asraf-project-501103.ecommerce_mart.vw_sales_dashboard`
GROUP BY order_purchase_month
ORDER BY order_purchase_month;

-- ------------------------------------------------------------
-- 3. Validate Top 10 Product Categories by Revenue
-- ------------------------------------------------------------
SELECT
  product_category_name,
  ROUND(SUM(total_item_value), 2) AS total_revenue
FROM `asraf-project-501103.ecommerce_mart.vw_sales_dashboard`
GROUP BY product_category_name
ORDER BY total_revenue DESC
LIMIT 10;

-- ------------------------------------------------------------
-- 4. Validate Top 10 Customer States by Revenue
-- ------------------------------------------------------------
SELECT
  customer_state,
  ROUND(SUM(total_item_value), 2) AS total_revenue
FROM `asraf-project-501103.ecommerce_mart.vw_sales_dashboard`
GROUP BY customer_state
ORDER BY total_revenue DESC
LIMIT 10;

-- ------------------------------------------------------------
-- 5. Validate Payment Type Distribution
-- ------------------------------------------------------------
SELECT
  payment_types,
  COUNT(DISTINCT order_id) AS total_orders
FROM `asraf-project-501103.ecommerce_mart.vw_sales_dashboard`
GROUP BY payment_types
ORDER BY total_orders DESC;

-- ------------------------------------------------------------
-- 6. Validate Delivery Status Distribution
-- ------------------------------------------------------------
SELECT
  delivery_status,
  COUNT(DISTINCT order_id) AS total_orders
FROM `asraf-project-501103.ecommerce_mart.vw_sales_dashboard`
GROUP BY delivery_status
ORDER BY total_orders DESC;

-- ------------------------------------------------------------
-- 7. Validate Top 10 Cities by Revenue
-- ------------------------------------------------------------
SELECT
  customer_city,
  customer_state,
  ROUND(SUM(total_item_value), 2) AS total_revenue,
  COUNT(DISTINCT order_id) AS total_orders,
  COUNT(DISTINCT customer_id) AS total_customers
FROM `asraf-project-501103.ecommerce_mart.vw_sales_dashboard`
GROUP BY
  customer_city,
  customer_state
ORDER BY total_revenue DESC
LIMIT 10;

-- ------------------------------------------------------------
-- 8. Validate Monthly AOV Trend
-- ------------------------------------------------------------
SELECT
  order_purchase_month,
  ROUND(SAFE_DIVIDE(SUM(total_item_value), COUNT(DISTINCT order_id)), 2) AS avg_order_value
FROM `asraf-project-501103.ecommerce_mart.vw_sales_dashboard`
GROUP BY order_purchase_month
ORDER BY order_purchase_month;

-- ------------------------------------------------------------
-- 9. Validate Date Range
-- ------------------------------------------------------------
SELECT
  MIN(order_purchase_date) AS min_order_date,
  MAX(order_purchase_date) AS max_order_date
FROM `asraf-project-501103.ecommerce_mart.vw_sales_dashboard`;

-- ------------------------------------------------------------
-- 10. Validate Order Status Distribution
-- ------------------------------------------------------------
SELECT
  order_status,
  COUNT(DISTINCT order_id) AS total_orders,
  ROUND(SUM(total_item_value), 2) AS total_revenue
FROM `asraf-project-501103.ecommerce_mart.vw_sales_dashboard`
GROUP BY order_status
ORDER BY total_orders DESC;
