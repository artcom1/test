CREATE TABLE tr_technoelemwsp (
    knwp_idwspolczynnika integer DEFAULT nextval('tr_technoelemwsp_s'::regclass) NOT NULL,
    th_idtechnologii integer NOT NULL,
    the_idelem integer NOT NULL,
    knwp_wspolczynik numeric DEFAULT 0
);
