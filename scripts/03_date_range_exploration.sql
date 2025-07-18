/*
===============================================================================
Date Range Exploration 
===============================================================================
Tujuan
    - Untuk menentukan batas-batas temporal dari titik-titik data utama.
    - Untuk memahami rentang data historis.

Fungsi SQL yang Digunakan:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Tentukan first order dan last order serta total durasi dalam bulan
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
FROM gold.fact_sales;

-- Temukan pelanggan termuda dan tertua berdasarkan tanggal lahir
SELECT
    MIN(birthdate) AS oldest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers;
