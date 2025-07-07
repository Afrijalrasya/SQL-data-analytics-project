m/*
===============================================================================
Laporan Produk
===============================================================================
Tujuan
    - Laporan ini mengkonsolidasikan metrik dan behaviour produk utama.

Sorotan:
    1. Mengumpulkan bidang-bidang penting seperti nama produk, kategori, subkategori, dan biaya.
    2. Mensegmentasi produk berdasarkan pendapatan untuk mengidentifikasi produk Berkinerja Tinggi, Berkinerja Menengah, atau Berkinerja Rendah.
    3. Mengumpulkan metrik tingkat produk:
       - total pesanan
       - total penjualan
       - jumlah total yang terjual
       - total pelanggan (unik)
       - masa pakai (dalam bulan)
    4. Menghitung KPI yang berharga:
       - kemutakhiran (bulan sejak penjualan terakhir)
       - pendapatan pesanan rata-rata (AOR)
       - pendapatan bulanan rata-rata


===============================================================================
*/
-- =============================================================================
-- Create Report: gold.report_products
-- =============================================================================
IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS

WITH base_query AS (
/*---------------------------------------------------------------------------
1) Base Query: Mengambil kolom inti dari fact_sales dan dim_products
---------------------------------------------------------------------------*/

SELECT
f.order_number,
f.order_date,
f.customer_key,
f.sales_amount,
f.quantity,
p.product_key,
p.product_name,
p.category,
p.subcategory,
p.cost
FROM gold.fact_sales f
LEFT join gold.dim_products p
on f.product_key = p.product_key
where order_date is not null
), 
 product_aggregation as(
/*---------------------------------------------------------------------------
2) Agregasi Produk: Merangkum metrik utama di tingkat produk
---------------------------------------------------------------------------*/
SELECT
product_key,
product_name,
category,
subcategory,
cost,
DATEDIFF(month, MIN(order_date), MAX(order_date)) as masa_aktif,
max(order_date) as Last_sale_date,
COUNT(DISTINCT order_date) total_pesanan,
COUNT(distinct customer_key) as total_customer,
sum(sales_amount) as total_penjualan,
SUM(quantity) as total_quantity,
round(avg(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS rata_rata_harga_penjualan
FROM base_query

group by
	product_key,
	product_name,
	category,
	subcategory,
	cost
)

/*---------------------------------------------------------------------------
  3) Final Query: Menggabungkan semua hasil produk menjadi satu output
---------------------------------------------------------------------------*/
SELECT
product_key,
product_name,
category,
subcategory,
cost,
Last_sale_date,
DATEDIFF(month, last_sale_date, GETDATE()) as bulan_sejak_penjualan_terakhir,
CASE WHEN total_penjualan > 50000 THEN 'High-performer'
	 WHEN total_penjualan >= 10000 THEN 'mid-performer'
	 ELSE 'low-performer'
end as segmen_produk,
masa_aktif,
total_pesanan,
total_customer,
total_penjualan,
total_quantity,
rata_rata_harga_penjualan,

-- rata-rata pendapatan pesanan
CASE WHEN total_pesanan = 0 THEN 0
	 ELSE total_penjualan / total_pesanan
end as pendapatan_perpesanan_rata_rata,

-- rata rata pendapatan bulanan
CASE WHEN masa_aktif = 0 THEN 0
	 ELSE total_penjualan / masa_aktif
END as Rata_rata_pendapatan_bulanan
from product_aggregation
