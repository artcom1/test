CREATE TABLE tb_schowektowarow (
    st_idelementu integer DEFAULT nextval('tb_schowektowarow_s'::regclass) NOT NULL,
    st_hash text NOT NULL,
    ttw_idtowaru integer NOT NULL,
    st_ilosc numeric DEFAULT 1
);
