# Data Dictionary

This document describes the main fields used in the E-Commerce Sales Performance Dashboard project. The dashboard was built from the final BigQuery view `ecommerce_mart.vw_sales_dashboard`, which combines order, customer, product, payment, and delivery information.

## Main Dashboard View

**View name:** `asraf-project-501103.ecommerce_mart.vw_sales_dashboard`

| Column | Data Type | Description |
|---|---|---|
| `order_id` | STRING | Unique identifier for each order. Used to calculate total orders. |
| `customer_id` | STRING | Customer identifier available in the dataset. Used to calculate total customers. |
| `customer_city` | STRING | City where the customer is located. Used for city-level revenue analysis. |
| `customer_state` | STRING | State where the customer is located. Used for regional revenue analysis. |
| `order_status` | STRING | Current status of the order, such as delivered, shipped, canceled, or processing. |
| `order_purchase_date` | DATE | Date when the order was purchased. Used as the main date filter in the dashboard. |
| `order_purchase_month` | DATE | Monthly period derived from `order_purchase_date`. Used for monthly trend analysis. |
| `delivery_days` | INTEGER | Number of days between order purchase and actual delivery. |
| `delivery_delay_days` | INTEGER | Difference between actual delivery date and estimated delivery date. Positive value indicates late delivery. |
| `delivery_status` | STRING | Delivery classification: `on_time`, `late`, or `not_delivered`. |
| `product_id` | STRING | Unique identifier for each product. |
| `seller_id` | STRING | Seller identifier associated with each order item. |
| `product_category_name` | STRING | Product category name. Used for category performance analysis. |
| `price` | FLOAT | Product item price. |
| `shipping_charges` | FLOAT | Shipping charge associated with the item. |
| `total_item_value` | FLOAT | Total item value calculated as `price + shipping_charges`. Used as the main revenue metric. |
| `payment_types` | STRING | Payment method used in an order. Multiple payment types may be combined in one order. |
| `total_payment_value` | FLOAT | Total payment value per order based on payment records. |
| `total_installments` | INTEGER | Total number of installments associated with payment records. |

## Key Metrics

| Metric | Formula | Description |
|---|---|---|
| Total Revenue | `SUM(total_item_value)` | Total sales value generated from all order items. |
| Total Orders | `COUNT_DISTINCT(order_id)` | Number of unique orders. |
| Total Customers | `COUNT_DISTINCT(customer_id)` | Number of unique customer IDs available in the dataset. |
| Average Order Value | `SUM(total_item_value) / COUNT_DISTINCT(order_id)` | Average revenue generated per order. |
| Average Delivery Days | `AVG(delivery_days)` | Average number of days required to deliver an order. |
| On-Time Delivery Rate | `on_time orders / total orders` | Percentage of orders delivered on or before the estimated delivery date. |

## Notes

- The dashboard uses `order_purchase_date` as the main date range dimension.
- `total_item_value` is used as the revenue metric because it combines product price and shipping charges.
- `customer_id` appears to be unique at the order level in this dataset; therefore, repeat customer behavior is not analyzed in this project.
- September 2018 shows very low revenue compared to previous months, indicating that the data for that month may be incomplete or represents a partial month.
