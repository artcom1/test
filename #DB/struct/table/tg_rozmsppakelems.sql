CREATE TABLE tg_rozmsppakelems (
    rmk_idelemu integer DEFAULT nextval('tg_rozmrodzaje_s'::regclass) NOT NULL,
    rmp_idsposobu integer NOT NULL,
    rmr_idrodzaju integer,
    rme_idelemu integer,
    rmk_przelicznik numeric DEFAULT 1,
    ttw_idtowaru_pdx integer,
    CONSTRAINT tg_rozmsppakelems_c1 CHECK ((((rmr_idrodzaju IS NOT NULL) OR (ttw_idtowaru_pdx IS NOT NULL)) AND (NOT ((rmr_idrodzaju IS NOT NULL) AND (ttw_idtowaru_pdx IS NOT NULL))))),
    CONSTRAINT tg_rozmsppakelems_c2 CHECK (((rme_idelemu IS NOT NULL) OR (ttw_idtowaru_pdx IS NOT NULL)))
);
