-- =========================================================
-- CUSTOMER PERSONALITY ANALYTICS
-- PostgreSQL Data Preparation & Analytics Pipeline
-- =========================================================


-- =========================================================
-- 1. RAW DATA TABLE
-- =========================================================

CREATE TABLE customer_personality_raw (
    id TEXT,
    year_birth TEXT,
    education TEXT,
    marital_status TEXT,
    income TEXT,
    kidhome TEXT,
    teenhome TEXT,
    dt_customer TEXT,
    recency TEXT,
    mnt_wines TEXT,
    mnt_fruits TEXT,
    mnt_meat_products TEXT,
    mnt_fish_products TEXT,
    mnt_sweet_products TEXT,
    mnt_gold_prods TEXT,
    num_deals_purchases TEXT,
    num_web_purchases TEXT,
    num_catalog_purchases TEXT,
    num_store_purchases TEXT,
    num_web_visits_month TEXT,
    accepted_cmp3 TEXT,
    accepted_cmp4 TEXT,
    accepted_cmp5 TEXT,
    accepted_cmp1 TEXT,
    accepted_cmp2 TEXT,
    complain TEXT,
    z_cost_contact TEXT,
    z_revenue TEXT,
    response TEXT
);


-- =========================================================
-- 2. DATA QUALITY PROFILING
-- =========================================================

-- Check total number of records
SELECT COUNT(*) AS total_rows
FROM customer_personality_raw;


-- Inspect column names and data types
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'customer_personality_raw'
ORDER BY ordinal_position;


-- Preview sample records
SELECT *
FROM customer_personality_raw
LIMIT 10;


-- Inspect records ordered by customer ID
SELECT *
FROM customer_personality_raw
ORDER BY id
LIMIT 10;


-- Check for duplicate customer IDs
SELECT 
    id,
    COUNT(*) AS occurrences
FROM customer_personality_raw
GROUP BY id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;


-- Check for missing income values
SELECT COUNT(*) AS empty_income
FROM customer_personality_raw
WHERE income IS NULL
   OR TRIM(income) = '';


-- Check for missing birth year values
SELECT COUNT(*) AS empty_year_birth
FROM customer_personality_raw
WHERE year_birth IS NULL
   OR TRIM(year_birth) = '';


-- Check field completeness for selected columns
SELECT
    COUNT(*) AS total_rows,
    COUNT(NULLIF(TRIM(id), '')) AS id_filled,
    COUNT(NULLIF(TRIM(year_birth), '')) AS year_birth_filled,
    COUNT(NULLIF(TRIM(education), '')) AS education_filled,
    COUNT(NULLIF(TRIM(marital_status), '')) AS marital_status_filled,
    COUNT(NULLIF(TRIM(income), '')) AS income_filled,
    COUNT(NULLIF(TRIM(kidhome), '')) AS kidhome_filled,
    COUNT(NULLIF(TRIM(teenhome), '')) AS teenhome_filled,
    COUNT(NULLIF(TRIM(dt_customer), '')) AS dt_customer_filled,
    COUNT(NULLIF(TRIM(recency), '')) AS recency_filled
FROM customer_personality_raw;


-- Profile education categories
SELECT 
    education,
    COUNT(*) AS customer_count
FROM customer_personality_raw
GROUP BY education
ORDER BY customer_count DESC;


-- Profile marital status categories
SELECT 
    marital_status,
    COUNT(*) AS customer_count
FROM customer_personality_raw
GROUP BY marital_status
ORDER BY customer_count DESC;


-- Profile income statistics
SELECT
    MIN(NULLIF(TRIM(income), '')::NUMERIC) AS min_income,
    MAX(NULLIF(TRIM(income), '')::NUMERIC) AS max_income,
    AVG(NULLIF(TRIM(income), '')::NUMERIC) AS avg_income
FROM customer_personality_raw;


-- Profile birth year range
SELECT
    MIN(NULLIF(TRIM(year_birth), '')::INTEGER) AS min_year_birth,
    MAX(NULLIF(TRIM(year_birth), '')::INTEGER) AS max_year_birth
FROM customer_personality_raw;


-- Profile recency statistics
SELECT
    MIN(NULLIF(TRIM(recency), '')::INTEGER) AS min_recency,
    MAX(NULLIF(TRIM(recency), '')::INTEGER) AS max_recency,
    AVG(NULLIF(TRIM(recency), '')::INTEGER) AS avg_recency
FROM customer_personality_raw;


-- Check campaign 1 response distribution
SELECT accepted_cmp1, COUNT(*)
FROM customer_personality_raw
GROUP BY accepted_cmp1
ORDER BY accepted_cmp1;


-- Inspect customer registration dates
SELECT dt_customer
FROM customer_personality_raw
LIMIT 20;


-- Identify suspicious income values
SELECT
    id,
    income
FROM customer_personality_raw
WHERE income IS NOT NULL
  AND TRIM(income) <> ''
ORDER BY income::NUMERIC DESC
LIMIT 20;


-- Identify invalid birth years
SELECT
    id,
    year_birth
FROM customer_personality_raw
WHERE year_birth::INTEGER < 1920
ORDER BY year_birth::INTEGER;


-- Identify unusual marital status values
SELECT
    id,
    marital_status
FROM customer_personality_raw
WHERE marital_status IN ('Alone', 'Absurd', 'YOLO');


-- Full field completeness profiling
SELECT
    COUNT(*) AS total_rows,

    COUNT(NULLIF(TRIM(id), '')) AS id_filled,
    COUNT(NULLIF(TRIM(year_birth), '')) AS year_birth_filled,
    COUNT(NULLIF(TRIM(education), '')) AS education_filled,
    COUNT(NULLIF(TRIM(marital_status), '')) AS marital_status_filled,
    COUNT(NULLIF(TRIM(income), '')) AS income_filled,
    COUNT(NULLIF(TRIM(kidhome), '')) AS kidhome_filled,
    COUNT(NULLIF(TRIM(teenhome), '')) AS teenhome_filled,
    COUNT(NULLIF(TRIM(dt_customer), '')) AS dt_customer_filled,
    COUNT(NULLIF(TRIM(recency), '')) AS recency_filled,

    COUNT(NULLIF(TRIM(mnt_wines), '')) AS mnt_wines_filled,
    COUNT(NULLIF(TRIM(mnt_fruits), '')) AS mnt_fruits_filled,
    COUNT(NULLIF(TRIM(mnt_meat_products), '')) AS mnt_meat_products_filled,
    COUNT(NULLIF(TRIM(mnt_fish_products), '')) AS mnt_fish_products_filled,
    COUNT(NULLIF(TRIM(mnt_sweet_products), '')) AS mnt_sweet_products_filled,
    COUNT(NULLIF(TRIM(mnt_gold_prods), '')) AS mnt_gold_prods_filled,

    COUNT(NULLIF(TRIM(num_deals_purchases), '')) AS num_deals_purchases_filled,
    COUNT(NULLIF(TRIM(num_web_purchases), '')) AS num_web_purchases_filled,
    COUNT(NULLIF(TRIM(num_catalog_purchases), '')) AS num_catalog_purchases_filled,
    COUNT(NULLIF(TRIM(num_store_purchases), '')) AS num_store_purchases_filled,
    COUNT(NULLIF(TRIM(num_web_visits_month), '')) AS num_web_visits_month_filled,

    COUNT(NULLIF(TRIM(accepted_cmp1), '')) AS accepted_cmp1_filled,
    COUNT(NULLIF(TRIM(accepted_cmp2), '')) AS accepted_cmp2_filled,
    COUNT(NULLIF(TRIM(accepted_cmp3), '')) AS accepted_cmp3_filled,
    COUNT(NULLIF(TRIM(accepted_cmp4), '')) AS accepted_cmp4_filled,
    COUNT(NULLIF(TRIM(accepted_cmp5), '')) AS accepted_cmp5_filled,

    COUNT(NULLIF(TRIM(complain), '')) AS complain_filled,
    COUNT(NULLIF(TRIM(z_cost_contact), '')) AS z_cost_contact_filled,
    COUNT(NULLIF(TRIM(z_revenue), '')) AS z_revenue_filled,
    COUNT(NULLIF(TRIM(response), '')) AS response_filled

