-- ============================================================
-- 03_create_mart_tables.sql
-- Project: E-Commerce Sales Performance Dashboard
-- Purpose: Create analytical mart tables for dashboard and insights
-- Platform: Google BigQuery
-- ============================================================

-- ------------------------------------------------------------
-- 1. Sales Order Detail
-- Main fact table for dashboard and analysis.
-- Combines orders, customers, order items, products, and payments.
-- ------------------------------------------------------------
CREATE OR REPLACE TABLE `asraf-project-501103.ecommerce_mart.sales_order_detail` AS
WITH payment_per_order AS (
  SELECT
    order_id,
    STRING_AGG(DISTINCT payment_type, ', ' ORDER BY payment_type) AS payment_types,
    SUM(payment_value) AS total_payment_value,
    SUM(payment_installments) AS total_installments
  FROM `asraf-project-501103.ecommerce_staging.payments_clean`
  GROUP BY order_id
)

SELECT
  o.order_id,
  o.customer_id,
  c.customer_city,
  c.customer_state,

  o.order_status,
  o.order_purchase_timestamp,
  o.order_purchase_date,
  o.order_purchase_month,
  o.order_approved_at,
  o.order_delivered_timestamp,
  o.order_estimated_delivery_date,
  o.delivery_days,
  o.delivery_delay_days,
  o.delivery_status,

  oi.product_id,
  oi.seller_id,
  p.product_category_name,
  p.product_weight_g,
  p.product_volume_cm3,

  oi.price,
  oi.shipping_charges,
  oi.total_item_value,

  pay.payment_types,
  pay.total_payment_value,
  pay.total_installments

FROM `asraf-project-501103.ecommerce_staging.orders_clean` AS o
LEFT JOIN `asraf-project-501103.ecommerce_staging.customers_clean` AS c
  ON o.customer_id = c.customer_id
LEFT JOIN `asraf-project-501103.ecommerce_staging.order_items_clean` AS oi
  ON o.order_id = oi.order_id
LEFT JOIN `asraf-project-501103.ecommerce_staging.products_clean` AS p
  ON oi.product_id = p.product_id
LEFT JOIN payment_per_order AS pay
  ON o.order_id = pay.order_id;

-- ------------------------------------------------------------
-- 2. Monthly Sales Summary
-- Monthly revenue, orders, customers, products, and AOV.
-- ------------------------------------------------------------
CREATE OR REPLACE TABLE `asraf-project-501103.ecommerce_mart.monthly_sales_summary` AS
SELECT
  order_purchase_month,

  COUNT(DISTINCT order_id) AS total_orders,
  COUNT(DISTINCT customer_id) AS total_customers,
  COUNT(DISTINCT product_id) AS total_products_sold,
  COUNT(DISTINCT seller_id) AS total_sellers,

  SUM(price) AS total_product_revenue,
  SUM(shipping_charges) AS total_shipping_revenue,
  SUM(total_item_value) AS total_revenue,

  AVG(total_item_value) AS avg_item_value,
  SAFE_DIVIDE(SUM(total_item_value), COUNT(DISTINCT order_id)) AS avg_order_value

FROM `asraf-project-501103.ecommerce_mart.sales_order_detail`
GROUP BY order_purchase_month;

-- ------------------------------------------------------------
-- 3. Monthly Sales Growth
-- Month-over-month revenue and order growth.
-- ------------------------------------------------------------
CREATE OR REPLACE TABLE `asraf-project-501103.ecommerce_mart.monthly_sales_growth` AS
WITH monthly AS (
  SELECT
    order_purchase_month,
    total_orders,
    total_customers,
    total_revenue
  FROM `asraf-project-501103.ecommerce_mart.monthly_sales_summary`
),

growth AS (
  SELECT
    order_purchase_month,
    total_orders,
    total_customers,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY order_purchase_month) AS previous_month_revenue,
    LAG(total_orders) OVER (ORDER BY order_purchase_month) AS previous_month_orders
  FROM monthly
)

SELECT
  order_purchase_month,
  total_orders,
  total_customers,
  total_revenue,
  previous_month_revenue,

  ROUND(
    SAFE_DIVIDE(total_revenue - previous_month_revenue, previous_month_revenue) * 100,
    2
  ) AS revenue_growth_percentage,

  previous_month_orders,

  ROUND(
    SAFE_DIVIDE(total_orders - previous_month_orders, previous_month_orders) * 100,
    2
  ) AS order_growth_percentage

