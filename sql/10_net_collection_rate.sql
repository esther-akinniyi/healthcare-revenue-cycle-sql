/*
==========================================================
Healthcare Revenue Cycle Analytics Using SQL Server
File: 10_net_collection_rate.sql
Author: Esther Akinniyi
Database: Healthcare_DB

Description:
Calculates net charges, net collection rates, accounts
receivable percentages, and write-off percentages by
physician specialty.
==========================================================
*/

USE Healthcare_DB;
GO

/*
Formula definitions:

Net Charge =
Gross Charges + Contractual Adjustments

Net Collection Rate =
Payments / Net Charge

Percent in AR =
Accounts Receivable / Net Charge

Write-Off Percentage =
Non-contractual Adjustments / Net Charge
*/

WITH Specialty_Financials AS (
    SELECT
        phy.ProviderSpecialty,
        SUM(ft.GrossCharge) AS Gross_Charges,
        SUM(
            CASE
                WHEN txn.AdjustmentReason = 'Contractual'
                    THEN ft.Adjustment
                ELSE 0
            END
        ) AS Contractual_Adjustments,
        SUM(ft.GrossCharge)
        + SUM(
            CASE
                WHEN txn.AdjustmentReason = 'Contractual'
                    THEN ft.Adjustment
                ELSE 0
            END
        ) AS Net_Charges,
        SUM(ft.Payment) AS Payments,
        SUM(ft.Adjustment) AS Total_Adjustments,
        SUM(ft.AR) AS Accounts_Receivable
    FROM FactTable AS ft
    INNER JOIN dimPhysician AS phy
        ON phy.dimPhysicianPK = ft.dimPhysicianPK
    INNER JOIN dimTransaction AS txn
        ON txn.dimTransactionPK = ft.dimTransactionPK
    GROUP BY
        phy.ProviderSpecialty
)

SELECT
    ProviderSpecialty,
    FORMAT(Gross_Charges, '$#,##0') AS Gross_Charges,
    FORMAT(Contractual_Adjustments, '$#,##0')
        AS Contractual_Adjustments,
    FORMAT(Net_Charges, '$#,##0') AS Net_Charges,
    FORMAT(Payments, '$#,##0') AS Payments,
    FORMAT(
        Total_Adjustments - Contractual_Adjustments,
        '$#,##0'
    ) AS Non_Contractual_Adjustments,
    FORMAT(
        -Payments / NULLIF(Net_Charges, 0),
        'P0'
    ) AS Net_Collection_Rate,
    FORMAT(Accounts_Receivable, '$#,##0')
        AS Accounts_Receivable,
    FORMAT(
        Accounts_Receivable / NULLIF(Net_Charges, 0),
        'P0'
    ) AS Percent_In_AR,
    FORMAT(
        -(Total_Adjustments - Contractual_Adjustments)
        / NULLIF(Net_Charges, 0),
        'P0'
    ) AS Write_Off_Percentage
FROM Specialty_Financials
WHERE Net_Charges > 25000
ORDER BY
    -Payments / NULLIF(Net_Charges, 0) ASC;


/*
Key finding:
Obstetrics & Gynecology had the lowest Net Collection Rate
among specialties with Net Charges greater than $25,000.

Business interpretation:
Approximately 83% of net charges were collected, 16%
remained in accounts receivable, and approximately 1%
was written off for non-contractual adjustment reasons.
*/
