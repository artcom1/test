CREATE TABLE tl_tmptowarydel (
    tld_idtowaru integer DEFAULT nextval('tl_tmptowarydel_s'::regclass) NOT NULL,
    tr_idtrans integer,
    tld_nazwa text,
    tld_ilosc numeric
);
