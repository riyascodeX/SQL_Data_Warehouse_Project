/*
===============================================================================
STEP 1: INITIAL DATA LOADING (RAW INGESTION)
===============================================================================
Script Purpose:
    This script prepares the database for the manual Import/Export wizard.
    It drops old tables and creates fresh structures to receive the raw data.

**NOTE: 
    STORED PROCEDURES / SERVER-SIDE 'COPY' COMMANDS ARE NOT USED HERE.
    Due to local laptop server permission restrictions, automated scripts cannot
    access local directory paths. Data must be imported using the GUI wizard.

How to Load Data in pgAdmin:
    1. Run this entire script to create the 6 empty tables.
    2. Right-click a table in pgAdmin (e.g., crm_cust_info).
    3. Select 'Import/Export data...'.
    4. Set the toggle to 'Import', select your CSV file, and choose 'CSV' format.
    5. Turn on the 'Header' option and click 'OK'.
===============================================================================
*/
