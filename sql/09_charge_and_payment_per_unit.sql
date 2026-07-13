/*
==========================================================
Healthcare Revenue Cycle Analytics Using SQL Server
File: 09_charge_and_payment_per_unit.sql
Author: Esther Akinniyi
Database: Healthcare_DB

Description:
Compares charges and payments per CPT unit for outpatient
and hospital care services.
==========================================================
*/

USE Healthcare_DB;
GO

/*
Question 1:
Calculate charge per CPT unit for established and new
office/outpatient visits.
*/

SELECT
    cpt.CptCode,
    cpt.CptDesc,
    SUM(ft.CptUnits) AS Total_CPT_Units,
    FORMAT(
        SUM(ft.GrossCharge) /
        NULLIF(SUM(ft.CptUnits), 0),
        '$#,##0.00'
    ) AS Charge_Per_Unit
FROM FactTable AS ft
INNER JOIN dimCptCode AS cpt
    ON cpt.dimCPTCodePK = ft.dimCPTCodePK
WHERE cpt.CptDesc IN (
    'Office/outpatient visit est',
    'Office/outpatient visit new'
)
GROUP BY
    cpt.CptCode,
    cpt.CptDesc
ORDER BY
    cpt.CptCode;


/*
Question 2:
Calculate payment per CPT unit by payer for initial
hospital care.
*/

SELECT
    cpt.CptCode,
    cpt.CptDesc,
    pay.PayerName,
    SUM(ft.CptUnits) AS Total_CPT_Units,
    FORMAT(
        -SUM(ft.Payment) /
        NULLIF(SUM(ft.CptUnits), 0),
        '$#,##0.00'
    ) AS Payment_Per_Unit
FROM FactTable AS ft
INNER JOIN dimCptCode AS cpt
    ON cpt.dimCPTCodePK = ft.dimCPTCodePK
INNER JOIN dimPayer AS pay
    ON pay.dimPayerPK = ft.dimPayerPK
WHERE cpt.CptDesc = 'Initial hospital care'
GROUP BY
    cpt.CptCode,
    cpt.CptDesc,
    pay.PayerName
ORDER BY
    cpt.CptCode,
    -SUM(ft.Payment) / NULLIF(SUM(ft.CptUnits), 0) DESC;


/*
Question 3:
Compare payment per unit by payer for CPT code 99223.
*/

SELECT
    cpt.CptCode,
    cpt.CptDesc,
    pay.PayerName,
    SUM(ft.CptUnits) AS Total_CPT_Units,
    FORMAT(
        -SUM(ft.Payment) /
        NULLIF(SUM(ft.CptUnits), 0),
        '$#,##0.00'
    ) AS Payment_Per_Unit
FROM FactTable AS ft
INNER JOIN dimCptCode AS cpt
    ON cpt.dimCPTCodePK = ft.dimCPTCodePK
INNER JOIN dimPayer AS pay
    ON pay.dimPayerPK = ft.dimPayerPK
WHERE cpt.CptDesc = 'Initial hospital care'
  AND cpt.CptCode = '99223'
GROUP BY
    cpt.CptCode,
    cpt.CptDesc,
    pay.PayerName
ORDER BY
    -SUM(ft.Payment) / NULLIF(SUM(ft.CptUnits), 0) DESC;
