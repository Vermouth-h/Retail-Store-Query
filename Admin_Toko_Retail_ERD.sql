CREATE TABLE customer (
    customer_id VARCHAR2(14) NOT NULL
);

ALTER TABLE customer ADD CONSTRAINT customer_pk PRIMARY KEY ( customer_id );

CREATE TABLE detail_transaksi (
    jumlah                   NUMBER NOT NULL,
    harga_barang             NUMBER NOT NULL,
    transaksi_transaksi_id   VARCHAR2(15 CHAR) NOT NULL
);

CREATE TABLE lokasi_pembelian (
    lp_id              VARCHAR2(15 CHAR) NOT NULL,
    lokasi_pembelian   VARCHAR2(15 CHAR) NOT NULL
);

ALTER TABLE lokasi_pembelian ADD CONSTRAINT lokasi_pembelian_pk PRIMARY KEY ( lp_id );

CREATE TABLE metode_pembayaran (
    metode_id           VARCHAR2(15 CHAR) NOT NULL,
    metode_pembayaran   VARCHAR2(25 CHAR) NOT NULL
);

ALTER TABLE metode_pembayaran ADD CONSTRAINT metode_pembayaran_pk PRIMARY KEY ( metode_id );

CREATE TABLE produk (
    produk_id   VARCHAR2(15 CHAR) NOT NULL,
    produk      VARCHAR2(40 CHAR) NOT NULL
);

ALTER TABLE produk ADD CONSTRAINT produk_pk PRIMARY KEY ( produk_id );

CREATE TABLE transaksi (
    transaksi_id                  VARCHAR2(15 CHAR) NOT NULL,
    tanggal_transaksi             DATE NOT NULL,
    total_harga                   NUMBER NOT NULL,
    customer_customer_id          VARCHAR2(14) NOT NULL,
    produk_produk_id              VARCHAR2(15 CHAR) NOT NULL,
    metode_pembayaran_metode_id   VARCHAR2(15 CHAR) NOT NULL,
    lokasi_pembelian_lp_id        VARCHAR2(15 CHAR) NOT NULL
);

ALTER TABLE transaksi ADD CONSTRAINT transaksi_pk PRIMARY KEY ( transaksi_id );

ALTER TABLE detail_transaksi
    ADD CONSTRAINT detail_transaksi_transaksi_fk FOREIGN KEY ( transaksi_transaksi_id )
        REFERENCES transaksi ( transaksi_id );

ALTER TABLE transaksi
    ADD CONSTRAINT transaksi_customer_fk FOREIGN KEY ( customer_customer_id )
        REFERENCES customer ( customer_id );

ALTER TABLE transaksi
    ADD CONSTRAINT transaksi_lokasi_pembelian_fk FOREIGN KEY ( lokasi_pembelian_lp_id )
        REFERENCES lokasi_pembelian ( lp_id );

ALTER TABLE transaksi
    ADD CONSTRAINT transaksi_metode_pembayaran_fk FOREIGN KEY ( metode_pembayaran_metode_id )
        REFERENCES metode_pembayaran ( metode_id );

ALTER TABLE transaksi
    ADD CONSTRAINT transaksi_produk_fk FOREIGN KEY ( produk_produk_id )
        REFERENCES produk ( produk_id );
-------------------------------------------------------------------------------------------------------------------------------
-- ERD Query
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
FROM detail_transaksi;

--5 menengah
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

--5 Kompleks
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