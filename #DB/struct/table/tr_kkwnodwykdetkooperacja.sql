CREATE TABLE tr_kkwnodwykdetkooperacja (
    kwk_idelemu integer DEFAULT nextval('tr_kkwnodwykdetkooperacja_s'::regclass) NOT NULL,
    knw_idelemu integer NOT NULL,
    p_idpracownika integer NOT NULL,
    kwk_przyjetodobrych numeric DEFAULT 0,
    kwk_przyjetobrakow numeric DEFAULT 0,
    kwk_dataprzyjecia timestamp with time zone,
    kwk_flaga integer DEFAULT 0
);
