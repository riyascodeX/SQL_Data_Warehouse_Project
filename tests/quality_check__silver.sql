/*
===============================================================================
QUALITY CHECKS: TESTING THE CLEANSED DATA (SILVER LAYER)
===============================================================================
Script Purpose:
    This script is used to verify that our data is clean, accurate, and ready 
    for business reports. It checks for common data mistakes like:
    
    - Missing or duplicated unique IDs (Primary Keys).
    - Hidden blank spaces or trailing gaps in text.
    - Wrong or out-of-order date entries (e.g., shipping before ordering).
    - Math errors (e.g., Sales amount not matching Quantity * Price).

How to Use:
    - Run these queries after loading data into the Silver layer.
    - If a query returns 0 rows, the data passed the quality check.
===============================================================================
*/

-- 1. TESTING TABLE: silver.crm_cust_info
-- Check: Are there any duplicate or missing Customer IDs? (Should be 0)
SELECT 
    cst_id,
    COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check: Are there any unwanted empty spaces around the customer keys? (Should be 0)
SELECT 
    cst_key 
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Check: See all unique Marital Status types to look for spelling mistakes.
SELECT DISTINCT 
    cst_marital_status 
FROM silver.crm_cust_info;
-------------------------------------------------------------------------------------------------------

-- 2. TESTING TABLE: silver.crm_prd_info
-- Check: Are there any duplicate or missing Product IDs? (Should be 0)
SELECT 
    prd_id,
    COUNT(*) 
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check: Are there any unwanted spaces in the product names? (Should be 0)
SELECT 
    prd_nm 
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check: Are there any free products or negative costs? (Should be 0)
SELECT 
    prd_cost 
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Check: See all unique product lines to verify consistency.
SELECT DISTINCT 
    prd_line 
FROM silver.crm_prd_info;

-- Check: Did any product end before its start date? (Should be 0)
SELECT 
    * 
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;
-------------------------------------------------------------------------------------------------------

-- 3. TESTING TABLE: silver.crm_sales_details
-- Check: Are there any invalid due dates outside normal bounds? (Should be 0)
SELECT 
    NULLIF(sls_due_dt, 0) AS sls_due_dt 
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
    OR LENGTH(sls_due_dt::TEXT) != 8 
    OR sls_due_dt > 20500101 
    OR sls_due_dt < 19000101;

-- Check: Is any order date listed after the shipping or due date? (Should be 0)
SELECT 
    * 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
   OR sls_order_dt > sls_due_dt;

-- Check: Does the math work? (Sales must equal Quantity multiplied by Price) (Should be 0)
SELECT DISTINCT 
    sls_sales,
    sls_quantity,
    sls_price 
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;
-------------------------------------------------------------------------------------------------------

-- 4. TESTING TABLE: silver.erp_cust_az12
-- Check: Are there any impossible birthdates (older than 100 years or from the future)? (Should be 0)
SELECT DISTINCT 
    bdate 
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' 
   OR bdate > CURRENT_DATE;

-- Check: See all unique gender values to check for uniform formatting.
SELECT DISTINCT 
    gen 
FROM silver.erp_cust_az12;
-------------------------------------------------------------------------------------------------------

-- 5. TESTING TABLE: silver.erp_loc_a101
-- Check: See all countries to verify there are no duplicate or messy entries.
SELECT DISTINCT 
    cntry 
FROM silver.erp_loc_a101
ORDER BY cntry;
-------------------------------------------------------------------------------------------------------

-- 6. TESTING TABLE: silver.erp_px_cat_g1v2
-- Check: Are there any spaces in the category or maintenance columns? (Should be 0)
SELECT 
    * 
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
   OR subcat != TRIM(subcat) 
   OR maintenance != TRIM(maintenance);

-- Check: Verify all categories listed under maintenance configurations.
SELECT DISTINCT 
    maintenance 
FROM silver.erp_px_cat_g1v2;
