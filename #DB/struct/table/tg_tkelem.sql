CREATE TABLE tg_tkelem (
    tk_idelem integer DEFAULT nextval(('tg_tkelem_s'::text)::regclass) NOT NULL,
    tk_lp integer DEFAULT 0,
    tr_idtrans integer,
    tk_wydano numeric DEFAULT 0,
    tk_przyjeto numeric DEFAULT 0,
    tjn_idjedn integer,
    tk_nazwa text,
    ttm_idtowmag integer,
    ttw_idtowaru integer,
    tk_flaga integer DEFAULT 0,
    tk_kaucjajedn numeric DEFAULT 0
);
