CREATE TABLE ts_samochody (
    sm_idsamochodu integer DEFAULT nextval(('ts_samochody_s'::text)::regclass) NOT NULL,
    sm_marka text NOT NULL,
    sm_numrejestr text DEFAULT ''::character varying NOT NULL,
    sm_flaga smallint DEFAULT 0 NOT NULL,
    ob_idobiektu integer
);
