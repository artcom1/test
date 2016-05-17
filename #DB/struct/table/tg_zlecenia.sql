CREATE TABLE tg_zlecenia (
    zl_idzlecenia integer DEFAULT nextval(('tg_zlecenia_s'::text)::regclass) NOT NULL,
    zl_nrzlecenia integer DEFAULT nextval(('tg_zlecenia_numer_s'::text)::regclass),
    zl_datazlecenia timestamp with time zone DEFAULT now(),
    zl_datarozpoczecia timestamp with time zone DEFAULT now(),
    zl_rodzajimp integer DEFAULT 0,
    zl_typ integer DEFAULT 0,
    zl_liczbaosob integer DEFAULT 0,
    k_idklienta integer,
    zl_opis text,
    zl_nazwisko_kod text,
    zl_miejscewyk text,
    p_przyjmujacy integer,
    p_odpowiedzialny integer,
    p_wykonujacy integer,
    zl_datazakonczenia timestamp with time zone,
    zl_status integer DEFAULT 0,
    zl_telefon_cel text DEFAULT ''::text,
    zl_koszt numeric DEFAULT 0,
    zl_rok character varying(2) DEFAULT '02'::character varying,
    zl_przychod numeric DEFAULT 0,
    zl_seria character varying(4) DEFAULT ''::character varying,
    zl_nazwaold character varying(15) DEFAULT ''::character varying,
    zl_czaspracy numeric DEFAULT 0,
    pw_idpowiatu integer DEFAULT 0,
    zl_wrtnetto numeric DEFAULT 0,
    zl_rozchodrw numeric DEFAULT 0,
    zl_wydanie numeric DEFAULT 0,
    k_idzlecajacy integer,
    sz_idetapu integer,
    zl_sumawplat numeric DEFAULT 0,
    zl_wrtbrutto numeric DEFAULT 0,
    zl_opiswykonania text,
    zl_datazamkniecia date,
    zl_zwrot numeric DEFAULT 0,
    zl_planprzychod numeric DEFAULT 0,
    zl_planprzychodbrt numeric DEFAULT 0,
    zl_kosztbrt numeric DEFAULT 0,
    zl_kosztfv numeric DEFAULT 0,
    zl_wyplaty numeric DEFAULT 0,
    zl_nzaplaconedok numeric DEFAULT 0,
    zl_nazwa text,
    zl_invoicebrutto numeric DEFAULT 0,
    zl_invoicenetto numeric DEFAULT 0,
    ttw_idtowaru integer,
    ob_idobiektu integer,
    zl_przebieg numeric DEFAULT 0,
    zl_ofertanto numeric DEFAULT 0,
    zl_ofertabto numeric DEFAULT 0,
    zl_bud_rozchodrw numeric DEFAULT 0.00,
    zl_bud_robocizna numeric DEFAULT 0.00,
    zl_bud_koszty numeric DEFAULT 0.00,
    zl_bud_wydanie numeric DEFAULT 0.00,
    zl_robocizna numeric DEFAULT 0.00,
    zl_bud_narzutroboc numeric,
    zl_bud_korektawyniku numeric,
    zl_flaga integer DEFAULT 0,
    lk_idczklienta integer,
    zl_prorytet integer,
    sp_stanowisko integer DEFAULT '-2'::integer,
    fm_idcentrali integer,
    zl_bud_przychod numeric DEFAULT 0.00,
    zl_prawdopodob numeric DEFAULT 100.00,
    zl_temat text,
    zl_datarozprocedura timestamp with time zone,
    zl_datazakprocedura timestamp with time zone,
    zl_bud_pracerbh numeric DEFAULT 0.00,
    zl_pracerbh numeric DEFAULT 0.00,
    dz_iddzialu integer,
    zl_dataroz_zdarzenie_kkw timestamp with time zone,
    zl_datazak_zdarzenie_kkw timestamp with time zone,
    zl_iduslugir integer,
    zl_cenauslugir numeric DEFAULT 0,
    zl_walutauslugir integer,
    zl_kolor integer DEFAULT (power((2)::double precision, (24)::double precision) - (1)::double precision),
    zl_lockby integer,
    zl_lockdate timestamp with time zone,
    k_idklienta3 integer,
    rb_idrodzaju integer DEFAULT 0,
    zl_idtransportu integer,
    zl_idref integer,
    zl_prefix text DEFAULT ''::text,
    zl_prefixparent text DEFAULT ''::text,
    zl_rodzajnum integer DEFAULT 0,
    zl_miejscowosc text,
    zl_przejazdynto numeric DEFAULT 0.00,
    zl_przejazdybto numeric DEFAULT 0.00,
    zl_robociznanetto numeric DEFAULT 0.00,
    zl_narzutroboc numeric DEFAULT 0.00,
    st_idstatusu integer
);
