/*
==========================================================
Healthcare Revenue Cycle Analytics Using SQL Server
File: 03_cpt_utilization.sql
Author: Esther Akinniyi
Database: Healthcare_DB

Description:
Analyzes CPT code utilization, procedure units, CPT
groupings, and diagnosis-related procedure activity.
==========================================================
*/

USE Healthcare_DB;
GO

/*
Question 1:
Which CPT codes have more than 100 total units?
*/

SELECT
    cpt.CptCode,
    cpt.CptDesc,
    SUM(ft.CptUnits) AS Total_CPT_Units
FROM FactTable AS ft
INNER JOIN dimCptCode AS cpt
    ON cpt.dimCPTCodePK = ft.dimCPTCodePK
GROUP BY
    cpt.CptCode,
    cpt.CptDesc
HAVING
    SUM(ft.CptUnits) > 100
ORDER BY
    Total_CPT_Units DESC;


/*
Question 2:
How many CPT codes have more than 100 total units?
*/

SELECT
    COUNT(*) AS CPT_Codes_Over_100_Units
FROM (
    SELECT
        cpt.CptCode
    FROM FactTable AS ft
    INNER JOIN dimCptCode AS cpt
        ON cpt.dimCPTCodePK = ft.dimCPTCodePK
    GROUP BY
        cpt.CptCode
    HAVING
        SUM(ft.CptUnits) > 100
) AS CPT_Utilization;


/*
Question 3:
How many CPT units are associated with diagnosis codes
beginning with the letter J?
*/

SELECT
    diag.DiagnosisCodeGroup,
    SUM(ft.CptUnits) AS Total_CPT_Units
FROM FactTable AS ft
INNER JOIN dimDiagnosisCode AS diag
    ON diag.dimDiagnosisCodePK = ft.dimDiagnosisCodePK
WHERE diag.DiagnosisCode LIKE 'J%'
GROUP BY
    diag.DiagnosisCodeGroup
ORDER BY
    Total_CPT_Units DESC;


/*
Question 4:
Show J-code utilization by individual diagnosis code.
*/

SELECT
    diag.DiagnosisCode,
    diag.DiagnosisCodeGroup,
    SUM(ft.CptUnits) AS Total_CPT_Units
FROM FactTable AS ft
INNER JOIN dimDiagnosisCode AS diag
    ON diag.dimDiagnosisCodePK = ft.dimDiagnosisCodePK
WHERE diag.DiagnosisCode LIKE 'J%'
GROUP BY
    diag.DiagnosisCode,
    diag.DiagnosisCodeGroup
ORDER BY
    Total_CPT_Units DESC;
