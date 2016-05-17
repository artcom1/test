CREATE TABLE tg_wolnenumery (
    tr_rodzaj integer,
    tr_seria character varying(4),
    tr_rok character varying(2),
    tr_numer integer DEFAULT 0,
    tr_datasprzedaz date,
    tr_datausuniecia timestamp without time zone DEFAULT now(),
    fm_idcentrali integer,
    tr_infix text
);
