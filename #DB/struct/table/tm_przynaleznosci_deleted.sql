CREATE TABLE tm_przynaleznosci_deleted (
    mp_idprzywiazania integer,
    mp_idref integer NOT NULL,
    mp_type integer NOT NULL,
    mp_rodzaj integer NOT NULL,
    mp_lastchanged timestamp without time zone DEFAULT now()
);
