CREATE TABLE kh_predekretacjainfo (
    pd_id integer DEFAULT nextval('kh_predekretacjainfo_s'::regclass) NOT NULL,
    tr_idtrans integer,
    zk_idzapisu integer,
    wz_idwzorca integer
);
