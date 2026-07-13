/*
==========================================================
Healthcare Revenue Cycle Analytics Using SQL Server
File: 08_diabetes_patient_analysis.sql
Author: Esther Akinniyi
Database: Healthcare_DB

Description:
Analyzes the average age and patient count by gender for
patients diagnosed with Type 2 diabetes at Big Heart
Community Hospital.
==========================================================
*/

USE Healthcare_DB;
GO

/*
Question:
What is the average patient age by gender for patients
seen at Big Heart Community Hospital with a diagnosis
that includes Type 2 diabetes?
*/

SELECT
    PatientGender,
    ROUND(AVG(CAST(PatientAge AS DECIMAL(6, 2))), 1)
        AS Average_Patient_Age,
    COUNT(DISTINCT PatientNumber) AS Patient_Count
FROM (
    SELECT DISTINCT
        ft.PatientNumber,
        pat.PatientGender,
        pat.PatientAge
    FROM FactTable AS ft
    INNER JOIN dimPatient AS pat
        ON pat.dimPatientPK = ft.dimPatientPK
    INNER JOIN dimDiagnosisCode AS diag
        ON diag.dimDiagnosisCodePK = ft.dimDiagnosisCodePK
    INNER JOIN dimLocation AS loc
        ON loc.dimLocationPK = ft.dimLocationPK
    WHERE loc.LocationName = 'Big Heart Community Hospital'
      AND diag.DiagnosisCodeDescription LIKE '%Type 2%'
) AS Diabetes_Patients
GROUP BY
    PatientGender
ORDER BY
    PatientGender;
