CREATE TABLE tr_kkwnodprevnext (
    knpn_idelem integer DEFAULT nextval(('tr_kkwnodprevnext_s'::text)::regclass) NOT NULL,
    kwh_idheadu integer,
    kwe_idprev integer NOT NULL,
    kwe_idnext integer NOT NULL,
    thpn_idelem integer,
    knpn_flaga integer DEFAULT 0,
    knpn_x_licznik numeric DEFAULT 0,
    knpn_x_mianownik numeric DEFAULT 1,
    knpn_fromnext numeric DEFAULT 0,
    knpn_x_wspc numeric DEFAULT 0,
    knpn_kwhilosc numeric DEFAULT 0,
    knpn_kweilosc numeric DEFAULT 0
);
