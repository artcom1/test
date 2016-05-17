CREATE TABLE tb_vat_b (
    tr_idtrans integer NOT NULL,
    v_stvat numeric NOT NULL,
    v_zw integer NOT NULL,
    v_kurswal public.mpq NOT NULL,
    v_idwaluty integer,
    v_isorg smallint NOT NULL,
    v_iswal boolean NOT NULL,
    v_iscorr boolean NOT NULL,
    v_ispkormakro boolean NOT NULL,
    v_iskgoforwal boolean NOT NULL
);
