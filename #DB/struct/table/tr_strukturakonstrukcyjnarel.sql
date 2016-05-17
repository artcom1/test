CREATE TABLE tr_strukturakonstrukcyjnarel (
    skr_idrelacji integer DEFAULT nextval('tr_strukturakonstrukcyjna_s'::regclass) NOT NULL,
    sk_idstrukturyp integer NOT NULL,
    sk_idstrukturyc integer NOT NULL,
    skr_ilosc numeric DEFAULT 0,
    psk_isprzeliczenia integer DEFAULT 0,
    skr_lp integer
);
