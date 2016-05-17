CREATE TABLE tg_dostawarozdzial (
    dr_idrozdzialu integer DEFAULT nextval('tg_dostawarozdzial_s'::regclass) NOT NULL,
    tel_idelem_pzam integer,
    tel_idelem_fz integer,
    dr_ilosc numeric DEFAULT 0 NOT NULL,
    dr_flaga integer DEFAULT 0 NOT NULL
);
