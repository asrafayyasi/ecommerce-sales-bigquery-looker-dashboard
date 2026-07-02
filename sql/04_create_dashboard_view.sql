-- ============================================================
-- 04_create_dashboard_view.sql
-- Project: E-Commerce Sales Performance Dashboard
-- Purpose: Create main Looker Studio dashboard view
-- Platform: Google BigQuery
-- ============================================================

-- Main dashboard view.
-- This view is designed to keep dashboard filters interactive in Looker Studio.
-- Recommended dashboard filters:
-- - order_purchase_date
-- - order_status
-- - customer_state
-- - product_category_name
-- - payment_types

CREATE OR REPLACE VIEW `asraf-project-501103.ecommerce_mart.vw_sales_dashboard` AS
SELECT
  order_id,
  customer_id,
  customer_city,
  customer_state,

  order_status,
  order_purchase_date,
  order_purchase_month,
  delivery_days,
  delivery_delay_days,
  delivery_status,

  product_id,
  seller_id,
  product_category_name,

  price,
  shipping_charges,
  total_item_value,

  payment_types,
  total_payment_value,
  total_installments
FROM `asraf-project-501103.ecommerce_mart.sales_order_detail`;

-- Optional view for delivered orders only.
-- Use this only if the dashboard should focus exclusively on delivered orders.

CREATE OR REPLACE VIEW `asraf-project-501103.ecommerce_mart.vw_sales_dashboard_delivered` AS
SELECT *
FROM `asraf-project-501103.ecommerce_mart.vw_sales_dashboard`
WHERE order_status = 'delivered';

-- Quick check for dashboard view
SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT order_id) AS total_orders,
  COUNT(DISTINCT customer_id) AS total_customers,
  MIN(order_purchase_date) AS min_order_date,
  MAX(order_purchase_date) AS max_order_date
FROM `asraf-project-501103.ecommerce_mart.vw_sales_dashboard`;
