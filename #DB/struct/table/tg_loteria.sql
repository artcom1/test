CREATE TABLE tg_loteria (
    lr_idloterii integer DEFAULT nextval('tg_loterie_s'::regclass) NOT NULL,
    fm_idcentrali integer NOT NULL,
    lr_nazwa text,
    lr_poczatek date NOT NULL,
    lr_koniec date NOT NULL,
    lr_dzielnikpunktow numeric DEFAULT 1 NOT NULL,
    lr_iscommited boolean DEFAULT false NOT NULL,
    lr_active boolean DEFAULT true NOT NULL
);
