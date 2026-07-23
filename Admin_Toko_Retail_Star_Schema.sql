CREATE TABLE customer (
    customer_key   NUMBER NOT NULL,
    customer_id    VARCHAR2(14) NOT NULL
);

ALTER TABLE customer ADD CONSTRAINT customer_pk PRIMARY KEY ( customer_key );

CREATE TABLE lokasi_pembelian (
    lp_key             NUMBER NOT NULL,
    lokasi_pembelian   VARCHAR2(15 CHAR) NOT NULL
);

ALTER TABLE lokasi_pembelian ADD CONSTRAINT lokasi_pembelian_pk PRIMARY KEY ( lp_key );

CREATE TABLE metode_pembayaran (
    metode_key          NUMBER NOT NULL,
    metode_pembayaran   VARCHAR2(25 CHAR) NOT NULL
);

ALTER TABLE metode_pembayaran ADD CONSTRAINT metode_pembayaran_pk PRIMARY KEY ( metode_key );

CREATE TABLE produk (
    produk_key   NUMBER NOT NULL,
    produk_id    VARCHAR2(15 CHAR) NOT NULL,
    produk       VARCHAR2(35 CHAR) NOT NULL
);

ALTER TABLE produk ADD CONSTRAINT produk_pk PRIMARY KEY ( produk_key );

CREATE TABLE transaksi (
    transaksi_id                   VARCHAR2(15 CHAR) NOT NULL,
    jumlah                         NUMBER NOT NULL,
    harga_barang                   NUMBER NOT NULL,
    total_harga                    NUMBER NOT NULL,
    customer_customer_key          NUMBER NOT NULL,
    waktu_waktu_key                NUMBER NOT NULL,
    metode_pembayaran_metode_key   NUMBER NOT NULL,
    lokasi_pembelian_lp_key        NUMBER NOT NULL,
    produk_produk_key              NUMBER NOT NULL
);

ALTER TABLE transaksi ADD CONSTRAINT transaksi_pk PRIMARY KEY ( transaksi_id );

CREATE TABLE waktu (
    waktu_key   NUMBER NOT NULL,
    tanggal     NUMBER NOT NULL,
    bulan       NUMBER NOT NULL,
    tahun       NUMBER NOT NULL,
    nama_hari   VARCHAR2(20 CHAR) NOT NULL
);

ALTER TABLE waktu ADD CONSTRAINT waktu_pk PRIMARY KEY ( waktu_key );

ALTER TABLE transaksi
    ADD CONSTRAINT transaksi_customer_fk FOREIGN KEY ( customer_customer_key )
        REFERENCES customer ( customer_key );

ALTER TABLE transaksi
    ADD CONSTRAINT transaksi_lokasi_pembelian_fk FOREIGN KEY ( lokasi_pembelian_lp_key )
        REFERENCES lokasi_pembelian ( lp_key );

ALTER TABLE transaksi
    ADD CONSTRAINT transaksi_metode_pembayaran_fk FOREIGN KEY ( metode_pembayaran_metode_key )
        REFERENCES metode_pembayaran ( metode_key );

ALTER TABLE transaksi
    ADD CONSTRAINT transaksi_produk_fk FOREIGN KEY ( produk_produk_key )
        REFERENCES produk ( produk_key );

ALTER TABLE transaksi
    ADD CONSTRAINT transaksi_waktu_fk FOREIGN KEY ( waktu_waktu_key )
        REFERENCES waktu ( waktu_key );
-------------------------------------------------------------------------------
-- Star Schema Query
--5 Sederhana
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

--5 Menengah
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

--5 Kompleks
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