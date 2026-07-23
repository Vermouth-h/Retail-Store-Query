-- ERD Query
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
FROM detail_transaksi;

--3 menengah
--1.
ALTER SYSTEM FLUSH BUFFER_CACHE;
SET TIMING ON;
SELECT COUNT(transaksi_transaksi_id) AS trx_barang_mahal 
FROM detail_transaksi 
WHERE harga_barang > 50000;
--2.
ALTER SYSTEM FLUSH BUFFER_CACHE;
SET TIMING ON;
SELECT SUM(total_harga) AS pendapatan_toko 
FROM transaksi 
WHERE lokasi_pembelian_lp_id = 'L01';
--3.
ALTER SYSTEM FLUSH BUFFER_CACHE;
SET TIMING ON;
SELECT SUM(dt.jumlah) AS kuantitas_produk 
FROM detail_transaksi dt 
JOIN transaksi t ON dt.transaksi_transaksi_id = t.transaksi_id 
WHERE t.produk_produk_id = 'P001';

--3 Kompleks
--1.
ALTER SYSTEM FLUSH BUFFER_CACHE;
SET TIMING ON;
SELECT p.produk, SUM(t.total_harga) AS total_pendapatan, SUM(dt.jumlah) AS total_barang 
FROM transaksi t JOIN detail_transaksi dt ON t.transaksi_id = dt.transaksi_transaksi_id 
JOIN produk p ON t.produk_produk_id = p.produk_id 
WHERE EXTRACT(YEAR FROM t.tanggal_transaksi) = 2023 
GROUP BY p.produk;
--2.
ALTER SYSTEM FLUSH BUFFER_CACHE;
SET TIMING ON;
SELECT l.lokasi_pembelian, AVG(t.total_harga) AS rata_penjualan 
FROM transaksi t 
JOIN lokasi_pembelian l ON t.lokasi_pembelian_lp_id = l.lp_id 
JOIN metode_pembayaran m ON t.metode_pembayaran_metode_id = m.metode_id 
WHERE m.metode_pembayaran = 'Cash' 
GROUP BY l.lokasi_pembelian;
--3.
ALTER SYSTEM FLUSH BUFFER_CACHE;
SET TIMING ON;
SELECT p.produk, m.metode_pembayaran, SUM(t.total_harga) AS total_pendapatan 
FROM transaksi t 
JOIN produk p ON t.produk_produk_id = p.produk_id 
JOIN metode_pembayaran m ON t.metode_pembayaran_metode_id = m.metode_id 
WHERE EXTRACT(MONTH FROM t.tanggal_transaksi) IN (1, 2, 3) 
GROUP BY p.produk, m.metode_pembayaran;
