CREATE TABLE st_kontastwlatach (
    kwl_id integer DEFAULT nextval(('st_kontastwlatach_s'::text)::regclass) NOT NULL,
    str_id integer,
    ro_idrok integer,
    kwl_kontogl integer,
    kwl_kontoum integer,
    kwl_kontoampod integer,
    kwl_kontoamnp integer,
    kwl_kontoam5 integer,
    kwl_kontorkosz integer,
    kwl_wspolczynnik numeric,
    kwl_flaga integer DEFAULT 0,
    kwl_pozabilansowewn integer,
    kwl_pozabilansowema integer
);
