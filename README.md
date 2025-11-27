📘 Hospital Data Warehouse Project
Data Engineering / Data Warehousing

📌 Project Overview
This project builds a data warehouse from an existing OLTP schema for a large urban hospital.

1. Create the OLTP database (CA29707406) using the provided OLTP_create.sql and load cleaned source data.
2. Design a dimensional data warehouse (star/snowflake) and create it in CA2DW9707406.
3. ETL data from OLTP → DW (implement surrogate keys; day-level time dimension).
4. Produce analytical SQL queries to extract insights on consultation durations, utilization, seasonality and outliers.

Repository structure

🏥 Business Scenario Summary
The hospital has expanded rapidly and requires centralised data integration across departments. Key operational data includes:
Patient Information
Doctor Information & Department Structure
Appointments & Scheduling
Room Allocation
Medical Records
The goal:
Enable efficient real-time operations in OLTP and long-term analytics in DW.
The analytics focus includes:
Seasonal consultation patterns
Doctor performance based on consultation duration
Patient visit duration trends
Room utilisation
Identification of outliers and bottlenecks
