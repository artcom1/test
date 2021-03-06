CREATE TABLE tb_klient (
    k_idklienta integer DEFAULT nextval(('tb_klient_s'::text)::regclass) NOT NULL,
    k_nazwa text NOT NULL,
    rk_idrodzajklienta integer DEFAULT 0,
    k_ulica text NOT NULL,
    k_nrlokalu text NOT NULL,
    k_kodpocztowy text,
    k_miejscowosc text NOT NULL,
    pw_idpowiatu integer DEFAULT 0,
    k_nip text,
    wk_idwagi integer DEFAULT 0,
    k_czykobieta boolean DEFAULT true,
    zi_idzrodla integer DEFAULT 0,
    k_telefon text DEFAULT ''::text,
    k_email text,
    sk_idstatusu integer DEFAULT 0,
    k_dlaczegoodszedl text,
    k_zgodanaprzetw boolean DEFAULT true,
    k_opis text,
    k_potrzeby text,
    k_dostodb bigint DEFAULT 0,
    k_osfizyczna boolean DEFAULT false,
    lk_czdomyslny integer DEFAULT 0,
    tgc_idgrupy integer DEFAULT 0,
    k_limitkredyt numeric DEFAULT 999999999.00,
    k_kredytdni integer DEFAULT 14,
    p_idpracownika integer DEFAULT 0,
    p_dodajacy integer DEFAULT 0,
    k_datawpr date DEFAULT now(),
    k_jegoagent integer DEFAULT 0,
    k_platnosc smallint DEFAULT 0,
    k_kod text DEFAULT ''::character varying,
    k_upust numeric DEFAULT 0,
    k_flaga integer DEFAULT 0,
    k_nasznumer text DEFAULT 0,
    rj_idregionu integer,
    k_osobaodbierajaca text,
    k_procenthan numeric,
    k_www text,
    k_regon text,
    k_inforejestr text,
    k_koncesje text,
    k_datakoncesji text,
    k_iln text,
    k_kodobcy text,
    k_dostawa text,
    sp_idspedytora integer,
    k_idplatnik integer,
    k_haslo text,
    k_nrdomu text,
    k_istniejeod date,
    k_imie text,
    k_nazwisko text,
    k_idodbiorcy integer,
    k_kolor integer DEFAULT (power((2)::double precision, (24)::double precision) - (1)::double precision),
    k_zadluzenie numeric[],
    k_zadluzenieniezamk numeric[],
    k_zaliczka numeric[],
    k_rolnikumowaplatnosc integer,
    k_kontokh2 text,
    k_dataostmod date DEFAULT now(),
    k_ulicakor text,
    k_nrlokalukor text,
    k_kodpocztowykor text,
    k_miejscowosckor text,
    k_nrdomukor text,
    pw_idpowiatukor integer,
    rj_idregionukor integer,
    k_lockby integer,
    k_lockdate timestamp with time zone,
    k_niezafaktwz numeric[],
    k_geox numeric,
    k_geoy numeric,
    ros_idrodzaju integer DEFAULT 0 NOT NULL,
    k_wsksplaty numeric,
    k_wsksplaty_dataobl timestamp without time zone,
    st_idstatusu integer,
    pwep_idpunktu integer,
    k_blokady integer DEFAULT 0,
    k_eksportowosc integer DEFAULT 0 NOT NULL,
    wl_idwaluty integer,
    k_limitprzeterminowanych numeric DEFAULT 999999999.00,
    k_limitmaxopoznienia integer DEFAULT 99999999,
    k_nipprefix text,
    k_nsdbhash integer,
    sch_idschematu integer
);
