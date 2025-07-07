/*
===============================================================================
Database Exploration
===============================================================================

Tujuan:
    - Untuk eksplor struktur database, termasuk daftar tabel dan skemanya.
    - Untuk memeriksa kolom dan metadata untuk tabel tertentu.

Tabel yang Digunakan:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

-- Mengambil daftar semua tabel dalam database
SELECT 
    TABLE_CATALOG, 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES;

-- Mengambil semua kolom untuk tabel tertentu (dim_customers)
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';
