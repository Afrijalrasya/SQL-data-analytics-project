/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Tujuan:
    - Untuk menghitung metrik agregat (misalnya, total, rata-rata) untuk mendapatkan insight cepat.
    - Untuk mengidentifikasi tren secara keseluruhan atau menemukan anomali.
SQL Functions yang digunakan:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Menghitung Total Sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales
 
--Mencari tahu berapa banyak item yang terjual
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales

-- Temukan rata rata harga jual
SELECT AVG(price) AS avg_price FROM gold.fact_sales

-- Temukan Jumlah Total Pesanan
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales

-- Temukan jumlah total produk
SELECT COUNT(product_name) AS total_products FROM gold.dim_products

-- Temukan jumlah total customer
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers;

-- Temukan jumlah total pelanggan yang telah melakukan pemesanan
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.fact_sales;

-- Membuat Laporan yang menunjukkan semua metrik utama bisnis
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Customers', COUNT(customer_key) FROM gold.dim_customers;
