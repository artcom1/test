CREATE TABLE tb_ustawieniadomprac (
    pu_idustawienia integer DEFAULT nextval('tb_ustawieniadomprac_s'::regclass) NOT NULL,
    p_idpracownika integer NOT NULL,
    fm_idcentrali integer NOT NULL,
    tmg_idmagazynu integer,
    pu_seriadok character varying(4),
    pu_kasa integer,
    pu_bank integer,
    pu_rejinne integer,
    pu_sekretariat integer,
    pu_firma integer,
    pu_grupatech integer,
    wl_idwaluty integer
);
