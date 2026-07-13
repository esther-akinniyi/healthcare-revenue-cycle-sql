/*
==========================================================
Healthcare Revenue Cycle Analytics Using SQL Server
File: 05_provider_specialty_analysis.sql
Author: Esther Akinniyi
Database: Healthcare_DB

Description:
Analyzes payments by physician specialty and monthly
payment trends for the highest-performing specialty.
==========================================================
*/

USE Healthcare_DB;
GO

/*
Question 1:
Which physician specialty received the highest total
payments?
*/

SELECT
    phy.ProviderSpecialty,
    FORMAT(-SUM(ft.Payment), '$#,##0') AS Total_Payments
FROM FactTable AS ft
INNER JOIN dimPhysician AS phy
    ON phy.dimPhysicianPK = ft.dimPhysicianPK
GROUP BY
    phy.ProviderSpecialty
ORDER BY
    -SUM(ft.Payment) DESC;


/*
Question 2:
Show monthly payments for Internal Medicine.
*/

SELECT
    dt.MonthYear,
    FORMAT(-SUM(ft.Payment), '$#,##0') AS Monthly_Payments
FROM FactTable AS ft
INNER JOIN dimPhysician AS phy
    ON phy.dimPhysicianPK = ft.dimPhysicianPK
INNER JOIN dimDate AS dt
    ON dt.dimDatePostPK = ft.dimDatePostPK
WHERE phy.ProviderSpecialty = 'Internal Medicine'
GROUP BY
    dt.MonthYear,
    dt.MonthPeriod
ORDER BY
    dt.MonthPeriod ASC;


/*
Question 3:
Show monthly payments with specialty detail.
*/

SELECT
    phy.ProviderSpecialty,
    dt.MonthYear,
    FORMAT(-SUM(ft.Payment), '$#,##0') AS Monthly_Payments
FROM FactTable AS ft
INNER JOIN dimPhysician AS phy
    ON phy.dimPhysicianPK = ft.dimPhysicianPK
INNER JOIN dimDate AS dt
    ON dt.dimDatePostPK = ft.dimDatePostPK
WHERE phy.ProviderSpecialty = 'Internal Medicine'
GROUP BY
    phy.ProviderSpecialty,
    dt.MonthYear,
    dt.MonthPeriod
ORDER BY
    dt.MonthPeriod ASC;
