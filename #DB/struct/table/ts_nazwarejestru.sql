CREATE TABLE ts_nazwarejestru (
    nr_idnazwy integer DEFAULT nextval(('ts_nazwarejestru_s'::text)::regclass) NOT NULL,
    nr_nazwa text,
    nr_typrejestru integer,
    ro_idroku integer,
    nr_flaga integer,
    nr_kod text
);
