CREATE TABLE tr_technoprevnext (
    thpn_idelem integer DEFAULT nextval(('tr_technoprevnext_s'::text)::regclass) NOT NULL,
    th_idtechnologii integer,
    the_idprev integer NOT NULL,
    the_idnext integer NOT NULL,
    thpn_x_licznik numeric DEFAULT 0,
    thpn_x_mianownik numeric DEFAULT 1,
    thpn_flaga integer DEFAULT 0,
    thpn_x_wspc numeric DEFAULT 0
);
