CREATE TABLE kh_raportelem (
    re_idelementu integer DEFAULT nextval(('kh_raportelem_s'::text)::regclass) NOT NULL,
    rp_idraportu integer,
    re_nazwa text,
    re_mnoznik numeric DEFAULT 0,
    re_ref integer,
    re_l integer,
    re_r integer,
    re_poziom smallint DEFAULT 0,
    re_prefix text,
    re_sufix integer,
    re_lisccnt integer DEFAULT 0,
    re_flaga integer DEFAULT 0,
    re_nazwapola text DEFAULT ''::text
);
