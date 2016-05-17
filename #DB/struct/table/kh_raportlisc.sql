CREATE TABLE kh_raportlisc (
    rl_idliscia integer DEFAULT nextval(('kh_raportlisc_s'::text)::regclass) NOT NULL,
    re_idelementu integer NOT NULL,
    rp_idraportu integer NOT NULL,
    rl_mnoznik numeric DEFAULT 0,
    kt_idkonta integer,
    rl_symbolop integer DEFAULT 0,
    re_valuefrom integer,
    fk_idklocka integer,
    rl_regex text,
    rl_valueno smallint DEFAULT 0,
    rl_valueno_from smallint,
    rl_type integer,
    rl_function smallint,
    rl_const numeric,
    rl_kolejnosc integer NOT NULL
);
