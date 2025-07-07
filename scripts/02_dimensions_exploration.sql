
/*
===============================================================================
Dimensions Exploration
===============================================================================
Tujuan:    
	- Untuk mengeksplorasi struktur tabel dimensi.
	
Fungsi SQL yang digunakan:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- Mengambil daftar negara unik tempat asal pelanggan
SELECT DISTINCT 
    country 
FROM gold.dim_customers
ORDER BY country;


--Mengambil daftar kategori, subkategori, dan produk yang unik
SELECT DISTINCT 
    category, 
    subcategory, 
    product_name 
FROM gold.dim_products
ORDER BY category, subcategory, product_name;
