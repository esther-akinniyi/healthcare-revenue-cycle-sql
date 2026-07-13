/*
==========================================================
Healthcare Revenue Cycle Analytics Using SQL Server
File: 11_location_financial_summary.sql
Author: Esther Akinniyi
Database: Healthcare_DB

Description:
Creates a location-level financial and operational summary
including physician counts, patient counts, gross charges,
and average charge per patient.
==========================================================
*/

USE Healthcare_DB;
GO

SELECT
    loc.LocationName,
    COUNT(DISTINCT phy.ProviderNpi) AS Physician_Count,
    COUNT(DISTINCT pat.PatientNumber) AS Patient_Count,
    FORMAT(SUM(ft.GrossCharge), '$#,##0') AS Gross_Charges,
    FORMAT(
        SUM(ft.GrossCharge) /
        NULLIF(COUNT(DISTINCT pat.PatientNumber), 0),
        '$#,##0'
    ) AS Average_Charge_Per_Patient
FROM FactTable AS ft
INNER JOIN dimLocation AS loc
    ON loc.dimLocationPK = ft.dimLocationPK
INNER JOIN dimPhysician AS phy
    ON phy.dimPhysicianPK = ft.dimPhysicianPK
INNER JOIN dimPatient AS pat
    ON pat.dimPatientPK = ft.dimPatientPK
GROUP BY
    loc.LocationName
ORDER BY
    SUM(ft.GrossCharge) DESC;