FROM growth;

-- ------------------------------------------------------------
-- 4. Product Performance
-- Product-level revenue and order performance.
-- ------------------------------------------------------------
CREATE OR REPLACE TABLE `asraf-project-501103.ecommerce_mart.product_performance` AS
SELECT
  product_category_name,
  product_id,

  COUNT(DISTINCT order_id) AS total_orders,
  COUNT(*) AS total_items_sold,
  COUNT(DISTINCT customer_id) AS total_customers,

  SUM(price) AS product_revenue,
  SUM(shipping_charges) AS shipping_revenue,
  SUM(total_item_value) AS total_revenue,

  AVG(price) AS avg_product_price,
  AVG(shipping_charges) AS avg_shipping_charges

FROM `asraf-project-501103.ecommerce_mart.sales_order_detail`
GROUP BY
  product_category_name,
  product_id;

-- ------------------------------------------------------------
-- 5. Category Performance
-- Category-level revenue and ranking.
-- ------------------------------------------------------------
CREATE OR REPLACE TABLE `asraf-project-501103.ecommerce_mart.category_performance` AS
SELECT
  product_category_name,

  COUNT(DISTINCT order_id) AS total_orders,
  COUNT(DISTINCT product_id) AS total_products,
  COUNT(*) AS total_items_sold,
  COUNT(DISTINCT customer_id) AS total_customers,

  SUM(price) AS product_revenue,
  SUM(shipping_charges) AS shipping_revenue,
  SUM(total_item_value) AS total_revenue,

  AVG(price) AS avg_product_price,
  AVG(shipping_charges) AS avg_shipping_charges,

  RANK() OVER (ORDER BY SUM(total_item_value) DESC) AS revenue_rank

FROM `asraf-project-501103.ecommerce_mart.sales_order_detail`
GROUP BY product_category_name;

-- ------------------------------------------------------------
-- 6. Payment Summary
-- Payment type distribution and payment value summary.
-- ------------------------------------------------------------
CREATE OR REPLACE TABLE `asraf-project-501103.ecommerce_mart.payment_summary` AS
SELECT
  payment_type,

  COUNT(DISTINCT order_id) AS total_orders,
  COUNT(*) AS total_payment_records,
  SUM(payment_value) AS total_payment_value,
  AVG(payment_value) AS avg_payment_value,
  AVG(payment_installments) AS avg_installments

FROM `asraf-project-501103.ecommerce_staging.payments_clean`
GROUP BY payment_type
ORDER BY total_payment_value DESC;

-- ------------------------------------------------------------
-- 7. Delivery Performance
-- Delivery status and delivery duration summary.
-- ------------------------------------------------------------
CREATE OR REPLACE TABLE `asraf-project-501103.ecommerce_mart.delivery_performance` AS
SELECT
  delivery_status,

  COUNT(DISTINCT order_id) AS total_orders,
  AVG(delivery_days) AS avg_delivery_days,
  AVG(delivery_delay_days) AS avg_delivery_delay_days,

  MIN(delivery_days) AS min_delivery_days,
  MAX(delivery_days) AS max_delivery_days

FROM `asraf-project-501103.ecommerce_staging.orders_clean`
GROUP BY delivery_status
ORDER BY total_orders DESC;

-- ------------------------------------------------------------
-- 8. Customer Location Summary
-- Revenue, orders, and customers by city and state.
-- ------------------------------------------------------------
CREATE OR REPLACE TABLE `asraf-project-501103.ecommerce_mart.customer_location_summary` AS
SELECT
  customer_state,
  customer_city,

  COUNT(DISTINCT customer_id) AS total_customers,
  COUNT(DISTINCT order_id) AS total_orders,
  SUM(total_item_value) AS total_revenue,

  SAFE_DIVIDE(SUM(total_item_value), COUNT(DISTINCT order_id)) AS avg_order_value

FROM `asraf-project-501103.ecommerce_mart.sales_order_detail`
GROUP BY
  customer_state,
  customer_city
ORDER BY total_revenue DESC;

-- ------------------------------------------------------------
-- 9. Mart Table Check
-- ------------------------------------------------------------
SELECT
  table_name,
  row_count
FROM `asraf-project-501103.ecommerce_mart.__TABLES__`
ORDER BY table_name;
