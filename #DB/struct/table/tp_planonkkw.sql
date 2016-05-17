CREATE TABLE tp_planonkkw (
    kwl_idplanu integer DEFAULT nextval(('tp_planonkkw_s'::text)::regclass) NOT NULL,
    ms_idmozliwosci integer,
    ob_idobiektu integer,
    ep_idetapu integer,
    ek_idetapu integer NOT NULL,
    kwl_nakiedy date,
    kwl_flaga integer DEFAULT 0 NOT NULL,
    kwl_ilosc numeric DEFAULT 0 NOT NULL,
    kwl_lp integer,
    kwl_czas numeric DEFAULT 0,
    kwp_idplanu integer
);