FROM customer_personality_raw;


-- Check campaign acceptance distributions
SELECT
    accepted_cmp1,
    COUNT(*) AS customer_count
FROM customer_personality_raw
GROUP BY accepted_cmp1
ORDER BY accepted_cmp1;


SELECT
    accepted_cmp2,
    COUNT(*) AS customer_count
FROM customer_personality_raw
GROUP BY accepted_cmp2
ORDER BY accepted_cmp2;


-- Profile campaign and response indicators
SELECT 'accepted_cmp1' AS column_name, accepted_cmp1 AS value, COUNT(*) AS count
FROM customer_personality_raw
GROUP BY accepted_cmp1

UNION ALL

SELECT 'accepted_cmp2', accepted_cmp2, COUNT(*)
FROM customer_personality_raw
GROUP BY accepted_cmp2

UNION ALL

SELECT 'accepted_cmp3', accepted_cmp3, COUNT(*)
FROM customer_personality_raw
GROUP BY accepted_cmp3

UNION ALL

SELECT 'accepted_cmp4', accepted_cmp4, COUNT(*)
FROM customer_personality_raw
GROUP BY accepted_cmp4

UNION ALL

SELECT 'accepted_cmp5', accepted_cmp5, COUNT(*)
FROM customer_personality_raw
GROUP BY accepted_cmp5

UNION ALL

SELECT 'complain', complain, COUNT(*)
FROM customer_personality_raw
GROUP BY complain

UNION ALL

SELECT 'response', response, COUNT(*)
FROM customer_personality_raw
GROUP BY response

ORDER BY column_name, value;


-- Validate customer ID uniqueness
SELECT 
    id,
    COUNT(*) AS occurrences
FROM customer_personality_raw
GROUP BY id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;


-- Validate customer registration dates
SELECT
    COUNT(*) AS total_rows,
    COUNT(
        TO_DATE(TRIM(dt_customer), 'DD-MM-YYYY')
    ) AS valid_dates
FROM customer_personality_raw;

-- =========================================================
-- 3. DATA CLEANING
-- =========================================================

-- Create a cleaned table using appropriate data types
CREATE TABLE customer_personality_clean (
    id INTEGER,
    year_birth INTEGER,
    education VARCHAR(50),
    marital_status VARCHAR(50),
    income NUMERIC(12,2),
    kidhome INTEGER,
    teenhome INTEGER,
    dt_customer DATE,
    recency INTEGER,
    mnt_wines NUMERIC(12,2),
    mnt_fruits NUMERIC(12,2),
    mnt_meat_products NUMERIC(12,2),
    mnt_fish_products NUMERIC(12,2),
    mnt_sweet_products NUMERIC(12,2),
    mnt_gold_prods NUMERIC(12,2),
    num_deals_purchases INTEGER,
    num_web_purchases INTEGER,
    num_catalog_purchases INTEGER,
    num_store_purchases INTEGER,
    num_web_visits_month INTEGER,
    accepted_cmp1 INTEGER,
    accepted_cmp2 INTEGER,
    accepted_cmp3 INTEGER,
    accepted_cmp4 INTEGER,
    accepted_cmp5 INTEGER,
    complain INTEGER,
    z_cost_contact NUMERIC,
    z_revenue NUMERIC,
    response INTEGER
);


-- Insert cleaned and typed data
INSERT INTO customer_personality_clean (
    id,
    year_birth,
    education,
    marital_status,
    income,
    kidhome,
    teenhome,
    dt_customer,
    recency,
    mnt_wines,
    mnt_fruits,
    mnt_meat_products,
    mnt_fish_products,
    mnt_sweet_products,
    mnt_gold_prods,
    num_deals_purchases,
    num_web_purchases,
    num_catalog_purchases,
    num_store_purchases,
    num_web_visits_month,
    accepted_cmp1,
    accepted_cmp2,
    accepted_cmp3,
    accepted_cmp4,
    accepted_cmp5,
    complain,
    z_cost_contact,
    z_revenue,
    response
)
SELECT
    id::INTEGER,

    -- Invalid birth years are converted to NULL
    CASE
        WHEN year_birth::INTEGER < 1920 THEN NULL
        ELSE year_birth::INTEGER
    END,

    TRIM(education),

    -- Standardize marital status values
    CASE
        WHEN TRIM(marital_status) = 'Alone' THEN 'Single'
        WHEN TRIM(marital_status) IN ('Absurd', 'YOLO') THEN 'Unknown'
        ELSE TRIM(marital_status)
    END,

    -- Handle missing income and suspicious outlier
    CASE
        WHEN TRIM(income) = '' THEN NULL
        WHEN income::NUMERIC = 666666 THEN NULL
        ELSE income::NUMERIC
    END,

    kidhome::INTEGER,
    teenhome::INTEGER,

    -- Convert DD-MM-YYYY text into DATE
    TO_DATE(TRIM(dt_customer), 'DD-MM-YYYY'),

    recency::INTEGER,

    mnt_wines::NUMERIC,
    mnt_fruits::NUMERIC,
    mnt_meat_products::NUMERIC,
    mnt_fish_products::NUMERIC,
    mnt_sweet_products::NUMERIC,
    mnt_gold_prods::NUMERIC,

    num_deals_purchases::INTEGER,
    num_web_purchases::INTEGER,
    num_catalog_purchases::INTEGER,
    num_store_purchases::INTEGER,
    num_web_visits_month::INTEGER,

    accepted_cmp1::INTEGER,
    accepted_cmp2::INTEGER,
    accepted_cmp3::INTEGER,
    accepted_cmp4::INTEGER,
    accepted_cmp5::INTEGER,

    complain::INTEGER,

    z_cost_contact::NUMERIC,
    z_revenue::NUMERIC,

    response::INTEGER

