CREATE TABLE tm_dropshtowarmap (
    dst_id integer DEFAULT nextval('tm_mobileids_s'::regclass) NOT NULL,
    fm_idcentralisrc integer NOT NULL,
    k_idklientadst integer NOT NULL,
    ttw_idtowarusrc integer NOT NULL,
    ttw_idtowarudst integer NOT NULL
);
