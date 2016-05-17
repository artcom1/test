CREATE VIEW raport_sprzedaz_wg_dostawcow AS
 SELECT random() AS id,
    1 AS wplywnamagazyn,
    ("substring"(((((fv.tr_numer || '/'::text) || btrim((fv.tr_seria)::text)) || '/'::text) || (fv.tr_rok)::text), 0, 50))::character varying(50) AS numerfaktury,
    ("substring"(btrim((fv.tr_seria)::text), 0, 8))::character varying(8) AS seriafaktury,
    fv.tr_rodzaj AS rodzajfaktury,
    fv.tr_datasprzedaz AS datasprzedazy_faktury,
    date_part('year'::text, fv.tr_datasprzedaz) AS rok_sprzedazy_faktury,
    date_part('month'::text, fv.tr_datasprzedaz) AS miesiac_sprzedazy_faktury,
    date_part('week'::text, fv.tr_datasprzedaz) AS tydzien_sprzedazy_faktury,
    date_part('day'::text, fv.tr_datasprzedaz) AS dzien_sprzedazy_faktury,
    ((date_part('year'::text, fv.tr_datasprzedaz) || '.'::text) || uzupelnijmiesiac(date_part('month'::text, fv.tr_datasprzedaz))) AS rok_miesiac_sprzedazy_faktury,
    fv.tr_datawystaw AS datawystawienia_faktury,
    date_part('year'::text, fv.tr_datawystaw) AS rok_wystawienia_faktury,
    date_part('month'::text, fv.tr_datawystaw) AS miesiac_wystawienia_faktury,
    date_part('week'::text, fv.tr_datawystaw) AS tydzien_wystawienia_faktury,
    date_part('day'::text, fv.tr_datawystaw) AS dzien_wystawienia_faktury,
    ((date_part('year'::text, fv.tr_datawystaw) || '.'::text) || uzupelnijmiesiac(date_part('month'::text, fv.tr_datasprzedaz))) AS rok_miesiac_wystawienia_faktury,
    klfv.k_kod AS kodnabywcy,
    klfv.k_nazwa AS nazwanabywcy,
    kl2fv.k_kod AS kododbiorcy,
    kl2fv.k_nazwa AS nazwanaodbriorcy,
    oddzialfv.fm_nazwa AS nazwaoddzialu_sprzedazy,
    magazynfv.tmg_nazwa AS magazyn_sprzedazy,
    ("substring"(((((pz.tr_numer || '/'::text) || btrim((pz.tr_seria)::text)) || '/'::text) || (pz.tr_rok)::text), 0, 50))::character varying(50) AS numerzakupu,
    ("substring"(btrim((pz.tr_seria)::text), 0, 8))::character varying(8) AS seriazakupu,
    pz.tr_rodzaj AS rodzajzakupu,
    pz.tr_datasprzedaz AS dataprzyjecia_zakupu,
    date_part('year'::text, pz.tr_datasprzedaz) AS rok_przyjecia_zakupu,
    date_part('month'::text, pz.tr_datasprzedaz) AS miesiac_przyjecia_zakupu,
    date_part('week'::text, pz.tr_datasprzedaz) AS tydzien_przyjecia_zakupu,
    date_part('day'::text, pz.tr_datasprzedaz) AS dzien_przyjecia_zakupu,
    ((date_part('year'::text, pz.tr_datasprzedaz) || '.'::text) || uzupelnijmiesiac(date_part('month'::text, fv.tr_datasprzedaz))) AS rok_miesiac_przyjecia_zakupu,
    pz.tr_datawystaw AS datadokumentu_zakupu,
    date_part('year'::text, pz.tr_datawystaw) AS rok_dokumentu_zakupu,
    date_part('month'::text, pz.tr_datawystaw) AS miesiac_dokumentu_zakupu,
    date_part('week'::text, pz.tr_datawystaw) AS tydzien_dokumentu_zakupu,
    date_part('day'::text, pz.tr_datawystaw) AS dzien_dokumentu_zakupu,
    ((date_part('year'::text, pz.tr_datawystaw) || '.'::text) || uzupelnijmiesiac(date_part('month'::text, fv.tr_datasprzedaz))) AS rok_miesiac_dokumentu_zakupu,
    klpz.k_kod AS koddostawcy,
    klpz.k_nazwa AS nazwadostawcy,
    kl2pz.k_kod AS kodnadawcy,
    kl2pz.k_nazwa AS nazwanadawcy,
    rejpz.rj_nazwa AS rejondostawcy,
    grpz.rk_typrodzaju AS grupadostawcy,
    hanpz.p_login AS zamowil,
    menpz.p_login AS zatwierdzil,
    opiekpz.p_login AS opiekun_dostawcy,
    opiek2pz.p_login AS opiekun_nadawcy,
    oddzialpz.fm_nazwa AS nazwaoddzialu_zakupu,
    magazynpz.tmg_nazwa AS magazyn_zakupu,
    round(((((COALESCE(fvep.tel_cenadok, fve.tel_cenadok))::mpq * fve.tel_kursdok) * ((1000)::numeric)::mpq) / (fve.tel_przelnilosci)::mpq), 2) AS cenasprzedazy_jednmag_pln,
    ((('-1'::integer * ruchywz.rc_wspmag))::numeric * ruchywz.rc_ilosc) AS ilosc_jednmag_sprzedazy,
    ((('-1'::integer * ruchywz.rc_wspmag))::numeric * round((((((COALESCE(fvep.tel_cenadok, fve.tel_cenadok))::mpq * fve.tel_kursdok) * (ruchywz.rc_ilosc)::mpq) * ((1000)::numeric)::mpq) / (fve.tel_przelnilosci)::mpq), 2)) AS wartoscsprzedazypln,
    ruchypz.rc_cenajedn AS cenazakupu,
    ((('-1'::integer * ruchywz.rc_wspmag))::numeric * round((ruchypz.rc_cenajedn * ruchywz.rc_ilosc), 2)) AS wartosczakupu,
    getkoszttranportudlaraportuwgdostawcow((fve.tel_narzut * ruchywz.rc_ilosc), fve.tel_iloscf) AS koszttransportupln,
    tw.ttw_nazwa AS nazwatowaru,
    tw.ttw_klucz AS kodtowaru,
    grtow.tgr_nazwa AS grupa_i,
    pgrtow.tpg_nazwa AS grupa_ii,
    ruchypz.rc_wspmag AS pzwsmag,
    ruchywz.rc_wspmag AS wzwsmag
   FROM (((((((((((((((((((((((tg_transakcje fv
     JOIN tg_transelem fve USING (tr_idtrans))
     LEFT JOIN tg_transelem fvep ON (((fve.tel_skojarzony = fvep.tel_skojarzony) AND (fve.tel_idelem <> fvep.tel_idelem))))
     JOIN tg_transelem wze ON ((wze.tel_skojlog = fve.tel_idelem)))
     JOIN tg_ruchy ruchywz ON ((ruchywz.tel_idelem = wze.tel_idelem)))
     JOIN tg_ruchy ruchypz ON ((ruchywz.rc_dostawa = ruchypz.rc_idruchu)))
     JOIN tg_transakcje pz ON ((ruchypz.tr_idtrans = pz.tr_idtrans)))
     JOIN tb_klient klfv ON ((fv.k_idklienta = klfv.k_idklienta)))
     JOIN tb_klient kl2fv ON ((fv.tr_oidklienta = kl2fv.k_idklienta)))
     JOIN tb_klient klpz ON ((klpz.k_idklienta = pz.k_idklienta)))
     JOIN tb_klient kl2pz ON ((kl2pz.k_idklienta = pz.tr_oidklienta)))
     LEFT JOIN ts_regiony rejpz ON ((rejpz.rj_idregionu = klpz.rj_idregionu)))
     LEFT JOIN ts_rodzajklienta grpz ON ((grpz.rk_idrodzajklienta = klpz.rk_idrodzajklienta)))
     LEFT JOIN tb_pracownicy hanpz ON ((hanpz.p_idpracownika = pz.tr_zaliczonedla)))
     LEFT JOIN tb_pracownicy menpz ON ((menpz.p_idpracownika = pz.tr_zaliczonoukl)))
     LEFT JOIN tb_pracownicy opiekpz ON ((opiekpz.p_idpracownika = klpz.p_idpracownika)))
     LEFT JOIN tb_pracownicy opiek2pz ON ((opiek2pz.p_idpracownika = kl2pz.p_idpracownika)))
     JOIN tg_towary tw ON ((fve.ttw_idtowaru = tw.ttw_idtowaru)))
     JOIN tg_grupytow grtow ON ((grtow.tgr_idgrupy = tw.tgr_idgrupy)))
     JOIN tg_podgrupytow pgrtow ON ((pgrtow.tpg_idpodgrupy = tw.tpg_idpodgrupy)))
     LEFT JOIN tg_magazyny magazynfv ON ((magazynfv.tmg_idmagazynu = ruchywz.tmg_idmagazynu)))
     LEFT JOIN tb_firma oddzialfv ON ((oddzialfv.fm_index = magazynfv.fm_index)))
     LEFT JOIN tg_magazyny magazynpz ON ((magazynpz.tmg_idmagazynu = ruchypz.tmg_idmagazynu)))
     LEFT JOIN tb_firma oddzialpz ON ((oddzialpz.fm_index = magazynpz.fm_index)))
  WHERE ((fv.tr_rodzaj = ANY (ARRAY[1, 11])) AND (fv.tr_datawystaw >= '2006-01-01'::date))
