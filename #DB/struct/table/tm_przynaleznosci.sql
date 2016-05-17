CREATE TABLE tm_przynaleznosci (
    mp_idprzywiazania integer DEFAULT nextval('tm_przynaleznosci_s'::regclass) NOT NULL,
    mp_idref integer,
    mp_type integer,
    mp_rodzaj integer
);
