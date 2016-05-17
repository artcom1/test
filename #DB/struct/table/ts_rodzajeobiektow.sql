CREATE TABLE ts_rodzajeobiektow (
    rb_idrodzaju integer DEFAULT nextval('ts_rodzajeobiektow_s'::regclass) NOT NULL,
    rb_nazwa text,
    rb_flaga integer DEFAULT 0
);
