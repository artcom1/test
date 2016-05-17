CREATE TABLE tr_kubelkisymulacyjne (
    ksym_idkubelka integer DEFAULT nextval('tr_kubelkisymulacyjne_s'::regclass) NOT NULL,
    rb_idrodzaju integer NOT NULL,
    rk_idrozmiaru integer NOT NULL,
    ksym_rok integer NOT NULL,
    ksym_poczatek integer NOT NULL,
    ksym_czasod timestamp with time zone NOT NULL,
    ksym_czasdo timestamp with time zone NOT NULL,
    ksym_rbh numeric DEFAULT 0 NOT NULL,
    ksym_flaga integer DEFAULT 0 NOT NULL
);
