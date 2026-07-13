/*
==========================================================
Healthcare Revenue Cycle Analytics Using SQL Server
File: 07_patient_demographics_reporting.sql
Author: Esther Akinniyi
Database: Healthcare_DB

Description:
Creates a patient demographic report with names, contact
information, age groups, and geographic information.
==========================================================
*/

USE Healthcare_DB;
GO

/*
Question:
Create a patient demographic report with age categories.
*/

SELECT
    CONCAT(FirstName, ' ', LastName) AS Patient_Name,
    Email,
    PatientAge,
    CASE
        WHEN PatientAge < 18 THEN 'Under 18'
        WHEN PatientAge BETWEEN 18 AND 65 THEN '18-65'
        WHEN PatientAge > 65 THEN 'Over 65'
        ELSE 'Unknown'
    END AS Patient_Age_Bucket,
    CONCAT(City, ', ', [State]) AS City_State
FROM dimPatient
ORDER BY
    PatientAge,
    Patient_Name;
