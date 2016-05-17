CREATE TABLE tb_hmsplat (
    hs_idelementu integer DEFAULT nextval(('tb_hmsplat_s'::text)::regclass) NOT NULL,
    tr_idtrans integer NOT NULL,
    hs_dozaplaty numeric DEFAULT 0 NOT NULL,
    hs_zaplacono numeric DEFAULT 0 NOT NULL,
    hs_dataplatnosci date NOT NULL,
    hs_flaga integer DEFAULT 0,
    hs_opis text
);
