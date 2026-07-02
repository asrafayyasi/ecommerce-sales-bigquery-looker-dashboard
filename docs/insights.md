# Key Insights

This document summarizes the main business insights from the E-Commerce Sales Performance Dashboard built using Google BigQuery and Looker Studio.

## 1. Overall Sales Performance

The dashboard recorded total revenue of **1.49B** from **89,316 orders**, with an average order value of **16,715.01** and an average delivery time of **13.36 days**.

This indicates that the business processed a large number of transactions with a relatively high average value per order. Average Order Value is especially useful for understanding whether revenue growth is driven by higher transaction volume or by higher spending per order.

## 2. Revenue Is Highly Concentrated in the Toys Category

The `toys` category generated approximately **1.18B** in revenue, contributing around **79.56%** of total revenue.

This shows that overall sales performance is strongly driven by one dominant product category. While this category is a major revenue driver, the business may also face concentration risk if performance in this category declines.

## 3. Top Categories Dominate Revenue Contribution

The top two categories, `toys` and `garden_tools`, together contributed almost **90%** of total revenue.

This indicates that revenue contribution is not evenly distributed across product categories. Lower-performing categories such as `health_beauty`, `watches_gifts`, and `computers_accessories` may require further analysis to identify growth opportunities.

## 4. SP, RJ, and MG Are the Strongest Revenue-Generating States

The highest revenue contributions came from:

| State | Revenue |
|---|---:|
| SP | 554.33M |
| RJ | 214.25M |
| MG | 207.35M |

Together, these three states contributed more than **65%** of total revenue.

This suggests that sales performance is geographically concentrated in a few key regions. These states represent the strongest customer markets and should be prioritized for marketing and logistics optimization.

## 5. Sao Paulo and Rio de Janeiro Are the Main City-Level Markets

At the city level, the highest revenue came from:

| City | State | Revenue |
|---|---|---:|
| sao paulo | SP | 183.63M |
| rio de janeiro | RJ | 118.25M |
| belo horizonte | MG | 54.27M |

Sao Paulo and Rio de Janeiro together contributed more than **20%** of total revenue.

These cities can be considered priority markets for targeted campaigns, faster delivery coverage, and customer retention initiatives.

## 6. Morrinhos Shows Unusually High Revenue with Low Order Volume

Morrinhos generated approximately **17.59M** in revenue from only **26 orders**. This creates an extremely high average order value compared to other cities.

This pattern may indicate high-value transactions, bulk purchases, premium products, or potential data anomalies. Further transaction-level investigation is recommended.

## 7. Credit Card Is the Dominant Payment Method

Payment method distribution shows that credit card is the most frequently used payment type:

| Payment Type | Total Orders | Share |
|---|---:|---:|
| credit_card | 65,814 | 73.69% |
| wallet | 17,302 | 19.37% |
| voucher | 4,911 | 5.50% |
| debit_card | 1,289 | 1.44% |

Credit card and wallet together represent more than **93%** of total payment behavior. This indicates that checkout experience should prioritize these two payment methods.

## 8. Delivery Performance Is Generally Strong

Delivery status distribution shows:

| Delivery Status | Total Orders | Share |
|---|---:|---:|
| on_time | 81,822 | 91.61% |
| late | 5,605 | 6.28% |
| not_delivered | 1,889 | 2.11% |

More than **91%** of orders were delivered on time. However, late and not-delivered orders still account for **8.39%** of total orders and should be monitored to improve customer satisfaction.

## 9. Revenue Peaked in November 2017

Monthly revenue reached its highest point in **November 2017**, with approximately **241.58M** in revenue. Revenue then declined to **115.23M** in December 2017, representing a significant month-over-month drop.

This pattern may indicate a seasonal effect, promotional campaign, or major sales event that drove a temporary spike in revenue.

## 10. September 2018 Should Be Treated Carefully

September 2018 recorded only **471.48** in revenue, which is extremely low compared to previous months.

This likely indicates incomplete data or a partial month. For trend interpretation, September 2018 should be excluded or clearly labeled as incomplete.
