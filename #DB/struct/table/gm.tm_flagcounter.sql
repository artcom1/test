CREATE TABLE tm_flagcounter (
    mrpp_idpalety_to integer,
    flc_type flagcountertype,
    flc_id integer DEFAULT nextval('tm_flagcounterbase_s'::regclass) NOT NULL,
    flc_counter integer DEFAULT 0 NOT NULL
)
INHERITS (tm_flagcounterbase);
