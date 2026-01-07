CREATE DATABASE IF NOT EXISTS ecommerce;
use ecommerce;
show tables;
select * from olist;
-- 1. Weekday vs Weekend Payment Statistics
SELECT
    Weekday_weekend AS day_type,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(payment_value) AS total_payment_value,
    AVG(payment_value) AS avg_payment_value
FROM olist
GROUP BY Weekday_weekend;


-- 2. Number of Orders with Review Score = 5 and Payment Type = Credit Card
SELECT
    COUNT(DISTINCT order_id) AS total_orders_creditcard_5star
FROM olist
WHERE review_score = 5
  AND payment_type = 'credit_card';


-- 3. Average Number of Days Taken for Delivery for Pet Shop
SELECT 
    AVG(
        DATEDIFF(
            STR_TO_DATE(order_delivered_customer_date, '%d-%m-%Y %H:%i'),
            STR_TO_DATE(order_purchase_timestamp, '%d-%m-%Y %H:%i')
        )
    ) AS AvgDeliveryDays_PetShop
FROM olist
WHERE LOWER(product_category_name) = 'pet_shop'
  AND order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL;
  

-- 4. Average Price and Payment Values from Customers of São Paulo City
SELECT
    AVG(price) AS avg_price_sao_paulo,
    AVG(payment_value) AS avg_payment_value_sao_paulo
FROM olist
WHERE customer_city = 'sao paulo';


-- 5. Relationship Between Shipping Days vs Review Scores
SELECT 
    review_score,
    AVG(
        DATEDIFF(
            STR_TO_DATE(order_delivered_customer_date, '%d-%m-%Y %H:%i'),
            STR_TO_DATE(order_purchase_timestamp, '%d-%m-%Y %H:%i')
        )
    ) AS AvgShippingDays
FROM olist
WHERE order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL
GROUP BY review_score
ORDER BY review_score;

-- 6. Orders by Payment Type
SELECT payment_type, COUNT(*) AS total_orders
FROM olist
GROUP BY payment_type;

-- 7. Top 10 Product Categories by Revenue
SELECT product_category_name,
       SUM(price) AS total_revenue
FROM olist
GROUP BY product_category_name
ORDER BY total_revenue DESC
LIMIT 10;

-- 8.Top 10 Sellers by Sales Amount
SELECT seller_id,
       SUM(price) AS total_sales
FROM olist
GROUP BY seller_id
ORDER BY total_sales DESC
LIMIT 10;

-- 9. Year-over-Year (YoY) Order Growth 
WITH yearly_orders AS (
    SELECT 
        YEAR(STR_TO_DATE(order_purchase_timestamp, '%d-%m-%Y %H:%i')) AS Year,
        COUNT(order_id) AS total_orders
    FROM olist
    GROUP BY YEAR(STR_TO_DATE(order_purchase_timestamp, '%d-%m-%Y %H:%i'))
)

SELECT
    a.Year,
    a.total_orders,
    COALESCE(
        ((a.total_orders - b.total_orders) / b.total_orders) * 100,
        0
    ) AS yoy_growth_percentage
FROM yearly_orders a
LEFT JOIN yearly_orders b
    ON a.Year = b.Year + 1
ORDER BY a.Year;
      
      
      
-- 10 .Cancelled Orders Count
SELECT
    COUNT(*) AS cancelled_orders
FROM olist
WHERE order_status = 'canceled';

-- 11 . Orders Trend by Month
SELECT
    Month,
    COUNT(order_id) AS total_orders
FROM olist
GROUP BY Month
ORDER BY Month;

-- 12 . Payment Type Share (Percentage Contribution)
SELECT
    payment_type,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM olist) AS percentage_share
FROM olist
GROUP BY payment_type;