FROM customer_personality_raw;


-- Validate cleaned table
SELECT COUNT(*) AS total_rows
FROM customer_personality_clean;


SELECT *
FROM customer_personality_clean
LIMIT 10;


-- =========================================================
-- 4. CLEAN TABLE VALIDATION
-- =========================================================

-- Confirm that customer count remained unchanged
SELECT COUNT(*) AS total_customers
FROM customer_personality_clean;


-- Confirm that the suspicious income value was removed
SELECT 
    COUNT(*) AS income_666666_count
FROM customer_personality_clean
WHERE income = 666666;


-- Check resulting missing income values
SELECT 
    COUNT(*) AS missing_income
FROM customer_personality_clean
WHERE income IS NULL;


-- Validate birth year cleaning
SELECT 
    COUNT(*) AS invalid_birth_years
FROM customer_personality_clean
WHERE year_birth IS NOT NULL
  AND year_birth < 1920;


-- Check missing birth years
SELECT 
    COUNT(*) AS missing_birth_year
FROM customer_personality_clean
WHERE year_birth IS NULL;


-- Validate standardized marital status
SELECT
    marital_status,
    COUNT(*) AS customer_count
FROM customer_personality_clean
GROUP BY marital_status
ORDER BY customer_count DESC;


-- Confirm that customer registration date is stored as DATE
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'customer_personality_clean'
  AND column_name = 'dt_customer';


-- =========================================================
-- 5. FEATURE ENGINEERING
-- =========================================================

-- Create the analysis view with derived customer-level features
CREATE OR REPLACE VIEW customer_personality_analysis AS

SELECT
    *,
    
    -- Customer Age
    CASE
        WHEN year_birth IS NOT NULL
        THEN 2014 - year_birth
        ELSE NULL
    END AS age,

    -- Family Size
    kidhome + teenhome + 1 AS family_size,

    -- Total Spending
    mnt_wines
    + mnt_fruits
    + mnt_meat_products
    + mnt_fish_products
    + mnt_sweet_products
    + mnt_gold_prods AS total_spend,

    -- Total Purchases
    num_web_purchases
    + num_catalog_purchases
    + num_store_purchases AS total_purchases,

    -- Total Campaigns Accepted
    accepted_cmp1
    + accepted_cmp2
    + accepted_cmp3
    + accepted_cmp4
    + accepted_cmp5 AS total_campaigns_accepted,

    -- Customer Tenure
    (
        (SELECT MAX(dt_customer)
         FROM customer_personality_clean)
        - dt_customer
    ) AS customer_tenure_days,

    -- Preferred Channel
    CASE
        WHEN num_web_purchases >= num_catalog_purchases
             AND num_web_purchases >= num_store_purchases
            THEN 'Web'

        WHEN num_catalog_purchases >= num_web_purchases
             AND num_catalog_purchases >= num_store_purchases
            THEN 'Catalog'

        ELSE 'Store'
    END AS preferred_channel

FROM customer_personality_clean;


-- Preview the analysis view
SELECT *
FROM customer_personality_analysis
LIMIT 10;


-- =========================================================
-- 6. FEATURE VALIDATION — AGE
-- =========================================================

SELECT
    MIN(age) AS min_age,
    MAX(age) AS max_age,
    ROUND(AVG(age), 2) AS avg_age,
    COUNT(*) AS total_customers,
    COUNT(age) AS customers_with_age,
    COUNT(*) - COUNT(age) AS missing_age
FROM customer_personality_analysis;


-- Identify potentially unrealistic ages
SELECT
    id,
    year_birth,
    age
FROM customer_personality_analysis
WHERE age < 18
   OR age > 100
ORDER BY age;


-- Identify customers with missing birth year and age
SELECT
    id,
    year_birth,
    age
FROM customer_personality_analysis
WHERE year_birth IS NULL;


-- =========================================================
-- 7. FEATURE VALIDATION — FAMILY SIZE
-- =========================================================

SELECT
    MIN(family_size) AS min_family_size,
    MAX(family_size) AS max_family_size,
    ROUND(AVG(family_size), 2) AS avg_family_size,
    COUNT(*) AS total_customers,
    COUNT(family_size) AS customers_with_family_size,
    COUNT(*) - COUNT(family_size) AS missing_family_size
FROM customer_personality_analysis;


-- Review Family Size distribution
SELECT
    family_size,
    COUNT(*) AS customer_count
FROM customer_personality_analysis
GROUP BY family_size
ORDER BY family_size;


-- Recalculate Family Size for validation
SELECT
    id,
    kidhome,
    teenhome,
    family_size,
    kidhome + teenhome + 1 AS calculated_family_size
FROM customer_personality_analysis
LIMIT 20;


-- Identify invalid Family Size values
SELECT
    id,
    kidhome,
    teenhome,
    family_size
FROM customer_personality_analysis
WHERE family_size < 1;


-- Validate Family Size calculation across all customers
SELECT COUNT(*) AS incorrect_family_size
FROM customer_personality_analysis
WHERE family_size <> (kidhome + teenhome + 1);


-- =========================================================
-- 8. FEATURE VALIDATION — TOTAL SPEND
-- =========================================================

SELECT
    MIN(total_spend) AS min_total_spend,
    MAX(total_spend) AS max_total_spend,
    ROUND(AVG(total_spend), 2) AS avg_total_spend,
    COUNT(*) AS total_customers,
    COUNT(total_spend) AS customers_with_total_spend,
    COUNT(*) - COUNT(total_spend) AS missing_total_spend
FROM customer_personality_analysis;


-- Review Total Spend distribution
SELECT
    CASE
        WHEN total_spend = 0 THEN '0'
        WHEN total_spend <= 500 THEN '1-500'
        WHEN total_spend <= 1000 THEN '501-1000'
        WHEN total_spend <= 2000 THEN '1001-2000'
        WHEN total_spend <= 5000 THEN '2001-5000'
        ELSE '5000+'
    END AS spend_range,
    COUNT(*) AS customer_count
FROM customer_personality_analysis
GROUP BY
    CASE
        WHEN total_spend = 0 THEN '0'
        WHEN total_spend <= 500 THEN '1-500'
        WHEN total_spend <= 1000 THEN '501-1000'
        WHEN total_spend <= 2000 THEN '1001-2000'
        WHEN total_spend <= 5000 THEN '2001-5000'
        ELSE '5000+'
    END
ORDER BY
    MIN(total_spend);


-- Recalculate Total Spend for validation
SELECT
    id,
    mnt_wines,
    mnt_fruits,
    mnt_meat_products,
    mnt_fish_products,
    mnt_sweet_products,
    mnt_gold_prods,
    total_spend,
    
    mnt_wines
    + mnt_fruits
    + mnt_meat_products
    + mnt_fish_products
    + mnt_sweet_products
    + mnt_gold_prods AS calculated_total_spend

