/*
==========================================================
Healthcare Revenue Cycle Analytics Using SQL Server
File: 01_database_overview.sql
Author: Esther Akinniyi
Database: Healthcare_DB

Description:
Provides a high-level overview of the healthcare database,
including transaction volume, unique patient counts, and
CPT code distribution.
==========================================================
*/

USE Healthcare_DB;
GO

/*
Question 1:
How many FactTable records have a gross charge greater
than $100?
*/

SELECT
    COUNT(*) AS Count_Of_Rows
FROM FactTable
WHERE GrossCharge > 100;


/*
Question 2:
How many unique patients exist in the database?
*/

SELECT
    COUNT(DISTINCT PatientNumber) AS Unique_Patients
FROM dimPatient;


/*
Question 3:
How many distinct CPT codes exist in each CPT grouping?
*/

SELECT
    CptGrouping,
    COUNT(DISTINCT CptCode) AS Count_Of_CPT_Codes
FROM dimCptCode
GROUP BY
    CptGrouping
ORDER BY
    Count_Of_CPT_Codes DESC;
