CREATE TABLE tm_mobileids (
    mb_idrelacji integer DEFAULT nextval(('tm_mobileids_s'::text)::regclass) NOT NULL,
    mb_typaplikacji integer NOT NULL,
    mb_datatype integer NOT NULL,
    mb_vid integer NOT NULL,
    mb_extid text NOT NULL,
    mb_oid oid,
    mb_ackoid oid,
    mb_exthashcode integer DEFAULT 0
);
