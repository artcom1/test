CREATE TABLE tr_przyczynaprzestojow (
    pp_idprzyczyny integer DEFAULT nextval('tr_przyczynaprzestojow_s'::regclass) NOT NULL,
    pp_powod text,
    pp_flaga integer DEFAULT 0,
    pp_rodzaj integer DEFAULT 0 NOT NULL,
    top_idoperacji integer,
    rb_idrodzaju integer
);
