CREATE TABLE tg_ruchy (
    rc_idruchu integer DEFAULT nextval(('tg_ruchy_s'::text)::regclass) NOT NULL,
    tel_idelem integer,
    tr_idtrans integer,
    ttw_idtowaru integer,
    ttm_idtowmag integer,
    tmg_idmagazynu integer,
    k_idklienta integer,
    rc_data date DEFAULT now(),
    rc_dataop timestamp with time zone DEFAULT now(),
    rc_ruch integer,
    rc_rezerwacja integer,
    rc_ilosc numeric DEFAULT 0,
    rc_wartosc numeric DEFAULT 0 NOT NULL,
    rc_iloscpoz numeric DEFAULT 0,
    rc_wartoscpoz numeric DEFAULT 0 NOT NULL,
    rc_iloscrez numeric DEFAULT 0,
    rc_iloscrezzr numeric DEFAULT 0,
    rc_kierunek smallint DEFAULT 0,
    rc_wspwartosci smallint DEFAULT 1,
    rc_kierunekrez smallint DEFAULT 0,
    rc_odn smallint DEFAULT 0,
    rc_flaga integer DEFAULT 0,
    rc_cenajedn numeric DEFAULT 0,
    rc_datamax date,
    rc_dostawa integer,
    rc_wspmag integer DEFAULT 0,
    rc_seqid integer,
    mm_idmiejsca integer,
    rc_recver integer DEFAULT nextval('gm.tg_rezstack_ver'::regclass) NOT NULL,
    prt_idpartiipz integer,
    prt_idpartiiwz integer,
    tex_idelem integer,
    rc_cenajmpokor numeric,
    rc_cenajmcrs numeric,
    rc_iloscwzbuf numeric DEFAULT 0,
    rc_ruchpz integer,
    mrpp_idpalety integer,
    CONSTRAINT checkwspwartosci CHECK ((rc_wspwartosci = ANY (ARRAY[1, '-1'::integer]))),
    CONSTRAINT tg_ruchy_checkdostawaandruchpz CHECK (((rc_wspmag = 0) OR ((rc_dostawa IS NOT NULL) AND (rc_ruchpz IS NOT NULL)) OR iskwm(rc_flaga)))
);
