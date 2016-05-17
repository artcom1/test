CREATE VIEW raport_analiza_sprzedazy_towaru AS
 SELECT tr.tr_datasprzedaz AS datasprzedazy,
    date_part('year'::text, tr.tr_datasprzedaz) AS rok_sprzedazy,
    date_part('month'::text, tr.tr_datasprzedaz) AS miesiac_sprzedazy,
    date_part('week'::text, tr.tr_datasprzedaz) AS tydzien_sprzedazy,
    date_part('day'::text, tr.tr_datasprzedaz) AS dzien_sprzedazy,
    tr.tr_datawystaw AS datawystawienia,
    date_part('year'::text, tr.tr_datawystaw) AS rok_wystawienia,
    date_part('month'::text, tr.tr_datawystaw) AS miesiac_wystawienia,
    date_part('week'::text, tr.tr_datawystaw) AS tydzien_wystawienia,
    date_part('day'::text, tr.tr_datawystaw) AS dzien_wystawienia,
    ((date_part('year'::text, tr.tr_datasprzedaz) || '.'::text) || uzupelnijmiesiac((date_part('month'::text, tr.tr_datasprzedaz))::text)) AS rok_miesiac_sprzedaz,
    ((date_part('year'::text, tr.tr_datawystaw) || '.'::text) || uzupelnijmiesiac((date_part('month'::text, tr.tr_datawystaw))::text)) AS rok_miesiac_wystawienia,
    (((("substring"(((((tr.tr_numer || '/'::text) || btrim((tr.tr_seria)::text)) || '/'::text) || (tr.tr_rok)::text), 0, 50))::character varying(50))::text || '/'::text) || (COALESCE(rodzaje.trt_skrot, ''''::character varying))::text) AS numerdokumentu,
    ("substring"(btrim((tr.tr_seria)::text), 0, 8))::character varying(8) AS seria,
    ("substring"(tr.tr_nrobcy, 0, 40))::character varying(40) AS numerobcy,
    tr.tr_rodzaj AS rodzajdokumentu,
    (pozycje.wartoscsprzedazypln)::double precision AS wartoscdokumentunettopln,
    n.k_kod AS kodnabywcy,
    n.k_nazwa AS nazwanabywcy,
    n.rj_nazwa AS rejonnabywcy,
    o.k_kod AS kododbiorcy,
    o.k_nazwa AS nazwaodbiorcy,
    o.rj_nazwa AS rejonodbiorcy,
    nrzecz.k_kod AS kodnarzecz,
    nrzecz.k_nazwa AS nazwanarzecz,
    nrzecz.rj_nazwa AS rejonnarzecz,
    p.p_login AS handlowiec,
    u.p_login AS merchandiser,
    pozycje.ttw_nazwa AS nazwatowaru,
    pozycje.ttw_klucz AS kodtowaru,
    g1.tgr_nazwa AS grupa_i,
    g2.tpg_nazwa AS grupa_ii,
    grnabywcy.rk_typrodzaju AS grupanabywcy,
    grodbiorcy.rk_typrodzaju AS grupaodbiorcy,
    ((pozycje.ilosctowaru * (mnoznikkorekt(tr.tr_zamknieta))::numeric))::double precision AS ilosctowaru,
    (pozycje.wartoscsprzedazy)::double precision AS wartoscsprzedazy,
    (pozycje.cenatowaru)::double precision AS cenatowaru,
    (pozycje.kosztnabycia)::double precision AS kosztnabyciatowaru,
    (round((pozycje.wartoscsprzedazypln - pozycje.kosztnabycia), 2))::double precision AS marzatowaru,
    dokumentkorekta(tr.tr_rodzaj) AS dokumentkorekta,
    jed.tjn_nazwa AS nazwajednostki,
    jed.tjn_skrot AS skrotjednostki,
    pozycje.ttw_usluga AS usluga,
    opk.opk_nazwa AS opk,
    firma.fm_nazwa AS nazwaoddzialu,
    pozycje.tmg_nazwa AS magazyn,
    pozycje.koszttrans AS koszttransportu,
    wal.wl_nazwa AS walutanazwa,
    wal.wl_skrot AS waluta,
    pozycje.ttw_waga AS waganetto,
    pozycje.ttw_wagaoppod AS wagatara,
    cen.fm_nazwaskr AS kodcentrali,
    cen.fm_nazwa AS nazwacentrali
   FROM ((((((((((((((((tg_transakcje tr
     JOIN ( SELECT te.tr_idtrans,
            round(te.tel_iloscf, 4) AS ilosctowaru,
            te.tel_kosztnabycia AS kosztnabycia,
            tw.ttw_nazwa,
            tw.ttw_klucz,
            tw.tgr_idgrupy,
            tw.tpg_idpodgrupy,
            round(((te.tel_cenawal)::mpq * te.tel_kurswal), 2) AS cenatowaru,
            round(((getwartoscnetto(te.tel_ilosc, te.tel_cenawal, te.tel_cenabwal, te.tel_flaga, te.tel_stvat))::mpq * te.tel_kurswal), 2) AS wartoscsprzedazypln,
            getwartoscnetto(te.tel_ilosc, te.tel_cenadok, te.tel_cenabdok, te.tel_flaga, te.tel_stvat) AS wartoscsprzedazy,
            tw.tjn_idjedn,
            tw.ttw_usluga,
            mag.opk_idosrodka,
            mag.tmg_nazwa,
            te.tel_narzut AS koszttrans,
            tw.ttw_waga,
            tw.ttw_wagaoppod
           FROM (((tg_transelem te
             JOIN tg_towary tw USING (ttw_idtowaru))
             JOIN tg_towmag towmag ON ((te.ttm_idtowmag = towmag.ttm_idtowmag)))
             JOIN tg_magazyny mag ON ((towmag.tmg_idmagazynu = mag.tmg_idmagazynu)))) pozycje USING (tr_idtrans))
     LEFT JOIN ( SELECT DISTINCT ON (tg_rodzajtransakcji.tr_rodzaj) tg_rodzajtransakcji.tr_rodzaj,
            tg_rodzajtransakcji.trt_skrot
           FROM tg_rodzajtransakcji) rodzaje USING (tr_rodzaj))
     JOIN ( SELECT tb_pracownicy.p_idpracownika,
            tb_pracownicy.p_login
           FROM tb_pracownicy) p ON ((tr.tr_zaliczonedla = p.p_idpracownika)))
     LEFT JOIN ( SELECT tb_pracownicy.p_idpracownika,
            tb_pracownicy.p_login
           FROM tb_pracownicy) u ON ((tr.tr_zaliczonoukl = u.p_idpracownika)))
     LEFT JOIN ( SELECT tg_grupytow.tgr_nazwa,
            tg_grupytow.tgr_idgrupy
           FROM tg_grupytow) g1 ON ((pozycje.tgr_idgrupy = g1.tgr_idgrupy)))
     LEFT JOIN ( SELECT tg_podgrupytow.tpg_nazwa,
            tg_podgrupytow.tpg_idpodgrupy
           FROM tg_podgrupytow) g2 ON ((pozycje.tpg_idpodgrupy = g2.tpg_idpodgrupy)))
     LEFT JOIN ( SELECT tb_klient.k_idklienta,
            tb_klient.k_kod,
            tb_klient.k_nazwa,
            ts_regiony.rj_nazwa,
            tb_klient.rk_idrodzajklienta
           FROM (tb_klient
             LEFT JOIN ts_regiony USING (rj_idregionu))) n ON ((tr.k_idklienta = n.k_idklienta)))
     LEFT JOIN ( SELECT tb_klient.k_idklienta,
            tb_klient.k_kod,
            tb_klient.k_nazwa,
            ts_regiony.rj_nazwa,
            tb_klient.rk_idrodzajklienta
           FROM (tb_klient
             LEFT JOIN ts_regiony USING (rj_idregionu))) o ON ((tr.tr_oidklienta = o.k_idklienta)))
     LEFT JOIN ( SELECT tb_klient.k_idklienta,
            tb_klient.k_kod,
            tb_klient.k_nazwa,
            ts_regiony.rj_nazwa
           FROM (tb_klient
             LEFT JOIN ts_regiony USING (rj_idregionu))) nrzecz ON ((tr.tr_narzecz = nrzecz.k_idklienta)))
     LEFT JOIN ( SELECT ts_rodzajklienta.rk_idrodzajklienta,
            ts_rodzajklienta.rk_typrodzaju
           FROM ts_rodzajklienta) grnabywcy ON ((n.rk_idrodzajklienta = grnabywcy.rk_idrodzajklienta)))
     LEFT JOIN ( SELECT ts_rodzajklienta.rk_idrodzajklienta,
            ts_rodzajklienta.rk_typrodzaju
           FROM ts_rodzajklienta) grodbiorcy ON ((o.rk_idrodzajklienta = grodbiorcy.rk_idrodzajklienta)))
     LEFT JOIN ( SELECT ts_osrodkipk.opk_nazwa,
            ts_osrodkipk.opk_idosrodka
           FROM ts_osrodkipk) opk USING (opk_idosrodka))
     LEFT JOIN tb_firma firma USING (fm_index))
     LEFT JOIN tg_jednostki jed USING (tjn_idjedn))
     LEFT JOIN tg_waluty wal USING (wl_idwaluty))
     LEFT JOIN tb_firma cen ON ((cen.fm_index = tr.fm_idcentrali)))
  WHERE (tr.tr_rodzaj = ANY (ARRAY[1, 11, 7, 17]));
