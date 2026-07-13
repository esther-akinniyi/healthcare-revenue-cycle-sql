/*
==========================================================
Healthcare Revenue Cycle Analytics Using SQL Server
File: 02_patient_provider_analysis.sql
Author: Esther Akinniyi
Database: Healthcare_DB

Description:
Analyzes patient and provider activity, including Medicare
claim participation and provider distribution by payer.
==========================================================
*/

USE Healthcare_DB;
GO

/*
Question 1:
How many providers submitted at least one Medicare claim?
*/

SELECT
    COUNT(DISTINCT phy.ProviderNpi) AS Medicare_Provider_Count
FROM FactTable AS ft
INNER JOIN dimPhysician AS phy
    ON phy.dimPhysicianPK = ft.dimPhysicianPK
INNER JOIN dimPayer AS pay
    ON pay.dimPayerPK = ft.dimPayerPK
WHERE pay.PayerName = 'Medicare';


/*
Question 2:
How many distinct providers submitted claims to each payer?
*/

SELECT
    pay.PayerName,
    COUNT(DISTINCT phy.ProviderNpi) AS Provider_Count
FROM FactTable AS ft
INNER JOIN dimPhysician AS phy
    ON phy.dimPhysicianPK = ft.dimPhysicianPK
INNER JOIN dimPayer AS pay
    ON pay.dimPayerPK = ft.dimPayerPK
GROUP BY
    pay.PayerName
ORDER BY
    Provider_Count DESC;


/*
Question 3:
How many physicians and patients are associated with
each healthcare location?
*/

SELECT
    loc.LocationName,
    COUNT(DISTINCT phy.ProviderNpi) AS Physician_Count,
    COUNT(DISTINCT pat.PatientNumber) AS Patient_Count
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
    Patient_Count DESC;
