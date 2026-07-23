--DDL ERD
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