FROM customer_personality_analysis
LIMIT 20;


-- Check for negative Total Spend values
SELECT
    id,
    total_spend
FROM customer_personality_analysis
WHERE total_spend < 0;


-- Validate Total Spend calculation across all customers
SELECT
    COUNT(*) AS incorrect_total_spend
FROM customer_personality_analysis
WHERE total_spend <> (
    mnt_wines
    + mnt_fruits
    + mnt_meat_products
    + mnt_fish_products
    + mnt_sweet_products
    + mnt_gold_prods
);

-- =========================================================
-- 9. FEATURE VALIDATION — TOTAL PURCHASES
-- =========================================================

-- Profile Total Purchases
SELECT
    MIN(total_purchases) AS min_total_purchases,
    MAX(total_purchases) AS max_total_purchases,
    ROUND(AVG(total_purchases), 2) AS avg_total_purchases,
    COUNT(*) AS total_customers,
    COUNT(total_purchases) AS customers_with_total_purchases,
    COUNT(*) - COUNT(total_purchases) AS missing_total_purchases
FROM customer_personality_analysis;


-- Review Total Purchases distribution
SELECT
    CASE
        WHEN total_purchases <= 5 THEN '1-5'
        WHEN total_purchases <= 10 THEN '6-10'
        WHEN total_purchases <= 20 THEN '11-20'
        WHEN total_purchases <= 30 THEN '21-30'
        ELSE '31+'
    END AS purchase_range,
    COUNT(*) AS customer_count
FROM customer_personality_analysis
GROUP BY
    CASE
        WHEN total_purchases <= 5 THEN '1-5'
        WHEN total_purchases <= 10 THEN '6-10'
        WHEN total_purchases <= 20 THEN '11-20'
        WHEN total_purchases <= 30 THEN '21-30'
        ELSE '31+'
    END
ORDER BY MIN(total_purchases);


-- Validate Total Purchases calculation
SELECT
    COUNT(*) AS incorrect_total_purchases
FROM customer_personality_analysis
WHERE total_purchases <> (
    num_web_purchases
    + num_catalog_purchases
    + num_store_purchases
);


-- Check for negative purchase values
SELECT
    id,
    total_purchases
FROM customer_personality_analysis
WHERE total_purchases < 0;


-- =========================================================
-- 10. FEATURE VALIDATION — TOTAL CAMPAIGNS ACCEPTED
-- =========================================================

SELECT
    MIN(total_campaigns_accepted) AS min_campaigns_accepted,
    MAX(total_campaigns_accepted) AS max_campaigns_accepted,
    ROUND(AVG(total_campaigns_accepted), 2) AS avg_campaigns_accepted,
    COUNT(*) AS total_customers,
    COUNT(total_campaigns_accepted) AS customers_with_value,
    COUNT(*) - COUNT(total_campaigns_accepted) AS missing_campaigns
FROM customer_personality_analysis;


-- Review campaign acceptance distribution
SELECT
    total_campaigns_accepted,
    COUNT(*) AS customer_count
FROM customer_personality_analysis
GROUP BY total_campaigns_accepted
ORDER BY total_campaigns_accepted;


-- Validate Total Campaigns Accepted calculation
SELECT
    COUNT(*) AS incorrect_campaign_count
FROM customer_personality_analysis
WHERE total_campaigns_accepted <> (
    accepted_cmp1
    + accepted_cmp2
    + accepted_cmp3
    + accepted_cmp4
    + accepted_cmp5
);


-- Check that campaign acceptance values are within the expected range
SELECT
    id,
    total_campaigns_accepted
FROM customer_personality_analysis
WHERE total_campaigns_accepted < 0
   OR total_campaigns_accepted > 5;


-- Calculate the percentage of customers who accepted at least one campaign
SELECT
    COUNT(*) FILTER (
        WHERE total_campaigns_accepted > 0
    ) AS customers_accepted_at_least_one,

    COUNT(*) AS total_customers,

    ROUND(
        100.0 *
        COUNT(*) FILTER (
            WHERE total_campaigns_accepted > 0
        ) / COUNT(*),
        2
    ) AS acceptance_rate_percent

FROM customer_personality_analysis;


-- =========================================================
-- 11. FEATURE VALIDATION — CUSTOMER TENURE
-- =========================================================

-- Identify the reference date range
SELECT
    MIN(dt_customer) AS earliest_customer_date,
    MAX(dt_customer) AS latest_customer_date
FROM customer_personality_clean;


-- Profile Customer Tenure
SELECT
    MIN(customer_tenure_days) AS min_tenure_days,
    MAX(customer_tenure_days) AS max_tenure_days,
    ROUND(AVG(customer_tenure_days), 2) AS avg_tenure_days,
    COUNT(*) AS total_customers,
    COUNT(customer_tenure_days) AS customers_with_tenure,
    COUNT(*) - COUNT(customer_tenure_days) AS missing_tenure
FROM customer_personality_analysis;


-- Check for negative tenure values
SELECT
    id,
    dt_customer,
    customer_tenure_days
FROM customer_personality_analysis
WHERE customer_tenure_days < 0;


-- Recalculate Customer Tenure for validation
SELECT
    id,
    dt_customer,
    customer_tenure_days,
    (
        (SELECT MAX(dt_customer)
         FROM customer_personality_clean)
        - dt_customer
    ) AS calculated_tenure
FROM customer_personality_analysis
LIMIT 20;


-- Validate Customer Tenure calculation across all customers
SELECT
    COUNT(*) AS incorrect_tenure
FROM customer_personality_analysis
WHERE customer_tenure_days <> (
    (SELECT MAX(dt_customer)
     FROM customer_personality_clean)
     - dt_customer
);


-- =========================================================
-- 12. FEATURE VALIDATION — PREFERRED CHANNEL
-- =========================================================

-- Review Preferred Channel distribution
SELECT
    preferred_channel,
    COUNT(*) AS customer_count
FROM customer_personality_analysis
GROUP BY preferred_channel
ORDER BY customer_count DESC;


-- Check distinct Preferred Channel values
SELECT DISTINCT preferred_channel
FROM customer_personality_analysis
ORDER BY preferred_channel;


-- Inspect channel classification for sample customers
SELECT
    id,
    num_web_purchases,
    num_catalog_purchases,
    num_store_purchases,
    preferred_channel
FROM customer_personality_analysis
ORDER BY id
LIMIT 20;


-- Validate the original Preferred Channel calculation
SELECT
    COUNT(*) AS incorrect_preferred_channel
