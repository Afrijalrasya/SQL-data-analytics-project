/*
===============================================================================
Cumulative Analysis
===============================================================================
Tujuan:
    - Untuk menghitung total berjalan atau rata-rata yang begerak untuk metrik utama.
    - Untuk melacak kinerja dari waktu ke waktu secara kumulatif.
    - Berguna untuk analisis pertumbuhan atau mengidentifikasi tren jangka panjang.
Fungsi SQL yang digunakan:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- Menghitung total penjualan perbulan 
-- dan total penjualan yang sedang berjalan dari waktu ke waktu
SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
	AVG(avg_price) OVER (ORDER BY order_date) AS moving_average_price
FROM
(
    SELECT 
        DATETRUNC(year, order_date) AS order_date,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(year, order_date)
) t
