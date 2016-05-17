CREATE TABLE tm_registereddbs (
    nsr_idrejestracji integer DEFAULT nextval('tm_numeryseryjne_s'::regclass) NOT NULL,
    ns_idnumeru integer NOT NULL,
    nsr_dbhashcode integer NOT NULL,
    nsr_updatedata timestamp without time zone DEFAULT now(),
    nsr_pgversion text,
    nsr_vversion text,
    nsr_isactive boolean DEFAULT true
);