FROM customer_personality_analysis
WHERE preferred_channel <> CASE
    WHEN num_web_purchases >= num_catalog_purchases
         AND num_web_purchases >= num_store_purchases
        THEN 'Web'

    WHEN num_catalog_purchases >= num_web_purchases
         AND num_catalog_purchases >= num_store_purchases
        THEN 'Catalog'

    ELSE 'Store'
END;


-- Identify customers with tied top channels
SELECT
    COUNT(*) AS tied_customers
FROM customer_personality_clean
WHERE
    (
        num_web_purchases = num_catalog_purchases
        AND num_web_purchases >= num_store_purchases
    )
    OR
    (
        num_web_purchases = num_store_purchases
        AND num_web_purchases >= num_catalog_purchases
    )
    OR
    (
        num_catalog_purchases = num_store_purchases
        AND num_catalog_purchases >= num_web_purchases
    );


-- Identify customers with no recorded purchases
SELECT
    COUNT(*) AS no_purchase_customers
FROM customer_personality_clean
WHERE num_web_purchases = 0
  AND num_catalog_purchases = 0
  AND num_store_purchases = 0;


-- =========================================================
-- 13. UPDATE PREFERRED CHANNEL LOGIC
-- =========================================================

-- Recreate the analysis view to explicitly classify:
-- No Purchases and Multi-Channel customers.

CREATE OR REPLACE VIEW customer_personality_analysis AS

SELECT
    *,

    -- Customer Age
    CASE
        WHEN year_birth IS NOT NULL
        THEN 2014 - year_birth
        ELSE NULL
    END AS age,

    -- Family Size
    kidhome + teenhome + 1 AS family_size,

    -- Total Spending
    mnt_wines
    + mnt_fruits
    + mnt_meat_products
    + mnt_fish_products
    + mnt_sweet_products
    + mnt_gold_prods AS total_spend,

    -- Total Purchases
    num_web_purchases
    + num_catalog_purchases
    + num_store_purchases AS total_purchases,

    -- Total Campaigns Accepted
    accepted_cmp1
    + accepted_cmp2
    + accepted_cmp3
    + accepted_cmp4
    + accepted_cmp5 AS total_campaigns_accepted,

    -- Customer Tenure
    (
        (SELECT MAX(dt_customer)
         FROM customer_personality_clean)
        - dt_customer
    ) AS customer_tenure_days,

    -- Preferred Channel
    CASE
        -- No purchases
        WHEN num_web_purchases = 0
             AND num_catalog_purchases = 0
             AND num_store_purchases = 0
            THEN 'No Purchases'

        -- Tie between top channels
        WHEN num_web_purchases = num_catalog_purchases
             AND num_web_purchases >= num_store_purchases
            THEN 'Multi-Channel'

        WHEN num_web_purchases = num_store_purchases
             AND num_web_purchases >= num_catalog_purchases
            THEN 'Multi-Channel'

        WHEN num_catalog_purchases = num_store_purchases
             AND num_catalog_purchases >= num_web_purchases
            THEN 'Multi-Channel'

        -- Clear channel preference
        WHEN num_web_purchases >= num_catalog_purchases
             AND num_web_purchases >= num_store_purchases
            THEN 'Web'

        WHEN num_catalog_purchases >= num_web_purchases
             AND num_catalog_purchases >= num_store_purchases
            THEN 'Catalog'

        ELSE 'Store'
    END AS preferred_channel

FROM customer_personality_clean;


-- =========================================================
-- 14. UPDATED PREFERRED CHANNEL VALIDATION
-- =========================================================

-- Review channel distribution after classification update
SELECT
    preferred_channel,
    COUNT(*) AS customer_count
FROM customer_personality_analysis
GROUP BY preferred_channel
ORDER BY customer_count DESC;


-- Confirm allowed channel categories
SELECT DISTINCT preferred_channel
FROM customer_personality_analysis
ORDER BY preferred_channel;


-- Count Multi-Channel customers
SELECT
    COUNT(*) AS multi_channel_customers
FROM customer_personality_analysis
WHERE preferred_channel = 'Multi-Channel';


-- Confirm No Purchases customers
SELECT
    COUNT(*) AS no_purchase_customers
FROM customer_personality_analysis
WHERE preferred_channel = 'No Purchases';


-- Validate Multi-Channel classification
SELECT
    COUNT(*) AS invalid_multi_channel
FROM customer_personality_analysis
WHERE preferred_channel = 'Multi-Channel'
  AND NOT (
      (
          num_web_purchases = num_catalog_purchases
          AND num_web_purchases >= num_store_purchases
      )
      OR
      (
          num_web_purchases = num_store_purchases
          AND num_web_purchases >= num_catalog_purchases
      )
      OR
      (
          num_catalog_purchases = num_store_purchases
          AND num_catalog_purchases >= num_web_purchases
      )
  );


-- =========================================================
-- 15. RFM ANALYSIS — PROFILING
-- =========================================================

SELECT
    MIN(recency) AS min_recency,
    MAX(recency) AS max_recency,
    ROUND(AVG(recency), 2) AS avg_recency,

    MIN(total_purchases) AS min_frequency,
    MAX(total_purchases) AS max_frequency,
    ROUND(AVG(total_purchases), 2) AS avg_frequency,

    MIN(total_spend) AS min_monetary,
    MAX(total_spend) AS max_monetary,
    ROUND(AVG(total_spend), 2) AS avg_monetary

FROM customer_personality_analysis;


-- Identify customers with zero purchase frequency
SELECT
    COUNT(*) AS zero_frequency_customers
FROM customer_personality_analysis
WHERE total_purchases = 0;


-- Review preferred channels among customers with zero purchases
SELECT
    preferred_channel,
    COUNT(*) AS customer_count
FROM customer_personality_analysis
WHERE total_purchases = 0
GROUP BY preferred_channel;


-- =========================================================
-- 16. RFM SCORING
-- =========================================================

-- Calculate percentile cutoffs for RFM dimensions
SELECT
    percentile_cont(ARRAY[0.2, 0.4, 0.6, 0.8])
    WITHIN GROUP (ORDER BY recency) AS recency_cutoffs,

    percentile_cont(ARRAY[0.2, 0.4, 0.6, 0.8])
    WITHIN GROUP (ORDER BY total_purchases) AS frequency_cutoffs,

    percentile_cont(ARRAY[0.2, 0.4, 0.6, 0.8])
    WITHIN GROUP (ORDER BY total_spend) AS monetary_cutoffs

FROM customer_personality_analysis;


-- Create RFM scoring view
CREATE OR REPLACE VIEW customer_rfm AS

SELECT
    id,
    recency,
    total_purchases,
    total_spend,

    -- Recency Score
    CASE
        WHEN recency <= 19 THEN 5
        WHEN recency <= 39 THEN 4
        WHEN recency <= 59 THEN 3
        WHEN recency <= 79 THEN 2
        ELSE 1
    END AS r_score,

    -- Frequency Score
    CASE
        WHEN total_purchases <= 5 THEN 1
        WHEN total_purchases <= 9 THEN 2
        WHEN total_purchases <= 15 THEN 3
        WHEN total_purchases <= 20 THEN 4
        ELSE 5
    END AS f_score,

    -- Monetary Score
    CASE
        WHEN total_spend <= 55 THEN 1
        WHEN total_spend <= 194.6 THEN 2
        WHEN total_spend <= 635.4 THEN 3
        WHEN total_spend <= 1174 THEN 4
        ELSE 5
    END AS m_score

