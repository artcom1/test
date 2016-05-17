CREATE TABLE tr_pracochlonnosc (
    pch_idpracochlonnosci integer DEFAULT nextval('tr_pracochlonnosc_s'::regclass) NOT NULL,
    ttw_idtowaru integer NOT NULL,
    rb_idrodzaju integer NOT NULL,
    pch_czastpz numeric NOT NULL,
    pch_czastj numeric NOT NULL
);
