CREATE VIEW raport_analiza_zakupow_towaru AS
 SELECT tr.tr_datasprzedaz AS dataprzyjecia,
    date_part('year'::text, tr.tr_datasprzedaz) AS rok_przyjecia,
    date_part('month'::text, tr.tr_datasprzedaz) AS miesiac_przyjecia,
    date_part('week'::text, tr.tr_datasprzedaz) AS tydzien_przyjecia,
    date_part('day'::text, tr.tr_datasprzedaz) AS dzien_przyjecia,
    tr.tr_datawystaw AS datawystawienia,
    date_part('year'::text, tr.tr_datawystaw) AS rok_wystawienia,
    date_part('month'::text, tr.tr_datawystaw) AS miesiac_wystawienia,
    date_part('week'::text, tr.tr_datawystaw) AS tydzien_wystawienia,
    date_part('day'::text, tr.tr_datawystaw) AS dzien_wystawienia,
    ((date_part('year'::text, tr.tr_datasprzedaz) || '.'::text) || uzupelnijmiesiac(date_part('month'::text, tr.tr_datasprzedaz))) AS rok_miesiac_przyjecia,
    ((date_part('year'::text, tr.tr_datawystaw) || '.'::text) || uzupelnijmiesiac(date_part('month'::text, tr.tr_datawystaw))) AS rok_miesiac_wystawienia,
    ("substring"(((((((tr.tr_numer || '/'::text) || btrim((tr.tr_seria)::text)) || '/'::text) || (COALESCE(rodzaje.trt_skrot, ''''::character varying))::text) || '/'::text) || (tr.tr_rok)::text), 0, 50))::character varying(50) AS numerdokumentu,
    ("substring"(btrim((tr.tr_seria)::text), 0, 8))::character varying(8) AS seria,
    ("substring"(tr.tr_nrobcy, 0, 40))::character varying(40) AS numerobcy,
    tr.tr_rodzaj AS rodzajdokumentu,
    (round(((tr.tr_wartosc)::mpq * tr.tr_przelicznik), 2))::double precision AS wartoscdokumentunettopln,
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
    (round((pozycje.wartoscsprzedazy * (mnoznikkorekt(tr.tr_zamknieta))::numeric), 2))::double precision AS wartosczakupu,
    (pozycje.cenatowaru)::double precision AS cenatowaru,
    (pozycje.kosztnabycia)::double precision AS kosztnabyciatowaru,
    dokumentkorekta(tr.tr_rodzaj) AS dokumentkorekta,
    cen.fm_nazwaskr AS kodcentrali,
    cen.fm_nazwa AS nazwacentrali
   FROM ((((((((((((tg_transakcje tr
     JOIN ( SELECT tg_transelem.tr_idtrans,
            round(tg_transelem.tel_iloscf, 4) AS ilosctowaru,
            tg_transelem.tel_kosztnabycia AS kosztnabycia,
            tg_towary.ttw_nazwa,
            tg_towary.ttw_klucz,
            tg_towary.tgr_idgrupy,
            tg_towary.tpg_idpodgrupy,
            round(((tg_transelem.tel_cenawal)::mpq * tg_transelem.tel_kurswal), 2) AS cenatowaru,
            getwartoscpln(tg_transelem.tel_ilosc, tg_transelem.tel_cenawal, tg_transelem.tel_kurswal) AS wartoscsprzedazy
           FROM (tg_transelem
             JOIN tg_towary USING (ttw_idtowaru))) pozycje USING (tr_idtrans))
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
     LEFT JOIN tb_firma cen ON ((cen.fm_index = tr.fm_idcentrali)))
  WHERE (tr.tr_rodzaj = ANY (ARRAY[0, 10, 100, 200, 111, 211]));