FROM customer_personality_analysis;


-- Preview RFM scores
SELECT *
FROM customer_rfm
LIMIT 20;


-- Validate RFM score ranges
SELECT
    MIN(r_score) AS min_r,
    MAX(r_score) AS max_r,
    MIN(f_score) AS min_f,
    MAX(f_score) AS max_f,
    MIN(m_score) AS min_m,
    MAX(m_score) AS max_m
FROM customer_rfm;


-- Review Recency score distribution
SELECT
    r_score,
    COUNT(*) AS customer_count
FROM customer_rfm
GROUP BY r_score
ORDER BY r_score;


-- Review Frequency score distribution
SELECT
    f_score,
    COUNT(*) AS customer_count
FROM customer_rfm
GROUP BY f_score
ORDER BY f_score;


-- Review Monetary score distribution
SELECT
    m_score,
    COUNT(*) AS customer_count
FROM customer_rfm
GROUP BY m_score
ORDER BY m_score;


-- Add the overall RFM score
CREATE OR REPLACE VIEW customer_rfm AS

SELECT
    id,
    recency,
    total_purchases,
    total_spend,

    -- Recency Score
    CASE
        WHEN recency <= 19 THEN 5
        WHEN recency <= 39 THEN 4
        WHEN recency <= 59 THEN 3
        WHEN recency <= 79 THEN 2
        ELSE 1
    END AS r_score,

    -- Frequency Score
    CASE
        WHEN total_purchases <= 5 THEN 1
        WHEN total_purchases <= 9 THEN 2
        WHEN total_purchases <= 15 THEN 3
        WHEN total_purchases <= 20 THEN 4
        ELSE 5
    END AS f_score,

    -- Monetary Score
    CASE
        WHEN total_spend <= 55 THEN 1
        WHEN total_spend <= 194.6 THEN 2
        WHEN total_spend <= 635.4 THEN 3
        WHEN total_spend <= 1174 THEN 4
        ELSE 5
    END AS m_score,

    -- Overall RFM Score
    (
        CASE
            WHEN recency <= 19 THEN 5
            WHEN recency <= 39 THEN 4
            WHEN recency <= 59 THEN 3
            WHEN recency <= 79 THEN 2
            ELSE 1
        END
        +
        CASE
            WHEN total_purchases <= 5 THEN 1
            WHEN total_purchases <= 9 THEN 2
            WHEN total_purchases <= 15 THEN 3
            WHEN total_purchases <= 20 THEN 4
            ELSE 5
        END
        +
        CASE
            WHEN total_spend <= 55 THEN 1
            WHEN total_spend <= 194.6 THEN 2
            WHEN total_spend <= 635.4 THEN 3
            WHEN total_spend <= 1174 THEN 4
            ELSE 5
        END
    ) AS rfm_score

FROM customer_personality_analysis;


-- Validate overall RFM score
SELECT
    MIN(rfm_score) AS min_rfm_score,
    MAX(rfm_score) AS max_rfm_score,
    ROUND(AVG(rfm_score), 2) AS avg_rfm_score,
    COUNT(*) AS total_customers
FROM customer_rfm;


-- Confirm that the overall score equals R + F + M
SELECT
    COUNT(*) AS incorrect_rfm_score
FROM customer_rfm
WHERE rfm_score <> (r_score + f_score + m_score);


-- Review overall RFM score distribution
SELECT
    rfm_score,
    COUNT(*) AS customer_count
FROM customer_rfm
GROUP BY rfm_score
ORDER BY rfm_score;


-- =========================================================
-- 17. CUSTOMER SEGMENTATION — RULE VALIDATION
-- =========================================================

-- Profile the Champions segment
SELECT
    COUNT(*) AS champions
FROM customer_rfm
WHERE r_score >= 4
  AND f_score >= 4
  AND m_score >= 4;


-- Profile Loyal Customers
SELECT
    COUNT(*) AS loyal_customers
FROM customer_rfm
WHERE r_score >= 3
  AND f_score >= 4
  AND m_score >= 3;


-- Profile Potential Loyalists
SELECT
    COUNT(*) AS potential_loyalists
FROM customer_rfm
WHERE r_score >= 4
  AND f_score BETWEEN 2 AND 3
  AND m_score >= 2;


-- Profile At Risk customers
SELECT
    COUNT(*) AS at_risk
FROM customer_rfm
WHERE r_score <= 2
  AND f_score >= 3
  AND m_score >= 3;


-- Profile Hibernating customers
SELECT
    COUNT(*) AS hibernating
FROM customer_rfm
WHERE r_score <= 2
  AND f_score <= 2
  AND m_score <= 2;


-- Identify customers not covered by the initial rules
SELECT
    COUNT(*) AS unclassified_customers
FROM customer_rfm
WHERE NOT (
    (r_score >= 4 AND f_score >= 4 AND m_score >= 4)
    OR
    (r_score >= 3 AND f_score >= 4 AND m_score >= 3)
    OR
    (r_score >= 4 AND f_score BETWEEN 2 AND 3 AND m_score >= 2)
    OR
    (r_score <= 2 AND f_score >= 3 AND m_score >= 3)
    OR
    (r_score <= 2 AND f_score <= 2 AND m_score <= 2)
);


-- Profile the unclassified RFM combinations
SELECT
    r_score,
    f_score,
    m_score,
    COUNT(*) AS customer_count
FROM customer_rfm
WHERE NOT (
    (r_score >= 4 AND f_score >= 4 AND m_score >= 4)
    OR
    (r_score >= 3 AND f_score >= 4 AND m_score >= 3)
    OR
    (r_score >= 4 AND f_score BETWEEN 2 AND 3 AND m_score >= 2)
    OR
    (r_score <= 2 AND f_score >= 3 AND m_score >= 3)
    OR
    (r_score <= 2 AND f_score <= 2 AND m_score <= 2)
)
GROUP BY
    r_score,
    f_score,
    m_score
ORDER BY
    r_score,
    f_score,
    m_score;


-- Validate the Recent / Low Engagement rule
SELECT
    COUNT(*) AS recent_low_engagement
FROM customer_rfm
WHERE r_score >= 4
  AND f_score <= 2
  AND m_score <= 2;


-- Check whether No Purchases customers fall into the Recent / Low Engagement rule
SELECT
    COUNT(*) AS no_purchase_in_recent_rule
FROM customer_rfm r
JOIN customer_personality_analysis p
    ON r.id = p.id
