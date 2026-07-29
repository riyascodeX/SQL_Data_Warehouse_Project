/*===============================================================================
STORED PROCEDURE: load_silver (Bronze -> Silver)
===============================================================================
Script Purpose:
    This script performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables.
	
Actions Performed:
	- Drops existing bronze tables if they exist.
	- Re-creates silver tables with proper schemas and metadata.
		
Parameters:
    None.
===============================================================================*/


-- ============================================================================
-- 1. TABLE: silver.crm_cust_info
-- ============================================================================
DROP TABLE IF EXISTS silver.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
    cst_id              INT,
    cst_key             VARCHAR(50),
    cst_first_name      VARCHAR(50),
    cst_last_name       VARCHAR(50),
    cst_material_status  VARCHAR(50),
    cst_gndr            VARCHAR(50),
    cst_create_date     DATE,
    dwh_create_date     TIMESTAMPTZ DEFAULT now()
);

-- ============================================================================
-- 2. TABLE: silver.crm_prd_info
-- ============================================================================
DROP TABLE IF EXISTS silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info (
    prd_id       INT,
    cat_id       VARCHAR(50),
    prd_key      VARCHAR(50),
    prd_name       VARCHAR(50),
    prd_country       INT,
    prd_line     VARCHAR(50),
    prd_start_date DATE,
    prd_end_date   DATE,
    dwh_create_date     TIMESTAMPTZ DEFAULT now()
);

-- ============================================================================
-- 3. TABLE: silver.crm_sales_details
-- ============================================================================
DROP TABLE IF EXISTS silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details (
    sls_ord_num  VARCHAR(50),
    sls_prd_key  VARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT,
    dwh_create_date     TIMESTAMPTZ DEFAULT now()
);

-- ============================================================================
-- 4. TABLE: silver.erp_loc_a101
-- ============================================================================
DROP TABLE IF EXISTS silver.erp_loc_a101;
CREATE TABLE silver.erp_loc_a101 (
    cid    VARCHAR(50),
    country  VARCHAR(50),
    dwh_create_date     TIMESTAMPTZ DEFAULT now()
);

-- ============================================================================
-- 5. TABLE: silver.erp_cust_az12
-- ============================================================================
DROP TABLE IF EXISTS silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12 (
    cid    VARCHAR(50),
    bdate  DATE,
    gen    VARCHAR(50),
    dwh_create_date     TIMESTAMPTZ DEFAULT now()
);

-- ============================================================================
-- 6. TABLE: silver.erp_px_cat_g1v2
-- ============================================================================
DROP TABLE IF EXISTS silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2 (
    id           VARCHAR(50),
    cat          VARCHAR(50),
    subcat       VARCHAR(50),
    maintenance  VARCHAR(50),
    dwh_create_date     TIMESTAMPTZ DEFAULT now()
);
