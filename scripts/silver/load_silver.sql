/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

===============================================================================
*/

-- 1. TABLE: bronze.crm_cust_info
INSERT INTO silver.crm_cust_info(
	cst_id,
	cst_key,
	cst_first_name,
	cst_last_name,
	cst_material_status,
	cst_gndr,
	cst_create_date
)
SELECT
	cst_id,
	cst_key,
	TRIM(cst_first_name)AS cst_first_name,
	TRIM(cst_last_name)AS cst_last_name,
  
	CASE 
		WHEN UPPER(TRIM(cst_material_status))='S' THEN 'Single'
		WHEN UPPER(TRIM(cst_material_status))='M' THEN 'Married'
		ELSE 'N/A'
	END cst_material_status,
	
	CASE 
		WHEN UPPER(TRIM(cst_gndr))='M' THEN 'Male'
		WHEN UPPER(TRIM(cst_gndr))='F' THEN 'Female'
		ELSE 'N/A'
	END cst_gndr,
	cst_create_date
  
FROM
(
	SELECT *,
	ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_Date DESC)AS flag_last
	FROM bronze.crm_cust_info
) AS src

WHERE flag_last =1 AND cst_id IS NOT NULL
----------------------------------------------------------------------------------------------------------
SELECT * FROM silver.crm_cust_info
----------------------------------------------------------------------------------------------------------


-- 2. TABLE: bronze.crm_prd_info
INSERT INTO(
	prd_id,
	prd_key,
	cat_id,
	prd_name,
	prd_cost,
	prd_line,
	prd_start_date,
	prd_end_date
)
SELECT
	prd_id,
	REPLACE(SUBSTRING(prd_key,1,5),'-','_')AS cat_id,
	SUBSTRING(prd_key,7,LENGTH(prd_key))AS prd_key,
	prd_name,
	prd_cost,
	prd_line,
	prd_start_date,
	prd_end_date
FROM bronze.crm_prd_info
----------------------------------------------------------------------------------------------------------
SELECT * FROM silver.crm_prd_info
----------------------------------------------------------------------------------------------------------


-- 3. TABLE: bronze.crm_sales_details
INSERT INTO silver.crm_sales_details(
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
)
SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE
		WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt :: text)!=8 THEN NULL
		ELSE CAST (CAST(sls_order_dt AS varchar) AS Date)
	END sls_order_dt,
	
	CASE
		WHEN sls_ship_dt= 0 or length(sls_ship_dt :: text)!=8 THEN NULL
		ELSE CAST(CAST(sls_ship_dt AS varchar)AS Date)
	END sls_ship_dt,
	
	CASE
		WHEN sls_due_dt= 0 OR LENGTH(sls_due_dt :: text)!=8 THEN NULL
		ELSE CAST (CAST(sls_due_dt AS varchar) AS Date)
	END sls_due_dt,
	
	CASE
		WHEN sls_sales IS NULL OR sls_sales <0 OR sls_sales != sls_quantity * ABS(sls_price)
		THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales
	END sls_sales,
	
	sls_quantity,
	
	CASE 
		WHEN sls_price IS NULL OR sls_price <0 
		THEN sls_sales /sls_quantity
		ELSE sls_price
	END sls_price
FROM bronze.crm_sales_details
----------------------------------------------------------------------------------------------------------
SELECT * FROM  silver.crm_sales_details
----------------------------------------------------------------------------------------------------------


-- 4. TABLE: bronze.erp_loc_a101
INSERT INTO silver.erp_cust_az12(
	cid,
	bdate,
	gen
)
SELECT
  CASE
  	WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LENGTH(cid))
  	ELSE cid
  END cid,
  
  case
  	WHEN bdate >CURRENT_DATE THEN NULL
  	ELSE bdate
  END bdate,
  
  CASE
  	WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
  	WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
  	ELSE 'N/A'
  END gen
FROM bronze.erp_cust_az12 
----------------------------------------------------------------------------------------------------------
SELECT * FROM silver.erp_cust_az12
----------------------------------------------------------------------------------------------------------


-- 5. TABLE: bronze.erp_cust_az12
INSERT INTO silver.erp_loc_a101(
	cid,
	country
)
SELECT
CASE 
	WHEN cid LIKE 'AW-%' THEN REPLACE(cid,'-','')
END cid,
CASE 
	WHEN UPPER(TRIM(country))IN('US','USA','UNITED STATES') THEN 'US'
	WHEN UPPER(TRIM(country))='AUSTRALIA' THEN 'Aus'
	WHEN UPPER(TRIM(country))IN('GERMANY','DE') THEN 'Ger'
	WHEN UPPER(TRIM(country))='CANADA' THEN 'Can'
	WHEN UPPER(TRIM(country))='FRANCE' THEN 'Fra'
	WHEN UPPER(TRIM(country))='UNITED KINGDOM' THEN 'Uk'
	ELSE 'N/A'
END country
FROM bronze.erp_loc_a101
----------------------------------------------------------------------------------------------------------
SELECT * FROM silver.erp_loc_a101
----------------------------------------------------------------------------------------------------------


-- 6. TABLE: bronze.erp_px_cat_g1v2
INSERT INTO silver.erp_px_cat_g1v2(
	id,
	cat,
	subcat,
	maintenance
)
SELECT ID,cat,subcat,maintenance FROM bronze.erp_px_cat_g1v2 
----------------------------------------------------------------------------------------------------------
SELECT * FROM silver.erp_px_cat_g1v2 
----------------------------------------------------------------------------------------------------------