WHERE p.preferred_channel = 'No Purchases'
  AND r.r_score >= 4
  AND r.f_score <= 2
  AND r.m_score <= 2;


-- Confirm that all customers are covered by the expanded rules
SELECT
    COUNT(*) AS still_unclassified
FROM customer_rfm
WHERE NOT (
    -- Champions
    (r_score >= 4 AND f_score >= 4 AND m_score >= 4)

    OR

    -- Loyal Customers
    (r_score >= 3 AND f_score >= 4 AND m_score >= 3)

    OR

    -- Potential Loyalists
    (r_score >= 4 AND f_score BETWEEN 2 AND 3 AND m_score >= 2)

    OR

    -- At Risk
    (r_score <= 2 AND f_score >= 3 AND m_score >= 3)

    OR

    -- Hibernating
    (r_score <= 2 AND f_score <= 2 AND m_score <= 2)

    OR

    -- Recent / Low Engagement
    (r_score >= 4 AND f_score <= 2 AND m_score <= 2)
);


-- Inspect remaining unclassified RFM combinations
SELECT
    r_score,
    f_score,
    m_score,
    COUNT(*) AS customer_count
FROM customer_rfm
WHERE NOT (
    (r_score >= 4 AND f_score >= 4 AND m_score >= 4)
    OR
    (r_score >= 3 AND f_score >= 4 AND m_score >= 3)
    OR
    (r_score >= 4 AND f_score BETWEEN 2 AND 3 AND m_score >= 2)
    OR
    (r_score <= 2 AND f_score >= 3 AND m_score >= 3)
    OR
    (r_score <= 2 AND f_score <= 2 AND m_score <= 2)
    OR
    (r_score >= 4 AND f_score <= 2 AND m_score <= 2)
)
GROUP BY
    r_score,
    f_score,
    m_score
ORDER BY
    r_score,
    f_score,
    m_score;


-- Validate Need Attention rule
SELECT
    COUNT(*) AS need_attention
FROM customer_rfm
WHERE r_score = 3
  AND f_score <= 3
  AND m_score <= 3;


-- Validate High Value At Risk rule
SELECT
    COUNT(*) AS high_value_at_risk
FROM customer_rfm
WHERE r_score <= 3
  AND f_score <= 3
  AND m_score >= 4;

-- =========================================================
-- 18. FINAL SEGMENTATION VALIDATION
-- =========================================================

-- Validate final segment distribution based on CASE statement order
SELECT
    CASE

        -- 1. No Purchases
        WHEN total_purchases = 0
            THEN 'No Purchases'

        -- 2. Champions
        WHEN r_score >= 4
             AND f_score >= 4
             AND m_score >= 4
            THEN 'Champions'

        -- 3. Loyal Customers
        WHEN r_score >= 3
             AND f_score >= 4
             AND m_score >= 3
            THEN 'Loyal Customers'

        -- 4. Potential Loyalists
        WHEN r_score >= 4
             AND f_score BETWEEN 2 AND 3
             AND m_score >= 2
            THEN 'Potential Loyalists'

        -- 5. High Value At Risk
        WHEN r_score <= 3
             AND f_score <= 3
             AND m_score >= 4
            THEN 'High Value At Risk'

        -- 6. At Risk
        WHEN r_score <= 2
             AND f_score >= 3
             AND m_score >= 3
            THEN 'At Risk'

        -- 7. Hibernating
        WHEN r_score <= 2
             AND f_score <= 2
             AND m_score <= 2
            THEN 'Hibernating'

        -- 8. Recent / Low Engagement
        WHEN r_score >= 4
             AND f_score <= 2
             AND m_score <= 2
            THEN 'Recent / Low Engagement'

        -- 9. Remaining customers
        ELSE 'Need Attention'

    END AS customer_segment,

    COUNT(*) AS customer_count

FROM customer_rfm

GROUP BY
    CASE

        WHEN total_purchases = 0
            THEN 'No Purchases'

        WHEN r_score >= 4
             AND f_score >= 4
             AND m_score >= 4
            THEN 'Champions'

        WHEN r_score >= 3
             AND f_score >= 4
             AND m_score >= 3
            THEN 'Loyal Customers'

        WHEN r_score >= 4
             AND f_score BETWEEN 2 AND 3
             AND m_score >= 2
            THEN 'Potential Loyalists'

        WHEN r_score <= 3
             AND f_score <= 3
             AND m_score >= 4
            THEN 'High Value At Risk'

        WHEN r_score <= 2
             AND f_score >= 3
             AND m_score >= 3
            THEN 'At Risk'

        WHEN r_score <= 2
             AND f_score <= 2
             AND m_score <= 2
            THEN 'Hibernating'

        WHEN r_score >= 4
             AND f_score <= 2
             AND m_score <= 2
            THEN 'Recent / Low Engagement'

        ELSE 'Need Attention'

    END

ORDER BY customer_count DESC;


-- Confirm that No Purchases customers are not assigned
-- a high RFM score
SELECT
    COUNT(*) AS invalid_no_purchase
FROM customer_rfm
WHERE total_purchases = 0
  AND rfm_score > 3;


-- Confirm total and unique customer counts
SELECT
    COUNT(*) AS total_customers
FROM customer_rfm;


SELECT
    COUNT(DISTINCT id) AS unique_customers
FROM customer_rfm;


-- Validate Champions rule
SELECT
    COUNT(*) AS invalid_champions
FROM customer_rfm
WHERE
    r_score >= 4
    AND f_score >= 4
    AND m_score >= 4
    AND NOT (
        r_score >= 4
        AND f_score >= 4
        AND m_score >= 4
    );


-- =========================================================
-- 19. SEGMENT PROFILING
-- =========================================================

-- Profile each customer segment using RFM and behavioral metrics
SELECT
    CASE

        WHEN total_purchases = 0
            THEN 'No Purchases'

        WHEN r_score >= 4
             AND f_score >= 4
             AND m_score >= 4
            THEN 'Champions'

        WHEN r_score >= 3
             AND f_score >= 4
             AND m_score >= 3
            THEN 'Loyal Customers'

        WHEN r_score >= 4
             AND f_score BETWEEN 2 AND 3
             AND m_score >= 2
            THEN 'Potential Loyalists'

        WHEN r_score <= 3
             AND f_score <= 3
             AND m_score >= 4
            THEN 'High Value At Risk'

        WHEN r_score <= 2
             AND f_score >= 3
             AND m_score >= 3
            THEN 'At Risk'

        WHEN r_score <= 2
             AND f_score <= 2
             AND m_score <= 2
            THEN 'Hibernating'

        WHEN r_score >= 4
             AND f_score <= 2
             AND m_score <= 2
            THEN 'Recent / Low Engagement'

        ELSE 'Need Attention'

    END AS customer_segment,

    COUNT(*) AS customer_count,

    ROUND(AVG(r_score), 2) AS avg_r_score,
    ROUND(AVG(f_score), 2) AS avg_f_score,
    ROUND(AVG(m_score), 2) AS avg_m_score,

    ROUND(AVG(rfm_score), 2) AS avg_rfm_score,

    ROUND(AVG(total_purchases), 2) AS avg_frequency,
    ROUND(AVG(total_spend), 2) AS avg_monetary,
    ROUND(AVG(recency), 2) AS avg_recency

