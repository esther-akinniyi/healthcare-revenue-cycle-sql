/*
==========================================================
Healthcare Revenue Cycle Analytics Using SQL Server
File: 04_payer_and_payment_analysis.sql
Author: Esther Akinniyi
Database: Healthcare_DB

Description:
Evaluates gross collection rates, payer activity, and
payment performance across healthcare locations.
==========================================================
*/

USE Healthcare_DB;
GO

/*
Question 1:
Calculate the Gross Collection Rate for each location.

Formula:
Gross Collection Rate = Payments / Gross Charges
*/

SELECT
    loc.LocationName,
    -SUM(ft.Payment) / NULLIF(SUM(ft.GrossCharge), 0)
        AS Gross_Collection_Rate
FROM FactTable AS ft
INNER JOIN dimLocation AS loc
    ON loc.dimLocationPK = ft.dimLocationPK
GROUP BY
    loc.LocationName
ORDER BY
    Gross_Collection_Rate DESC;


/*
Formatted Gross Collection Rate report.
*/

SELECT
    loc.LocationName,
    FORMAT(
        -SUM(ft.Payment) / NULLIF(SUM(ft.GrossCharge), 0),
        'P1'
    ) AS Gross_Collection_Rate
FROM FactTable AS ft
INNER JOIN dimLocation AS loc
    ON loc.dimLocationPK = ft.dimLocationPK
GROUP BY
    loc.LocationName
ORDER BY
    -SUM(ft.Payment) / NULLIF(SUM(ft.GrossCharge), 0) DESC;


/*
Key finding:
Twin Mountains Hospital had the highest Gross Collection
Rate at approximately 63.4%.
*/


/*
Question 2:
Show total payments by payer.
*/

SELECT
    pay.PayerName,
    FORMAT(-SUM(ft.Payment), '$#,##0') AS Total_Payments
FROM FactTable AS ft
INNER JOIN dimPayer AS pay
    ON pay.dimPayerPK = ft.dimPayerPK
GROUP BY
    pay.PayerName
ORDER BY
    -SUM(ft.Payment) DESC;
