CREATE TABLE tg_rozmsppak (
    rmp_idsposobu integer DEFAULT nextval('tg_rozmrodzaje_s'::regclass) NOT NULL,
    rmr_idrodzaju integer,
    rmp_kod text,
    rmp_istmp boolean DEFAULT false,
    ttw_idtowaru_ndx integer,
    rmp_idsposobu_ref integer,
    rmp_kodex text,
    CONSTRAINT tg_rozmsppak_c1 CHECK ((((rmr_idrodzaju IS NOT NULL) OR (ttw_idtowaru_ndx IS NOT NULL) OR (rmp_istmp = true)) AND (NOT ((rmr_idrodzaju IS NOT NULL) AND (ttw_idtowaru_ndx IS NOT NULL)))))
);