FROM customer_rfm

GROUP BY
    CASE

        WHEN total_purchases = 0
            THEN 'No Purchases'

        WHEN r_score >= 4
             AND f_score >= 4
             AND m_score >= 4
            THEN 'Champions'

        WHEN r_score >= 3
             AND f_score >= 4
             AND m_score >= 3
            THEN 'Loyal Customers'

        WHEN r_score >= 4
             AND f_score BETWEEN 2 AND 3
             AND m_score >= 2
            THEN 'Potential Loyalists'

        WHEN r_score <= 3
             AND f_score <= 3
             AND m_score >= 4
            THEN 'High Value At Risk'

        WHEN r_score <= 2
             AND f_score >= 3
             AND m_score >= 3
            THEN 'At Risk'

        WHEN r_score <= 2
             AND f_score <= 2
             AND m_score <= 2
            THEN 'Hibernating'

        WHEN r_score >= 4
             AND f_score <= 2
             AND m_score <= 2
            THEN 'Recent / Low Engagement'

        ELSE 'Need Attention'

    END

ORDER BY
    avg_rfm_score DESC;


-- =========================================================
-- 20. FINAL CUSTOMER SEGMENTATION VIEW
-- =========================================================

CREATE OR REPLACE VIEW customer_rfm_analysis AS

SELECT
    r.*,

    CASE

        -- No Purchases
        WHEN r.total_purchases = 0
            THEN 'No Purchases'

        -- Champions
        WHEN r.r_score >= 4
             AND r.f_score >= 4
             AND r.m_score >= 4
            THEN 'Champions'

        -- Loyal Customers
        WHEN r.r_score >= 3
             AND r.f_score >= 4
             AND r.m_score >= 3
            THEN 'Loyal Customers'

        -- Potential Loyalists
        WHEN r.r_score >= 4
             AND r.f_score BETWEEN 2 AND 3
             AND r.m_score >= 2
            THEN 'Potential Loyalists'

        -- High Value At Risk
        WHEN r.r_score <= 3
             AND r.f_score <= 3
             AND r.m_score >= 4
            THEN 'High Value At Risk'

        -- At Risk
        WHEN r.r_score <= 2
             AND r.f_score >= 3
             AND r.m_score >= 3
            THEN 'At Risk'

        -- Hibernating
        WHEN r.r_score <= 2
             AND r.f_score <= 2
             AND r.m_score <= 2
            THEN 'Hibernating'

        -- Recent / Low Engagement
        WHEN r.r_score >= 4
             AND r.f_score <= 2
             AND r.m_score <= 2
            THEN 'Recent / Low Engagement'

        -- Remaining customers
        ELSE 'Need Attention'

    END AS customer_segment

FROM customer_rfm r;


-- Validate final segmentation view
SELECT
    customer_segment,
    COUNT(*) AS customer_count
FROM customer_rfm_analysis
GROUP BY customer_segment
ORDER BY customer_count DESC;


-- =========================================================
-- 21. FINAL DATASET PREPARATION FOR POWER BI
-- =========================================================

-- Inspect the columns available in the RFM analysis view
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'customer_rfm_analysis'
ORDER BY ordinal_position;


-- Inspect the columns available in the feature engineering view
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'customer_personality_analysis'
ORDER BY ordinal_position;


-- Create the final analytical dataset for Power BI
CREATE OR REPLACE VIEW customer_personality_final AS

SELECT
    p.id,

    -- Customer Profile
    p.age,
    p.education,
    p.marital_status,
    p.income,
    p.kidhome,
    p.teenhome,
    p.family_size,
    p.dt_customer,
    p.customer_tenure_days,

    -- Purchase Behavior
    p.recency,
    p.mnt_wines,
    p.mnt_fruits,
    p.mnt_meat_products,
    p.mnt_fish_products,
    p.mnt_sweet_products,
    p.mnt_gold_prods,

    p.num_deals_purchases,
    p.num_web_purchases,
    p.num_catalog_purchases,
    p.num_store_purchases,
    p.num_web_visits_month,

    p.total_spend,
    p.total_purchases,

    p.preferred_channel,

    -- Campaigns
    p.accepted_cmp1,
    p.accepted_cmp2,
    p.accepted_cmp3,
    p.accepted_cmp4,
    p.accepted_cmp5,
    p.total_campaigns_accepted,
    p.response,
    p.complain,

    -- RFM
    r.r_score,
    r.f_score,
    r.m_score,
    r.rfm_score,
    r.customer_segment

FROM customer_personality_analysis p

LEFT JOIN customer_rfm_analysis r
    ON p.id = r.id;


-- =========================================================
-- 22. FINAL DATASET VALIDATION
-- =========================================================

-- Preview the final analytical dataset
SELECT *
FROM customer_personality_final
LIMIT 10;


-- Validate total and unique customer counts
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT id) AS unique_customers
FROM customer_personality_final;


-- Check RFM and segmentation completeness
SELECT
    COUNT(*) AS total_rows,
    COUNT(rfm_score) AS rfm_filled,
    COUNT(customer_segment) AS segment_filled
FROM customer_personality_final;


-- Validate final segment distribution
SELECT
    customer_segment,
    COUNT(*) AS customer_count
FROM customer_personality_final
GROUP BY customer_segment
ORDER BY customer_count DESC;


-- =========================================================
-- 23. FINAL DATA QUALITY CHECK
-- =========================================================

SELECT
    COUNT(*) AS total_rows,

    COUNT(*) FILTER (WHERE id IS NULL) AS missing_id,
    COUNT(*) FILTER (WHERE age IS NULL) AS missing_age,
    COUNT(*) FILTER (WHERE income IS NULL) AS missing_income,
    COUNT(*) FILTER (WHERE total_spend IS NULL) AS missing_total_spend,
    COUNT(*) FILTER (WHERE total_purchases IS NULL) AS missing_total_purchases,
    COUNT(*) FILTER (WHERE rfm_score IS NULL) AS missing_rfm_score,
    COUNT(*) FILTER (WHERE customer_segment IS NULL) AS missing_segment

FROM customer_personality_final;


-- =========================================================
-- 24. FINAL REVIEW — CUSTOMERS WITH MISSING AGE
-- =========================================================

-- Only customers with invalid original birth-year values
-- retain a NULL Age. These cases are intentionally preserved
-- rather than imputed with an arbitrary value.

SELECT
    id,
    age,
    income,
    education,
    marital_status,
    customer_segment
FROM customer_personality_final
WHERE age IS NULL;