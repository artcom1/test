CREATE TABLE tm_mail (
    tma_idmail integer DEFAULT nextval('tma_idmail_s'::regclass) NOT NULL,
    tma_msg text,
    tma_datawyslania timestamp with time zone,
    tma_dataproby timestamp with time zone,
    tma_iloscprob integer DEFAULT 0,
    tma_blad text,
    p_idpracownika integer
);
