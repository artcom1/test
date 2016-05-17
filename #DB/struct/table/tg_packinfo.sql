CREATE TABLE tg_packinfo (
    pki_idtrans integer NOT NULL,
    tr_idtrans integer NOT NULL,
    pki_startdate timestamp without time zone DEFAULT now(),
    pki_enddate timestamp without time zone
);
