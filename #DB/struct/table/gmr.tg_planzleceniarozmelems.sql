CREATE TABLE tg_planzleceniarozmelems (
    pzw_idelemu integer DEFAULT nextval('tg_planzleceniarozmelems_s'::regclass) NOT NULL,
    pz_idplanu integer NOT NULL,
    pzw_iloscop numeric NOT NULL,
    pzw_ilosczreal numeric DEFAULT 0 NOT NULL,
    pzw_ilosczrealclosed numeric DEFAULT 0 NOT NULL,
    rmp_idsposobu integer NOT NULL,
    ttw_idtowaru_pdx integer NOT NULL,
    tel_idsrcelem integer,
    pzw_mnoznikop numeric NOT NULL,
    CONSTRAINT gmr_tg_planzleceniarozmelems_c1 CHECK ((pzw_ilosczrealclosed <= pzw_ilosczreal))
);


SET search_path = gms, pg_catalog;
