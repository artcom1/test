CREATE TABLE kh_konwersjakpir (
    kk_idkonwersji integer DEFAULT nextval(('kh_konwersjakpir_s'::text)::regclass) NOT NULL,
    tr_idtrans integer,
    kp_idzapisu integer,
    am_id integer
);
