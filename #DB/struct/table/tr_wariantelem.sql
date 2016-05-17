CREATE TABLE tr_wariantelem (
    ve_idelemu integer DEFAULT nextval('tr_wariantelem_s'::regclass) NOT NULL,
    vmp_idwariantu integer,
    kwe_idelemu integer,
    the_idelem integer
);
