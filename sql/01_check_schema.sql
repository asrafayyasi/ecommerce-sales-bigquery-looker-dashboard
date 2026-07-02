-- ============================================================
-- 01_check_schema.sql
-- Project: E-Commerce Sales Performance Dashboard
-- Purpose: Check table schemas and basic row counts in raw layer
-- Platform: Google BigQuery
-- ============================================================

-- Check column names and data types from raw tables
SELECT
  table_name,
  column_name,
  data_type
FROM `asraf-project-501103.ecommerce_raw.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name IN (
  'customers',
  'orders',
  'order_items',
  'products',
  'payments'
)
ORDER BY table_name, ordinal_position;

-- Check total rows in each raw table
SELECT 'customers' AS table_name, COUNT(*) AS total_rows
FROM `asraf-project-501103.ecommerce_raw.customers`

UNION ALL

SELECT 'orders' AS table_name, COUNT(*) AS total_rows
FROM `asraf-project-501103.ecommerce_raw.orders`

UNION ALL

SELECT 'order_items' AS table_name, COUNT(*) AS total_rows
FROM `asraf-project-501103.ecommerce_raw.order_items`

UNION ALL

SELECT 'products' AS table_name, COUNT(*) AS total_rows
FROM `asraf-project-501103.ecommerce_raw.products`

UNION ALL

SELECT 'payments' AS table_name, COUNT(*) AS total_rows
FROM `asraf-project-501103.ecommerce_raw.payments`;

-- Check order date range
SELECT
  MIN(DATE(order_purchase_timestamp)) AS min_order_date,
  MAX(DATE(order_purchase_timestamp)) AS max_order_date
FROM `asraf-project-501103.ecommerce_raw.orders`;
