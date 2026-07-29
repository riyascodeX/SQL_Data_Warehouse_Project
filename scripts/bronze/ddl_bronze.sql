/*===============================================================================
DDL SCRIPT: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This script defines the structure for the 'bronze' schema tables.
	
Actions Performed:
	- Drops existing bronze tables if they exist.
	- Re-creates bronze tables to store raw, un-cleansed staging data.
		
Parameters:
    None.
============================================================================== */

-- ============================================================================
-- 1. TABLE: bronze.crm_cust_info
-- ============================================================================
DROP TABLE IF EXISTS bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
    cst_id              INT,
    cst_key             VARCHAR(50),
    cst_first_name       VARCHAR(50),
    cst_last_name        VARCHAR(50),
    cst_material_status  VARCHAR(50),
    cst_gndr            VARCHAR(50),
    cst_create_date     DATE
);

-- ============================================================================
-- 2. TABLE: bronze.crm_prd_info
-- ============================================================================
DROP TABLE IF EXISTS bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
    prd_id       INT,
    prd_key      VARCHAR(50),
    prd_name       VARCHAR(50),
    prd_cost     INT,
    prd_line     VARCHAR(50),
    prd_start_date DATE,
    prd_end_date   DATE
);

-- ============================================================================
-- 3. TABLE: bronze.crm_sales_details
-- ============================================================================
DROP TABLE IF EXISTS bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  VARCHAR(50),
    sls_prd_key  VARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT
);

-- ============================================================================
-- 4. TABLE: bronze.erp_loc_a101
-- ============================================================================
DROP TABLE IF EXISTS bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101 (
    cid    VARCHAR(50),
    country  VARCHAR(50)
);

-- ============================================================================
-- 5. TABLE: bronze.erp_cust_az12
-- ============================================================================
DROP TABLE IF EXISTS bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12 (
    cid    VARCHAR(50),
    bdate  DATE,
    gen    VARCHAR(50)
);

-- ============================================================================
-- 6. TABLE: bronze.erp_px_cat_g1v2
-- ============================================================================
DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2 (
    id           VARCHAR(50),
    cat          VARCHAR(50),
    subcat       VARCHAR(50),
    maintenance  VARCHAR(50)
);
