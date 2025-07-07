/*
===============================================================================
Analisis Kinerja (Tahun ke Tahun, Bulan ke Bulan)
===============================================================================
Tujuan
    - Untuk mengukur performa produk, pelanggan, atau wilayah dari waktu ke waktu.
    - Untuk Membandingksn dan mengidentifikasi entitas berkinerja tinggi.
    - Untuk melacak tren dan pertumbuhan tahunan.

Fungsi SQL yang digunakan:
    - LAG(): Accesses data dari baris sebelumnya
    - AVG() OVER(): Menghitung nilai rata-rata dalam partisi.
    - CASE: Mendefinisikan conditional logic untuk analisis tren.
===============================================================================
*/

/* Menganalisis kinerja tahunan produk dengan membandingkan penjualannya
dengan kinerja penjualan rata-rata produk dan penjualan tahun sebelumnya */
WITH yearly_product_sales AS (
    SELECT
        YEAR(f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY 
        YEAR(f.order_date),
        p.product_name
)
SELECT
    order_year,
    product_name,
    current_sales,
    AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
    CASE 
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_change,
    -- Year-over-Year Analysis
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS py_sales,
    current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py,
    CASE 
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS py_change
FROM yearly_product_sales
ORDER BY product_name, order_year;
