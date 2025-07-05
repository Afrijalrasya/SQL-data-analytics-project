/*
===============================================================================
Laporan Kostumer
===============================================================================
Tujuan : 
    - Laporan ini mengkonsolidasikan metrik dan perilaku pelanggan utama

Sorotan:
    1. Mengumpulkan bidang-bidang penting seperti nama, usia, dan detail transaksi.
	2. Mensegmentasi pelanggan ke dalam kategori (VIP, Reguler, Baru) dan kelompok usia.
    3. Mengumpulkan metrik tingkat pelanggan:
	   - total pesanan
	   - total penjualan
	   - jumlah total yang dibeli
	   - total produk
	   - masa pakai (dalam bulan)
    4. Menghitung valuable KPI:
	    - kemutakhiran (bulan sejak pesanan terakhir)
		- nilai pesanan rata-rata
		- rata-rata pengeluaran bulanan


===============================================================================
*/

-- =============================================================================
-- Membuat laporan: gold.report_customers
-- =============================================================================
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers AS

WITH base_query AS(
/*---------------------------------------------------------------------------
1) Base Query: Mengambil kolom inti dari tabel
---------------------------------------------------------------------------*/
SELECT
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_number,
CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
DATEDIFF(year, c.birthdate, GETDATE()) AS umur
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
on c.customer_key = f.customer_key
WHERE order_date IS NOT NULL
)

,customer_aggregation AS (
/*---------------------------------------------------------------------------
2) Customer Aggregations: Meringkas kunci metrik pada level customer
---------------------------------------------------------------------------*/
SELECT
customer_key,
customer_number,
customer_name,
Case WHEN umur < 20 THEN 'Dibawah 20 Tahun'
	 WHEN umur BETWEEN 20 AND 29 THEN'20-29'
	 WHEN umur BETWEEN 30 AND 39 THEN'30-39'
	 WHEN umur BETWEEN 40 AND 49 THEN'40-49'
	 ELSE 'Diatas 50 tahun'
END as umur,
COUNT(DISTINCT order_number) AS total_pesanan,
SUM(sales_amount) AS total_Penjualan,
SUM(quantity) AS total_yang_dibeli,
COUNT(DISTINCT product_key) AS total_produk,
MAX(order_date) AS last_order_date,
DATEDIFF(month, MIN(order_date), MAX(order_date)) AS masa_aktif
FROM base_query
group by customer_key, customer_number, customer_name, umur
)

SELECT
	customer_key,
	customer_number,
	customer_name,
	umur,
	 CASE 
          WHEN masa_aktif  >= 12 AND total_penjualan> 5000 THEN 'VIP'
          WHEN masa_aktif >= 12 AND total_penjualan <= 5000 THEN 'Regular'
          ELSE 'New'
    END AS customer_segment,
	DATEDIFF(month, last_order_date, GETDATE()) AS recency,
	total_pesanan,
	total_Penjualan,
	total_yang_dibeli,
	total_produk,
	masa_aktif,
	-- menghitung Average value order (AVO)
	CASE WHEN total_pesanan = 0 then '0'
	ELSE total_penjualan / total_pesanan
	END AS avg_order_value,

	-- Menghitung Average monthly spend
	CASE WHEN masa_aktif = 0 THEN total_penjualan
		 ELSE total_penjualan / masa_aktif
	END as avg_monthly_spend
FROM customer_aggregation
