# Data Dictionary

## Overview

This project uses a simulated healthcare revenue cycle database containing transactional, financial, provider, payer, and patient information. The tables are organized using a star-schema design with one central fact table and multiple dimension tables.

---

# Fact Table

## FactTable

Contains transactional healthcare billing and financial records.

### Key Fields

| Field | Description |
|--------|-------------|
| PatientNumber | Unique patient identifier |
| GrossCharge | Total charge billed for a healthcare service |
| Payment | Payment received from payer or patient |
| Adjustment | Financial adjustment applied to the claim |
| AR | Remaining Accounts Receivable balance |
| CptUnits | Number of procedure units billed |
| dimPatientPK | Foreign key to Patient dimension |
| dimPhysicianPK | Foreign key to Physician dimension |
| dimPayerPK | Foreign key to Payer dimension |
| dimLocationPK | Foreign key to Location dimension |
| dimCPTCodePK | Foreign key to CPT Code dimension |
| dimDiagnosisCodePK | Foreign key to Diagnosis dimension |
| dimTransactionPK | Foreign key to Transaction dimension |
| dimDatePostPK | Foreign key to Date dimension |

---

# Dimension Tables

## dimPatient

Stores patient demographic information.

### Examples

- Patient Number
- First Name
- Last Name
- Gender
- Date of Birth
- Age
- City
- State
- Email Address

---

## dimPhysician

Stores provider information.

### Examples

- Provider NPI
- Provider Name
- Provider Specialty

---

## dimPayer

Stores insurance payer information.

### Examples

- Payer Name
- Insurance Type

---

## dimLocation

Stores healthcare facility information.

### Examples

- Hospital Name
- Clinic Name
- Healthcare Location

---

## dimCPTCode

Stores CPT procedure information.

### Examples

- CPT Code
- CPT Description
- CPT Grouping

---

## dimDiagnosisCode

Stores diagnosis information.

### Examples

- ICD Diagnosis Code
- Diagnosis Description
- Diagnosis Group

---

## dimTransaction

Stores billing transaction details.

### Examples

- Adjustment Reason
- Transaction Type

---

## dimDate

Stores calendar information used for reporting.

### Examples

- Date
- Month
- Month Year
- Year
- Fiscal Period

---

# Financial Metrics Used

## Gross Charge

Total amount billed for healthcare services before adjustments.

---

## Payment

Amount collected from insurance payers or patients.

---

## Adjustment

Reduction applied to billed charges due to contractual agreements, credentialing issues, or other financial reasons.

---

## Gross Collection Rate

**Formula**

Gross Collection Rate = Payments ÷ Gross Charges

Measures the percentage of billed charges successfully collected.

---

## Net Charge

**Formula**

Net Charge = Gross Charges + Contractual Adjustments

Represents collectible charges after contractual reductions.

---

## Net Collection Rate

**Formula**

Net Collection Rate = Payments ÷ Net Charges

Measures how effectively collectible revenue is collected.

---

## Accounts Receivable (AR)

Outstanding balance that has not yet been collected.

---

## Credentialing Adjustment

Financial adjustment resulting from provider credentialing issues with insurance payers.

---

## CPT Units

Number of billable units associated with a procedure code.

---

# Disclaimer

This project uses a simulated healthcare database created for educational purposes only. No real patient information or protected health information (PHI) is included.
