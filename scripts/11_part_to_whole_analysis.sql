/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Tujuan
    - Untuk membandingkan kinerja atau metrik di seluruh dimensi atau periode waktu.
    - Untuk mengevaluasi perbedaan antar kategori.
    - Berguna untuk pengujian A/B atau perbandingan regional.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
-- Which categories contribute the most to overall sales?
-- Kategori mana yang paling banyak berkontribusi terhadap penjualan secara keseluruhan?
use DataWarehouseAnalytics

with sales_per_category AS (
SELECT
p.category,
SUM (f.sales_amount) as total_sales
from gold.fact_sales f
LEFT JOIN gold.dim_products p
on p.product_key = f.product_key
group by category
)
select
category,
total_sales, 
sum(total_sales) over () overall_sales,
CONCAT(
	ROUND((CAST(total_sales AS float) / SUM(total_sales) OVER ())* 100, 2),
	'%'
) AS presentasi_total
from sales_per_category 