CREATE TABLE tc_version (
    vmin character varying(19),
    vmax character varying(19),
    skip boolean DEFAULT false,
    dbhash integer,
    programmode integer
);
