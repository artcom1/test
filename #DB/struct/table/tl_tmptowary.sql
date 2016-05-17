CREATE TABLE tl_tmptowary (
    tl_idtowaru integer DEFAULT nextval('tl_tmptowary_s'::regclass) NOT NULL,
    tel_idelem integer,
    ttw_idtowaru integer NOT NULL
);