UNION
 SELECT random() AS id,
    0 AS wplywnamagazyn,
    ("substring"(((((fv.tr_numer || '/'::text) || btrim((fv.tr_seria)::text)) || '/'::text) || (fv.tr_rok)::text), 0, 50))::character varying(50) AS numerfaktury,
    ("substring"(btrim((fv.tr_seria)::text), 0, 8))::character varying(8) AS seriafaktury,
    fv.tr_rodzaj AS rodzajfaktury,
    fv.tr_datasprzedaz AS datasprzedazy_faktury,
    date_part('year'::text, fv.tr_datasprzedaz) AS rok_sprzedazy_faktury,
    date_part('month'::text, fv.tr_datasprzedaz) AS miesiac_sprzedazy_faktury,
    date_part('week'::text, fv.tr_datasprzedaz) AS tydzien_sprzedazy_faktury,
    date_part('day'::text, fv.tr_datasprzedaz) AS dzien_sprzedazy_faktury,
    ((date_part('year'::text, fv.tr_datasprzedaz) || '.'::text) || uzupelnijmiesiac(date_part('month'::text, fv.tr_datasprzedaz))) AS rok_miesiac_sprzedazy_faktury,
    fv.tr_datawystaw AS datawystawienia_faktury,
    date_part('year'::text, fv.tr_datawystaw) AS rok_wystawienia_faktury,
    date_part('month'::text, fv.tr_datawystaw) AS miesiac_wystawienia_faktury,
    date_part('week'::text, fv.tr_datawystaw) AS tydzien_wystawienia_faktury,
    date_part('day'::text, fv.tr_datawystaw) AS dzien_wystawienia_faktury,
    ((date_part('year'::text, fv.tr_datawystaw) || '.'::text) || uzupelnijmiesiac(date_part('month'::text, fv.tr_datasprzedaz))) AS rok_miesiac_wystawienia_faktury,
    klfv.k_kod AS kodnabywcy,
    klfv.k_nazwa AS nazwanabywcy,
    kl2fv.k_kod AS kododbiorcy,
    kl2fv.k_nazwa AS nazwanaodbriorcy,
    oddzialfv.fm_nazwa AS nazwaoddzialu_sprzedazy,
    magazynfv.tmg_nazwa AS magazyn_sprzedazy,
    ("substring"(((((pz.tr_numer || '/'::text) || btrim((pz.tr_seria)::text)) || '/'::text) || (pz.tr_rok)::text), 0, 50))::character varying(50) AS numerzakupu,
    ("substring"(btrim((pz.tr_seria)::text), 0, 8))::character varying(8) AS seriazakupu,
    pz.tr_rodzaj AS rodzajzakupu,
    pz.tr_datasprzedaz AS dataprzyjecia_zakupu,
    date_part('year'::text, pz.tr_datasprzedaz) AS rok_przyjecia_zakupu,
    date_part('month'::text, pz.tr_datasprzedaz) AS miesiac_przyjecia_zakupu,
    date_part('week'::text, pz.tr_datasprzedaz) AS tydzien_przyjecia_zakupu,
    date_part('day'::text, pz.tr_datasprzedaz) AS dzien_przyjecia_zakupu,
    ((date_part('year'::text, pz.tr_datasprzedaz) || '.'::text) || uzupelnijmiesiac(date_part('month'::text, fv.tr_datasprzedaz))) AS rok_miesiac_przyjecia_zakupu,
    pz.tr_datawystaw AS datadokumentu_zakupu,
    date_part('year'::text, pz.tr_datawystaw) AS rok_dokumentu_zakupu,
    date_part('month'::text, pz.tr_datawystaw) AS miesiac_dokumentu_zakupu,
    date_part('week'::text, pz.tr_datawystaw) AS tydzien_dokumentu_zakupu,
    date_part('day'::text, pz.tr_datawystaw) AS dzien_dokumentu_zakupu,
    ((date_part('year'::text, pz.tr_datawystaw) || '.'::text) || uzupelnijmiesiac(date_part('month'::text, fv.tr_datasprzedaz))) AS rok_miesiac_dokumentu_zakupu,
    klpz.k_kod AS koddostawcy,
    klpz.k_nazwa AS nazwadostawcy,
    kl2pz.k_kod AS kodnadawcy,
    kl2pz.k_nazwa AS nazwanadawcy,
    rejpz.rj_nazwa AS rejondostawcy,
    grpz.rk_typrodzaju AS grupadostawcy,
    hanpz.p_login AS zamowil,
    menpz.p_login AS zatwierdzil,
    opiekpz.p_login AS opiekun_dostawcy,
    opiek2pz.p_login AS opiekun_nadawcy,
    oddzialpz.fm_nazwa AS nazwaoddzialu_zakupu,
    magazynpz.tmg_nazwa AS magazyn_zakupu,
    round(((((fve.tel_cenadok)::mpq * fve.tel_kursdok) * ((1000)::numeric)::mpq) / (fve.tel_przelnilosci)::mpq), 2) AS cenasprzedazy_jednmag_pln,
    (sign(fve.tel_iloscf) * ruchywz.rc_iloscpoz) AS ilosc_jednmag_sprzedazy,
    (sign(fve.tel_iloscf) * round((((((fve.tel_cenadok)::mpq * fve.tel_kursdok) * (ruchywz.rc_iloscpoz)::mpq) * ((1000)::numeric)::mpq) / (fve.tel_przelnilosci)::mpq), 2)) AS wartoscsprzedazypln,
    0 AS cenazakupu,
    0 AS wartosczakupu,
    0 AS koszttransportupln,
    tw.ttw_nazwa AS nazwatowaru,
    tw.ttw_klucz AS kodtowaru,
    grtow.tgr_nazwa AS grupa_i,
    pgrtow.tpg_nazwa AS grupa_ii,
    ruchypz.rc_wspmag AS pzwsmag,
    ruchywz.rc_wspmag AS wzwsmag
   FROM (((((((((((((((((((((((tg_transakcje fv
     JOIN tg_transelem fve USING (tr_idtrans))
     JOIN tg_transelem fvefv ON ((fvefv.tel_idelem = fve.tel_skojarzony)))
     JOIN tg_transelem wze ON ((wze.tel_skojlog = fvefv.tel_idelem)))
     JOIN tg_ruchy ruchywz ON ((ruchywz.tel_idelem = wze.tel_idelem)))
     JOIN tg_ruchy ruchypz ON ((ruchywz.rc_dostawa = ruchypz.rc_idruchu)))
     JOIN tg_transakcje pz ON ((ruchypz.tr_idtrans = pz.tr_idtrans)))
     JOIN tb_klient klfv ON ((fv.k_idklienta = klfv.k_idklienta)))
     JOIN tb_klient kl2fv ON ((fv.tr_oidklienta = kl2fv.k_idklienta)))
     JOIN tb_klient klpz ON ((klpz.k_idklienta = pz.k_idklienta)))
     JOIN tb_klient kl2pz ON ((kl2pz.k_idklienta = pz.tr_oidklienta)))
     LEFT JOIN ts_regiony rejpz ON ((rejpz.rj_idregionu = klpz.rj_idregionu)))
     LEFT JOIN ts_rodzajklienta grpz ON ((grpz.rk_idrodzajklienta = klpz.rk_idrodzajklienta)))
     LEFT JOIN tb_pracownicy hanpz ON ((hanpz.p_idpracownika = pz.tr_zaliczonedla)))
     LEFT JOIN tb_pracownicy menpz ON ((menpz.p_idpracownika = pz.tr_zaliczonoukl)))
     LEFT JOIN tb_pracownicy opiekpz ON ((opiekpz.p_idpracownika = klpz.p_idpracownika)))
     LEFT JOIN tb_pracownicy opiek2pz ON ((opiek2pz.p_idpracownika = kl2pz.p_idpracownika)))
     JOIN tg_towary tw ON ((fve.ttw_idtowaru = tw.ttw_idtowaru)))
     JOIN tg_grupytow grtow ON ((grtow.tgr_idgrupy = tw.tgr_idgrupy)))
     JOIN tg_podgrupytow pgrtow ON ((pgrtow.tpg_idpodgrupy = tw.tpg_idpodgrupy)))
     LEFT JOIN tg_magazyny magazynfv ON ((magazynfv.tmg_idmagazynu = ruchywz.tmg_idmagazynu)))
     LEFT JOIN tb_firma oddzialfv ON ((oddzialfv.fm_index = magazynfv.fm_index)))
     LEFT JOIN tg_magazyny magazynpz ON ((magazynpz.tmg_idmagazynu = ruchypz.tmg_idmagazynu)))
     LEFT JOIN tb_firma oddzialpz ON ((oddzialpz.fm_index = magazynpz.fm_index)))
  WHERE ((fv.tr_rodzaj = 11) AND isfv(ruchywz.rc_flaga) AND ispzet(ruchypz.rc_flaga) AND (fv.tr_datawystaw >= '2006-01-01'::date));
