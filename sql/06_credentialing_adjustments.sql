/*
==========================================================
Healthcare Revenue Cycle Analytics Using SQL Server
File: 06_credentialing_adjustments.sql
Author: Esther Akinniyi
Database: Healthcare_DB

Description:
Analyzes financial write-offs caused by provider
credentialing issues and identifies impacted locations
and physicians.
==========================================================
*/

USE Healthcare_DB;
GO

/*
Question 1:
How many dollars were written off because of credentialing?
*/

SELECT
    FORMAT(-SUM(ft.Adjustment), '$#,##0')
        AS Credentialing_Write_Off
FROM FactTable AS ft
INNER JOIN dimTransaction AS txn
    ON txn.dimTransactionPK = ft.dimTransactionPK
WHERE txn.AdjustmentReason = 'Credentialing';


/*
Question 2:
Which location had the highest credentialing write-off?
*/

SELECT
    loc.LocationName,
    FORMAT(-SUM(ft.Adjustment), '$#,##0')
        AS Credentialing_Write_Off
FROM FactTable AS ft
INNER JOIN dimTransaction AS txn
    ON txn.dimTransactionPK = ft.dimTransactionPK
INNER JOIN dimLocation AS loc
    ON loc.dimLocationPK = ft.dimLocationPK
WHERE txn.AdjustmentReason = 'Credentialing'
GROUP BY
    loc.LocationName
ORDER BY
    -SUM(ft.Adjustment) DESC;


/*
Question 3:
How many physicians were affected by credentialing
adjustments at each location?
*/

SELECT
    loc.LocationName,
    COUNT(DISTINCT phy.ProviderNpi) AS Affected_Physicians,
    FORMAT(-SUM(ft.Adjustment), '$#,##0')
        AS Credentialing_Write_Off
FROM FactTable AS ft
INNER JOIN dimTransaction AS txn
    ON txn.dimTransactionPK = ft.dimTransactionPK
INNER JOIN dimLocation AS loc
    ON loc.dimLocationPK = ft.dimLocationPK
INNER JOIN dimPhysician AS phy
    ON phy.dimPhysicianPK = ft.dimPhysicianPK
WHERE txn.AdjustmentReason = 'Credentialing'
GROUP BY
    loc.LocationName
ORDER BY
    -SUM(ft.Adjustment) DESC;


/*
Question 4:
Identify affected physicians at Angelstone Community
Hospital.
*/

SELECT DISTINCT
    phy.ProviderNpi,
    phy.ProviderName
FROM FactTable AS ft
INNER JOIN dimTransaction AS txn
    ON txn.dimTransactionPK = ft.dimTransactionPK
INNER JOIN dimLocation AS loc
    ON loc.dimLocationPK = ft.dimLocationPK
INNER JOIN dimPhysician AS phy
    ON phy.dimPhysicianPK = ft.dimPhysicianPK
WHERE txn.AdjustmentReason = 'Credentialing'
  AND loc.LocationName = 'Angelstone Community Hospital'
ORDER BY
    phy.ProviderName;


/*
Question 5:
Show credentialing write-offs by physician.
*/

SELECT
    phy.ProviderNpi,
    phy.ProviderName,
    FORMAT(-SUM(ft.Adjustment), '$#,##0')
        AS Credentialing_Write_Off
FROM FactTable AS ft
INNER JOIN dimTransaction AS txn
    ON txn.dimTransactionPK = ft.dimTransactionPK
INNER JOIN dimLocation AS loc
    ON loc.dimLocationPK = ft.dimLocationPK
INNER JOIN dimPhysician AS phy
    ON phy.dimPhysicianPK = ft.dimPhysicianPK
WHERE txn.AdjustmentReason = 'Credentialing'
  AND loc.LocationName = 'Angelstone Community Hospital'
GROUP BY
    phy.ProviderNpi,
    phy.ProviderName
ORDER BY
    -SUM(ft.Adjustment) DESC;


/*
Business interpretation:
Credentialing adjustments represent revenue lost because
providers were not properly credentialed with insurance
payers. The organization should review affected providers
and complete credentialing requirements promptly.
*/
