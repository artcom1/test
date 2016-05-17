CREATE TABLE ts_elementyrodzajuobiektu (
    ero_idelementu integer DEFAULT nextval('ts_elementyrodzajuobiektu_s'::regclass) NOT NULL,
    ero_nazwa text NOT NULL,
    rb_idrodzaju integer NOT NULL,
    ero_typ integer NOT NULL,
    ero_flaga integer DEFAULT 0,
    ero_kod text
);
