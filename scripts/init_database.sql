/*
=============================================================
Create Schemas
=============================================================
Script Purpose:
    This script creates three schemas for the Data Warehouse:
    - bronze : Stores raw data
    - silver : Stores cleaned and transformed data
    - gold   : Stores business-ready data for reporting

Note:
    Ensure the database 'datawarehouse' is created before
    running this script.
=============================================================
*/

CREATE SCHEMA IF NOT EXISTS bronze;

CREATE SCHEMA IF NOT EXISTS silver;

CREATE SCHEMA IF NOT EXISTS gold;
