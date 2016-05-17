CREATE TABLE kh_wzorceelempks (
    wep_idelementu integer DEFAULT nextval('kh_wzorceelem_s'::regclass) NOT NULL,
    wz_idwzorca integer NOT NULL,
    wep_nazwa text,
    wep_kontosrc text,
    wep_kontodst text,
    wep_typ integer,
    wep_procent numeric DEFAULT 100,
    wep_dontfromsrc boolean DEFAULT false,
    wep_dontfromdst boolean DEFAULT false,
    wep_idto integer,
    wep_dzialanie integer DEFAULT 0,
    wep_lp integer,
    wep_valuefromdst boolean DEFAULT false,
    wep_function integer DEFAULT 0 NOT NULL
);
