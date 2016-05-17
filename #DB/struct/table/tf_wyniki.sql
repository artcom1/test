CREATE TABLE tf_wyniki (
    fw_idrekordu integer DEFAULT nextval('tf_wyniki_s'::regclass) NOT NULL,
    fw_idwyniku integer NOT NULL,
    fw_id integer NOT NULL
);
