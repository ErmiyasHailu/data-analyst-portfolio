/* =========================================================
   E-COMMERCE SALES ANALYSIS — SQL PORTFOLIO PROJECT
   Goal: Validate data and answer business questions using SQL.
   Output will be used for Tableau dashboard.
   ========================================================= */


/* ===============================
   1. TABLE SETUP
   =============================== */

DROP TABLE IF EXISTS ecommerce_raw;

CREATE TABLE ecommerce_raw (
    order_date    DATE,
    product_name  TEXT,
    category      TEXT,
    region        TEXT,
    quantity      INT,
    sales         NUMERIC(12,2),
    profit        NUMERIC(12,2)
);


/* ===============================
   2. DATA VALIDATION
   =============================== */

-- Business question: How many rows were imported?
SELECT COUNT(*) AS total_rows
FROM ecommerce_raw;


-- Business question: Preview data
SELECT *
FROM ecommerce_raw
LIMIT 10;


-- Business question: Check missing values
SELECT
  COUNT(*) AS total_rows,
  COUNT(order_date)   AS order_date_not_null,
  COUNT(product_name) AS product_not_null,
  COUNT(category)     AS category_not_null,
  COUNT(region)       AS region_not_null,
  COUNT(quantity)     AS quantity_not_null,
  COUNT(sales)        AS sales_not_null,
  COUNT(profit)       AS profit_not_null
FROM ecommerce_raw;


-- Business question: Invalid sales values
SELECT COUNT(*)
FROM ecommerce_raw
WHERE sales <= 0;


-- Business question: Invalid quantity values
SELECT COUNT(*)
FROM ecommerce_raw
WHERE quantity <= 0;


-- Business question: Rows with negative profit
SELECT COUNT(*)
FROM ecommerce_raw
WHERE profit < 0;


-- Business question: Check duplicate rows
SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT
    order_date || product_name || category ||
    region || quantity || sales || profit
  ) AS distinct_rows
FROM ecommerce_raw;



/* ===============================
   3. KPI SUMMARY
   =============================== */

-- Business question: Overall performance
SELECT
  ROUND(SUM(sales),2)  AS total_sales,
  ROUND(SUM(profit),2) AS total_profit,
  SUM(quantity)        AS total_units,
  ROUND(100.0 * SUM(profit) / NULLIF(SUM(sales),0),2)
    AS profit_margin_percent
FROM ecommerce_raw;



/* ===============================
   4. REGIONAL PERFORMANCE
   =============================== */

-- Business question: Sales by region
SELECT
  region,
  ROUND(SUM(sales),2) AS total_sales
FROM ecommerce_raw
GROUP BY region
ORDER BY total_sales DESC;


-- Business question: Profit and margin by region
SELECT
  region,
  ROUND(SUM(sales),2)  AS total_sales,
  ROUND(SUM(profit),2) AS total_profit,
  ROUND(
    100.0 * SUM(profit) / NULLIF(SUM(sales),0),2
  ) AS margin_percent
FROM ecommerce_raw
GROUP BY region
ORDER BY total_profit DESC;


-- Business question: Sales share by region
SELECT
  region,
  ROUND(SUM(sales),2) AS total_sales,
  ROUND(
    100.0 * SUM(sales) /
    (SELECT SUM(sales) FROM ecommerce_raw),
    2
  ) AS sales_percent
FROM ecommerce_raw
GROUP BY region
ORDER BY total_sales DESC;



/* ===============================
   5. CATEGORY PERFORMANCE
   =============================== */

-- Business question: Sales and profit by category
SELECT
  category,
  ROUND(SUM(sales),2)  AS total_sales,
  ROUND(SUM(profit),2) AS total_profit,
  ROUND(
    100.0 * SUM(profit) / NULLIF(SUM(sales),0),2
  ) AS margin_percent
FROM ecommerce_raw
GROUP BY category
ORDER BY total_sales DESC;


-- Business question: Units sold by category
SELECT
  category,
  SUM(quantity) AS total_units
FROM ecommerce_raw
GROUP BY category
ORDER BY total_units DESC;



/* ===============================
   6. TIME TREND ANALYSIS
   =============================== */

-- Business question: Monthly sales trend
SELECT
  DATE_TRUNC('month', order_date) AS month,
  ROUND(SUM(sales),2)  AS total_sales,
  ROUND(SUM(profit),2) AS total_profit
FROM ecommerce_raw
GROUP BY month
ORDER BY month;


-- Business question: Top months by sales
SELECT
  DATE_TRUNC('month', order_date) AS month,
  ROUND(SUM(sales),2) AS total_sales
FROM ecommerce_raw
GROUP BY month
ORDER BY total_sales DESC
LIMIT 6;



/* ===============================
   7. PRODUCT PERFORMANCE
   =============================== */

-- Business question: Top products by profit
SELECT
  product_name,
  ROUND(SUM(sales),2)  AS total_sales,
  ROUND(SUM(profit),2) AS total_profit,
  ROUND(
    100.0 * SUM(profit) / NULLIF(SUM(sales),0),2
  ) AS margin_percent
FROM ecommerce_raw
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;


-- Business question: Top products by sales
SELECT
  product_name,
  ROUND(SUM(sales),2)  AS total_sales,
  ROUND(SUM(profit),2) AS total_profit
FROM ecommerce_raw
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;


-- Business question: Loss-making products
SELECT
  product_name,
  ROUND(SUM(profit),2) AS total_profit
FROM ecommerce_raw
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY total_profit;



