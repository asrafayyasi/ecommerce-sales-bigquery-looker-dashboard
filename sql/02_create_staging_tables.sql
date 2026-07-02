-- ============================================================
-- 02_create_staging_tables.sql
-- Project: E-Commerce Sales Performance Dashboard
-- Purpose: Clean and standardize raw tables into staging layer
-- Platform: Google BigQuery
-- ============================================================

-- ------------------------------------------------------------
-- 1. Customers Clean
-- ------------------------------------------------------------
CREATE OR REPLACE TABLE `asraf-project-501103.ecommerce_staging.customers_clean` AS
SELECT
  customer_id,
  customer_zip_code_prefix,
  LOWER(TRIM(customer_city)) AS customer_city,
  UPPER(TRIM(customer_state)) AS customer_state
FROM `asraf-project-501103.ecommerce_raw.customers`
WHERE customer_id IS NOT NULL;

-- ------------------------------------------------------------
-- 2. Orders Clean
-- ------------------------------------------------------------
CREATE OR REPLACE TABLE `asraf-project-501103.ecommerce_staging.orders_clean` AS
SELECT
  order_id,
  customer_id,
  LOWER(TRIM(order_status)) AS order_status,

  order_purchase_timestamp,
  DATE(order_purchase_timestamp) AS order_purchase_date,
  DATE_TRUNC(DATE(order_purchase_timestamp), MONTH) AS order_purchase_month,

  order_approved_at,
  order_delivered_timestamp,
  order_estimated_delivery_date,

  DATE_DIFF(DATE(order_delivered_timestamp), DATE(order_purchase_timestamp), DAY) AS delivery_days,

  DATE_DIFF(
    DATE(order_delivered_timestamp),
    order_estimated_delivery_date,
    DAY
  ) AS delivery_delay_days,

  CASE
    WHEN order_delivered_timestamp IS NULL THEN 'not_delivered'
    WHEN DATE(order_delivered_timestamp) <= order_estimated_delivery_date THEN 'on_time'
    ELSE 'late'
  END AS delivery_status
FROM `asraf-project-501103.ecommerce_raw.orders`
WHERE order_id IS NOT NULL;

-- ------------------------------------------------------------
-- 3. Order Items Clean
-- ------------------------------------------------------------
CREATE OR REPLACE TABLE `asraf-project-501103.ecommerce_staging.order_items_clean` AS
SELECT
  order_id,
  product_id,
  seller_id,
  COALESCE(price, 0) AS price,
  COALESCE(shipping_charges, 0) AS shipping_charges,
  COALESCE(price, 0) + COALESCE(shipping_charges, 0) AS total_item_value
FROM `asraf-project-501103.ecommerce_raw.order_items`
WHERE order_id IS NOT NULL;

-- ------------------------------------------------------------
-- 4. Payments Clean
-- ------------------------------------------------------------
CREATE OR REPLACE TABLE `asraf-project-501103.ecommerce_staging.payments_clean` AS
SELECT
  order_id,
  payment_sequential,
  LOWER(TRIM(payment_type)) AS payment_type,
  COALESCE(payment_installments, 0) AS payment_installments,
  COALESCE(payment_value, 0) AS payment_value
FROM `asraf-project-501103.ecommerce_raw.payments`
WHERE order_id IS NOT NULL;

-- ------------------------------------------------------------
-- 5. Products Clean
-- ------------------------------------------------------------
CREATE OR REPLACE TABLE `asraf-project-501103.ecommerce_staging.products_clean` AS
SELECT
  product_id,
  LOWER(TRIM(product_category_name)) AS product_category_name,
  COALESCE(product_weight_g, 0) AS product_weight_g,
  COALESCE(product_length_cm, 0) AS product_length_cm,
  COALESCE(product_height_cm, 0) AS product_height_cm,
  COALESCE(product_width_cm, 0) AS product_width_cm,

  COALESCE(product_length_cm, 0)
  * COALESCE(product_height_cm, 0)
  * COALESCE(product_width_cm, 0) AS product_volume_cm3
FROM `asraf-project-501103.ecommerce_raw.products`
WHERE product_id IS NOT NULL;

-- ------------------------------------------------------------
-- 6. Row Count Validation for Staging Tables
-- ------------------------------------------------------------
SELECT 'customers_clean' AS table_name, COUNT(*) AS total_rows
FROM `asraf-project-501103.ecommerce_staging.customers_clean`

UNION ALL

SELECT 'orders_clean' AS table_name, COUNT(*) AS total_rows
FROM `asraf-project-501103.ecommerce_staging.orders_clean`

UNION ALL

SELECT 'order_items_clean' AS table_name, COUNT(*) AS total_rows
FROM `asraf-project-501103.ecommerce_staging.order_items_clean`

UNION ALL

SELECT 'products_clean' AS table_name, COUNT(*) AS total_rows
FROM `asraf-project-501103.ecommerce_staging.products_clean`

UNION ALL

SELECT 'payments_clean' AS table_name, COUNT(*) AS total_rows
FROM `asraf-project-501103.ecommerce_staging.payments_clean`;

-- ------------------------------------------------------------
-- 7. Null Check for Key Columns
-- ------------------------------------------------------------
SELECT
  COUNTIF(order_id IS NULL) AS null_order_id,
  COUNTIF(customer_id IS NULL) AS null_customer_id,
  COUNTIF(order_purchase_timestamp IS NULL) AS null_purchase_timestamp,
  COUNTIF(order_status IS NULL) AS null_order_status
FROM `asraf-project-501103.ecommerce_staging.orders_clean`;

SELECT
  COUNTIF(order_id IS NULL) AS null_order_id,
  COUNTIF(product_id IS NULL) AS null_product_id,
  COUNTIF(price IS NULL) AS null_price,
  COUNTIF(shipping_charges IS NULL) AS null_shipping_charges
FROM `asraf-project-501103.ecommerce_staging.order_items_clean`;
