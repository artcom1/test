CREATE TABLE ts_banki (
    bk_idbanku integer DEFAULT nextval(('ts_banki_s'::text)::regclass) NOT NULL,
    bk_kod text,
    bk_nazwa text,
    bk_adres text,
    bk_nrkonta text,
    wl_idwaluty integer DEFAULT 1,
    bk_flaga integer DEFAULT 0,
    bk_bilans numeric DEFAULT 0,
    bk_rejestr text,
    bk_sserii character varying(4),
    bk_swift text,
    bk_type integer,
    bk_nrkontanorm text,
    bk_priorytet integer,
    k_idklientafor integer,
    bk_idbanku_ref integer,
    fm_idcentrali integer,
    fm_index integer,
    bk_wsieformat_import uuid,
    bk_wsieformat_export uuid
);