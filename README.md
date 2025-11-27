# 📘 Data Warehouse Design

---

## 📌 Project Overview
This project builds a data warehouse from an existing OLTP schema.

1. Create the OLTP database (CA29707406) using the provided OLTP_create.sql and load cleaned source data.
2. Design a dimensional data warehouse (star/snowflake) and create it in CA2DW9707406.
3. ETL data from OLTP → DW (implement surrogate keys; day-level time dimension).
4. Produce analytical SQL queries to extract insights on consultation durations, utilization, seasonality and outliers.

## 🗂️ Repository structure

<pre> <code> 
/ (root)
├─ README.md                      <- (this file)
├─ OLTP_create.sql                <- given (do NOT modify)
├─ OLTP_insert.sql                <- your INSERTs / cleaned CSVs (submit)
├─ DW_create.sql                  <- CREATE TABLE statements for DW
├─ DW_insert.sql                  <- ETL / INSERT statements from OLTP → DW
├─ DW_query.sql                   <- Analytical queries + comments
├─ data/
│  ├─ appointment.xlsx
│  ├─ patient.xlsx
│  ├─ staff.csv
│  └─ facility.docx                  
└─ docs/
   ├─ ERD_OLTP.png                <- screenshot of OLTP Workbench reverse-engineer              
   └─ ERD_DW.png                  <- screenshot of DW Workbench reverse-engineer
</code> </pre>

---

## 1️⃣ Setup & run order

Create OLTP database and tables by executing `OLTP_create.sql`
Load cleaned data into OLTP by executing `OLTP_insert.sql`
Create DW database & tables by executing `DW_create.sql`
Run ETL (`DW_insert.sql`) to populate DW dimension(s) and fact table(s).

