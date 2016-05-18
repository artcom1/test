CREATE VIEW wymiary AS
 SELECT kt.ktn_idkonta,
    s.wms_idwymiaru AS idwymiaru,
    s.mc_miesiac,
    v.wmv_valuewnwal AS valuewnwal,
    v.wmv_valuemawal AS valuemawal,
    v.wmv_valuewn AS valuewn,
    v.wmv_valuema AS valuema,
    v.wl_idwaluty AS idwaluty,
        CASE
            WHEN (e.wme_datatyperef = 11) THEN e.wme_idref
            ELSE NULL::integer
        END AS idpracownika,
        CASE
            WHEN (e.wme_datatyperef = 1) THEN e.wme_idref
            ELSE NULL::integer
        END AS idklienta,
        CASE
            WHEN (e.wme_datatyperef = 32) THEN e.wme_idref
            ELSE NULL::integer
        END AS idzlecenia,
        CASE
            WHEN (e.wme_datatyperef = 2) THEN e.wme_idref
            ELSE NULL::integer
        END AS idobiektu,
        CASE
            WHEN (e.wme_datatyperef = 80) THEN e.wme_idref
            ELSE NULL::integer
        END AS idsrodkatrwalego,
        CASE
            WHEN (e.wme_datatyperef = 12) THEN e.wme_idref
            ELSE NULL::integer
        END AS idgrupytowarow,
        CASE
            WHEN (e.wme_datatyperef = 13) THEN e.wme_idref
            ELSE NULL::integer
        END AS idpodgrupytowarow,
        CASE
            WHEN (e.wme_datatyperef = 189) THEN e.wme_idref
            ELSE NULL::integer
        END AS idgrupywww,
        CASE
            WHEN (e.wme_datatyperef = 25) THEN e.wme_idref
            ELSE NULL::integer
        END AS idrodzajuklienta,
        CASE
            WHEN (e.wme_datatyperef = 48) THEN e.wme_idref
            ELSE NULL::integer
        END AS idwagiklienta,
        CASE
            WHEN (e.wme_datatyperef = 36) THEN e.wme_idref
            ELSE NULL::integer
        END AS iddzialu,
        CASE
            WHEN (e.wme_datatyperef = 66) THEN e.wme_idref
            ELSE NULL::integer
        END AS idfirmy,
        CASE
            WHEN (e.wme_datatyperef = 9) THEN e.wme_idref
            ELSE NULL::integer
        END AS idmagazynu,
        CASE
            WHEN (e.wme_datatyperef = 56) THEN e.wme_idref
            ELSE NULL::integer
        END AS idplanuzlecenia,
        CASE
            WHEN (e.wme_datatyperef = 145) THEN e.wme_idref
            ELSE NULL::integer
        END AS idosrodkapk,
        CASE
            WHEN (e.wme_datatyperef = 10) THEN e.wme_idref
            ELSE NULL::integer
        END AS idtowaru,
        CASE
            WHEN (e.wme_datatyperef = 0) THEN e.wme_idref
            ELSE NULL::integer
        END AS idcustom,
    false AS isdopelnienie,
    y.fm_idcentrali AS idcentrali
   FROM ((((public.kh_wymiarysumvalues s
     JOIN public.kh_konta kt ON ((kt.kt_idkonta = s.kt_idkonta)))
     JOIN public.kh_wymiaryvalues v ON ((v.wmm_idsumy = s.wmm_idsumy)))
     JOIN public.kh_wymiaryelems e ON ((e.wme_idelemu = v.wme_idelemu)))
     JOIN public.kh_lata y ON ((y.ro_idroku = kt.ro_idroku)))
  WHERE (s.mc_miesiac IS NOT NULL)
UNION
 SELECT kt.ktn_idkonta,
    s.wms_idwymiaru AS idwymiaru,
    s.mc_miesiac,
    s.wmm_valuerestwnwal AS valuewnwal,
    s.wmm_valuerestmawal AS valuemawal,
    s.wmm_valuerestwn AS valuewn,
    s.wmm_valuerestma AS valuema,
    s.wl_idwaluty AS idwaluty,
    NULL::integer AS idpracownika,
    NULL::integer AS idklienta,
    NULL::integer AS idzlecenia,
    NULL::integer AS idobiektu,
    NULL::integer AS idsrodkatrwalego,
    NULL::integer AS idgrupytowarow,
    NULL::integer AS idpodgrupytowarow,
    NULL::integer AS idgrupywww,
    NULL::integer AS idrodzajuklienta,
    NULL::integer AS idwagiklienta,
    NULL::integer AS iddzialu,
    NULL::integer AS idfirmy,
    NULL::integer AS idmagazynu,
    NULL::integer AS idplanuzlecenia,
    NULL::integer AS idosrodkapk,
    NULL::integer AS idtowaru,
    NULL::integer AS idcustom,
    true AS isdopelnienie,
    y.fm_idcentrali AS idcentrali
   FROM ((public.kh_wymiarysumvalues s
     JOIN public.kh_konta kt ON ((kt.kt_idkonta = s.kt_idkonta)))
     JOIN public.kh_lata y ON ((y.ro_idroku = kt.ro_idroku)))
  WHERE ((s.mc_miesiac IS NOT NULL) AND ((s.wmm_valuerestwn <> (0)::numeric) OR (s.wmm_valuerestma <> (0)::numeric)));
