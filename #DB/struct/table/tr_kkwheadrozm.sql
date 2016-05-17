CREATE TABLE tr_kkwheadrozm (
    kwhr_idelemu integer DEFAULT nextval('tr_kkwheadrozm_s'::regclass) NOT NULL,
    kwhr_kwh_idheadu integer NOT NULL,
    kwhr_ilosckart numeric,
    kwhr_rmp_idsposobu integer,
    kwhr_ilosciwkart numeric[],
    kwhr_flaga integer DEFAULT 0,
    kwhr_iloscwmag numeric DEFAULT 0 NOT NULL,
    kwhr_iloscwmagclosed numeric DEFAULT 0 NOT NULL,
    kwhr_pz_idplanu integer,
    kwhr_iloscwyk numeric DEFAULT 0 NOT NULL,
    kwhr_iloscwmag_arr numeric[],
    kwhr_iloscwmagclosed_arr numeric[],
    kwhr_iloscwyk_arr numeric[]
);
