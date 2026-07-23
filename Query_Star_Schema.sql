-- Star Schema Query
--3 Sederhana
--1.
ALTER SYSTEM FLUSH BUFFER_CACHE;
SET TIMING ON;
SELECT SUM(total_harga) AS total_pendapatan 
FROM transaksi;
--2.
ALTER SYSTEM FLUSH BUFFER_CACHE;
SET TIMING ON;
SELECT MAX(total_harga) AS penjualan_tertinggi, MIN(total_harga) AS penjualan_terendah 
FROM transaksi;
--3.
ALTER SYSTEM FLUSH BUFFER_CACHE;
SET TIMING ON;
SELECT AVG(jumlah) AS rata_rata_kuantitas 
FROM transaksi;

--3 Menengah
--1.
ALTER SYSTEM FLUSH BUFFER_CACHE;
SET TIMING ON;
SELECT COUNT(transaksi_id) AS trx_barang_mahal 
FROM transaksi 
WHERE harga_barang > 50000;
--2.
ALTER SYSTEM FLUSH BUFFER_CACHE;
SET TIMING ON;
SELECT SUM(total_harga) AS pendapatan_toko 
FROM transaksi 
WHERE lokasi_pembelian_lp_key = 1;
--3.
ALTER SYSTEM FLUSH BUFFER_CACHE;
SET TIMING ON;
SELECT SUM(jumlah) AS kuantitas_produk 
FROM transaksi 
WHERE produk_produk_key = 1;

--3 Kompleks
--1.
ALTER SYSTEM FLUSH BUFFER_CACHE;
SET TIMING ON;
SELECT p.produk, SUM(f.total_harga) AS total_pendapatan, SUM(f.jumlah) AS total_barang 
FROM transaksi f 
JOIN produk p ON f.produk_produk_key = p.produk_key 
JOIN waktu w ON f.waktu_waktu_key = w.waktu_key 
WHERE w.tahun = 2023 
GROUP BY p.produk;
--2.
ALTER SYSTEM FLUSH BUFFER_CACHE;
SET TIMING ON;
SELECT l.lokasi_pembelian, AVG(f.total_harga) AS rata_penjualan FROM transaksi f 
JOIN lokasi_pembelian l ON f.lokasi_pembelian_lp_key = l.lp_key 
JOIN metode_pembayaran m ON f.metode_pembayaran_metode_key = m.metode_key 
WHERE m.metode_pembayaran = 'Cash' 
GROUP BY l.lokasi_pembelian;
--3.
ALTER SYSTEM FLUSH BUFFER_CACHE;
SET TIMING ON;
SELECT p.produk, m.metode_pembayaran, SUM(f.total_harga) AS total_pendapatan 
FROM transaksi f 
JOIN produk p ON f.produk_produk_key = p.produk_key 
JOIN metode_pembayaran m ON f.metode_pembayaran_metode_key = m.metode_key 
JOIN waktu w ON f.waktu_waktu_key = w.waktu_key 
WHERE w.bulan IN (1, 2, 3) 
GROUP BY p.produk, m.metode_pembayaran;
