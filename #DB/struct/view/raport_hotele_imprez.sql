CREATE VIEW raport_hotele_imprez AS
 SELECT tmp.data_przyjecia_zlecenia,
    tmp.rok_przyjecia_zlecenia,
    tmp.miesiac_przyjecia_zlecenia,
    tmp.tydzien_przyjecia_zlecenia,
    tmp.dzien_przyjecia_zlecenia,
    tmp.data_zamkniecia_zlecenia,
    tmp.rok_zamkniecia_zlecenia,
    tmp.miesiac_zamkniecia_zlecenia,
    tmp.tydzien_zamkniecia_zlecenia,
    tmp.dzien_zamkniecia_zlecenia,
    tmp.data_rozpoczecia_zlecenia,
    tmp.rok_rozpoczecia_zlec,
    tmp.miesiac_rozpoczecia_zlec,
    tmp.tydzien_rozpoczecia_zlec,
    tmp.dzien_rozpoczecia_zlec,
    tmp.data_zakonczenia_zlecenia,
    tmp.rok_zakonczenia_zlecenia,
    tmp.miesiac_zakonczenia_zlecenia,
    tmp.tydzien_zakonczenia_zlecenia,
    tmp.dzien_zakonczenia_zlecenia,
    tmp.rok_miesiac_przyjecia_zlecenia,
    tmp.rok_miesiac_zamkniecia_zlecenia,
    tmp.rok_miesiac_rozpoczecia_zlec,
    tmp.rok_miesiac_zakonczenia_zlec,
    tmp.numer_zlecenia,
    tmp.seria,
    tmp.kod_zlecenia,
    tmp.rodzajzlecenia,
    tmp.kododbiorcy_zlecenia,
    tmp.nazwaodbiorcy_zlecenia,
    tmp.rejonodbiorcy_zlecenia,
    tmp.kodzlecajacego_zlecenia,
    tmp.nazwazlecajacego_zlecenia,
    tmp.rejonzlecajacego_zlecenia,
    tmp.kodkontrahenta_zlecenia,
    tmp.nazwakontrahenta_zlecenia,
    tmp.rejonkontrahenta_zlecenia,
    tmp.odpowiedzialny,
    tmp.grupa_i,
    tmp.grupa_ii,
    tmp.obciazenie_hotelu,
    tmp.koszt
   FROM ( SELECT date(tg_zlecenia.zl_datazlecenia) AS data_przyjecia_zlecenia,
            date_part('year'::text, tg_zlecenia.zl_datazlecenia) AS rok_przyjecia_zlecenia,
            date_part('month'::text, tg_zlecenia.zl_datazlecenia) AS miesiac_przyjecia_zlecenia,
            date_part('week'::text, tg_zlecenia.zl_datazlecenia) AS tydzien_przyjecia_zlecenia,
            date_part('day'::text, tg_zlecenia.zl_datazlecenia) AS dzien_przyjecia_zlecenia,
            tg_zlecenia.zl_datazamkniecia AS data_zamkniecia_zlecenia,
            date_part('year'::text, tg_zlecenia.zl_datazamkniecia) AS rok_zamkniecia_zlecenia,
            date_part('month'::text, tg_zlecenia.zl_datazamkniecia) AS miesiac_zamkniecia_zlecenia,
            date_part('week'::text, tg_zlecenia.zl_datazamkniecia) AS tydzien_zamkniecia_zlecenia,
            date_part('day'::text, tg_zlecenia.zl_datazamkniecia) AS dzien_zamkniecia_zlecenia,
            date(tg_zlecenia.zl_datarozpoczecia) AS data_rozpoczecia_zlecenia,
            date_part('year'::text, tg_zlecenia.zl_datarozpoczecia) AS rok_rozpoczecia_zlec,
            date_part('month'::text, tg_zlecenia.zl_datarozpoczecia) AS miesiac_rozpoczecia_zlec,
            date_part('week'::text, tg_zlecenia.zl_datarozpoczecia) AS tydzien_rozpoczecia_zlec,
            date_part('day'::text, tg_zlecenia.zl_datarozpoczecia) AS dzien_rozpoczecia_zlec,
            date(tg_zlecenia.zl_datazakonczenia) AS data_zakonczenia_zlecenia,
            date_part('year'::text, tg_zlecenia.zl_datazakonczenia) AS rok_zakonczenia_zlecenia,
            date_part('month'::text, tg_zlecenia.zl_datazakonczenia) AS miesiac_zakonczenia_zlecenia,
            date_part('week'::text, tg_zlecenia.zl_datazakonczenia) AS tydzien_zakonczenia_zlecenia,
            date_part('day'::text, tg_zlecenia.zl_datazakonczenia) AS dzien_zakonczenia_zlecenia,
            (((date_part('year'::text, tg_zlecenia.zl_datazlecenia))::text || '.'::text) || uzupelnijmiesiac((date_part('month'::text, tg_zlecenia.zl_datazlecenia))::text)) AS rok_miesiac_przyjecia_zlecenia,
            (((date_part('year'::text, tg_zlecenia.zl_datazamkniecia))::text || '.'::text) || uzupelnijmiesiac((date_part('month'::text, tg_zlecenia.zl_datazamkniecia))::text)) AS rok_miesiac_zamkniecia_zlecenia,
            (((date_part('year'::text, tg_zlecenia.zl_datarozpoczecia))::text || '.'::text) || uzupelnijmiesiac((date_part('month'::text, tg_zlecenia.zl_datarozpoczecia))::text)) AS rok_miesiac_rozpoczecia_zlec,
            (((date_part('year'::text, tg_zlecenia.zl_datazakonczenia))::text || '.'::text) || uzupelnijmiesiac((date_part('month'::text, tg_zlecenia.zl_datazakonczenia))::text)) AS rok_miesiac_zakonczenia_zlec,
            ("substring"(((((((tg_zlecenia.zl_nrzlecenia)::text || '/'::text) || btrim((tg_zlecenia.zl_seria)::text)) || '/'::text) || (tg_zlecenia.zl_rok)::text) || '/ZLP'::text), 0, 50))::character varying(50) AS numer_zlecenia,
            ("substring"(btrim((tg_zlecenia.zl_seria)::text), 0, 8))::character varying(8) AS seria,
            ("substring"(tg_zlecenia.zl_nazwa, 0, 50))::character varying(50) AS kod_zlecenia,
            tg_zlecenia.zl_typ AS rodzajzlecenia,
            n.k_kod AS kododbiorcy_zlecenia,
            n.k_nazwa AS nazwaodbiorcy_zlecenia,
            n.rj_nazwa AS rejonodbiorcy_zlecenia,
            o.k_kod AS kodzlecajacego_zlecenia,
            o.k_nazwa AS nazwazlecajacego_zlecenia,
            o.rj_nazwa AS rejonzlecajacego_zlecenia,
            h.k_kod AS kodkontrahenta_zlecenia,
            h.k_nazwa AS nazwakontrahenta_zlecenia,
            h.rj_nazwa AS rejonkontrahenta_zlecenia,
            p.p_login AS odpowiedzialny,
            g1.tgr_nazwa AS grupa_i,
            g2.tpg_nazwa AS grupa_ii,
            0 AS obciazenie_hotelu,
            (round((pozycje.koszt * (mnoznikkorekt(pozycje.tr_zamknieta))::numeric), 2))::double precision AS koszt
           FROM (((((((tg_zlecenia
             LEFT JOIN ( SELECT tg_transakcje.tr_idtrans,
                    tg_transakcje.tr_zamknieta,
                    tg_transakcje.k_idklienta,
                    tg_transakcje.zl_idzlecenia,
                    getwartoscpln(tg_transelem.tel_ilosc, tg_transelem.tel_cenawal, tg_transelem.tel_kurswal) AS koszt,
                    tg_towary.tgr_idgrupy,
                    tg_towary.tpg_idpodgrupy
                   FROM ((tg_transakcje
                     JOIN tg_transelem USING (tr_idtrans))
                     JOIN tg_towary USING (ttw_idtowaru))
                  WHERE (tg_transakcje.tr_rodzaj = 45)) pozycje USING (zl_idzlecenia))
             LEFT JOIN ( SELECT tb_pracownicy.p_idpracownika,
                    tb_pracownicy.p_login
                   FROM tb_pracownicy) p ON ((tg_zlecenia.p_odpowiedzialny = p.p_idpracownika)))
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
                     LEFT JOIN ts_regiony USING (rj_idregionu))) n ON ((tg_zlecenia.k_idklienta = n.k_idklienta)))
             LEFT JOIN ( SELECT tb_klient.k_idklienta,
                    tb_klient.k_kod,
                    tb_klient.k_nazwa,
                    ts_regiony.rj_nazwa,
                    tb_klient.rk_idrodzajklienta
                   FROM (tb_klient
                     LEFT JOIN ts_regiony USING (rj_idregionu))) o ON ((tg_zlecenia.k_idzlecajacy = o.k_idklienta)))
             LEFT JOIN ( SELECT tb_klient.k_idklienta,
                    tb_klient.k_kod,
                    tb_klient.k_nazwa,
                    ts_regiony.rj_nazwa,
                    tb_klient.rk_idrodzajklienta
                   FROM (tb_klient
                     LEFT JOIN ts_regiony USING (rj_idregionu))) h ON ((pozycje.k_idklienta = h.k_idklienta)))
        UNION
         SELECT date(tg_zlecenia.zl_datazlecenia) AS data_przyjecia_zlecenia,
            date_part('year'::text, tg_zlecenia.zl_datazlecenia) AS rok_przyjecia_zlecenia,
            date_part('month'::text, tg_zlecenia.zl_datazlecenia) AS miesiac_przyjecia_zlecenia,
            date_part('week'::text, tg_zlecenia.zl_datazlecenia) AS tydzien_przyjecia_zlecenia,
            date_part('day'::text, tg_zlecenia.zl_datazlecenia) AS dzien_przyjecia_zlecenia,
            tg_zlecenia.zl_datazamkniecia AS data_zamkniecia_zlecenia,
            date_part('year'::text, tg_zlecenia.zl_datazamkniecia) AS rok_zamkniecia_zlecenia,
            date_part('month'::text, tg_zlecenia.zl_datazamkniecia) AS miesiac_zamkniecia_zlecenia,
            date_part('week'::text, tg_zlecenia.zl_datazamkniecia) AS tydzien_zamkniecia_zlecenia,
            date_part('day'::text, tg_zlecenia.zl_datazamkniecia) AS dzien_zamkniecia_zlecenia,
            date(tg_zlecenia.zl_datarozpoczecia) AS data_rozpoczecia_zlecenia,
            date_part('year'::text, tg_zlecenia.zl_datarozpoczecia) AS rok_rozpoczecia_zlec,
            date_part('month'::text, tg_zlecenia.zl_datarozpoczecia) AS miesiac_rozpoczecia_zlec,
            date_part('week'::text, tg_zlecenia.zl_datarozpoczecia) AS tydzien_rozpoczecia_zlec,
            date_part('day'::text, tg_zlecenia.zl_datarozpoczecia) AS dzien_rozpoczecia_zlec,
            date(tg_zlecenia.zl_datazakonczenia) AS data_zakonczenia_zlecenia,
            date_part('year'::text, tg_zlecenia.zl_datazakonczenia) AS rok_zakonczenia_zlecenia,
            date_part('month'::text, tg_zlecenia.zl_datazakonczenia) AS miesiac_zakonczenia_zlecenia,
            date_part('week'::text, tg_zlecenia.zl_datazakonczenia) AS tydzien_zakonczenia_zlecenia,
            date_part('day'::text, tg_zlecenia.zl_datazakonczenia) AS dzien_zakonczenia_zlecenia,
            (((date_part('year'::text, tg_zlecenia.zl_datazlecenia))::text || '.'::text) || uzupelnijmiesiac((date_part('month'::text, tg_zlecenia.zl_datazlecenia))::text)) AS rok_miesiac_przyjecia_zlecenia,
            (((date_part('year'::text, tg_zlecenia.zl_datazamkniecia))::text || '.'::text) || uzupelnijmiesiac((date_part('month'::text, tg_zlecenia.zl_datazamkniecia))::text)) AS rok_miesiac_zamkniecia_zlecenia,
            (((date_part('year'::text, tg_zlecenia.zl_datarozpoczecia))::text || '.'::text) || uzupelnijmiesiac((date_part('month'::text, tg_zlecenia.zl_datarozpoczecia))::text)) AS rok_miesiac_rozpoczecia_zlec,
            (((date_part('year'::text, tg_zlecenia.zl_datazakonczenia))::text || '.'::text) || uzupelnijmiesiac((date_part('month'::text, tg_zlecenia.zl_datazakonczenia))::text)) AS rok_miesiac_zakonczenia_zlec,
            ("substring"(((((((tg_zlecenia.zl_nrzlecenia)::text || '/'::text) || btrim((tg_zlecenia.zl_seria)::text)) || '/'::text) || (tg_zlecenia.zl_rok)::text) || '/ZLP'::text), 0, 50))::character varying(50) AS numer_zlecenia,
            ("substring"(btrim((tg_zlecenia.zl_seria)::text), 0, 8))::character varying(8) AS seria,
            ("substring"(tg_zlecenia.zl_nazwa, 0, 50))::character varying(50) AS kod_zlecenia,
            tg_zlecenia.zl_typ AS rodzajzlecenia,
            n.k_kod AS kododbiorcy_zlecenia,
            n.k_nazwa AS nazwaodbiorcy_zlecenia,
            n.rj_nazwa AS rejonodbiorcy_zlecenia,
            o.k_kod AS kodzlecajacego_zlecenia,
            o.k_nazwa AS nazwazlecajacego_zlecenia,
            o.rj_nazwa AS rejonzlecajacego_zlecenia,
            h.k_kod AS kodkontrahenta_zlecenia,
            h.k_nazwa AS nazwakontrahenta_zlecenia,
            h.rj_nazwa AS rejonkontrahenta_zlecenia,
            p.p_login AS odpowiedzialny,
            g1.tgr_nazwa AS grupa_i,
            g2.tpg_nazwa AS grupa_ii,
            (hotele.iloscdob)::double precision AS obciazenie_hotelu,
            0 AS koszt
           FROM ((((((((tg_zlecenia
             LEFT JOIN ( SELECT tg_transakcje.tr_idtrans,
                    tg_transakcje.tr_zamknieta,
                    tg_transakcje.k_idklienta,
                    tg_transakcje.zl_idzlecenia,
                    getwartoscpln(tg_transelem.tel_ilosc, tg_transelem.tel_cenawal, tg_transelem.tel_kurswal) AS koszt,
                    tg_towary.tgr_idgrupy,
                    tg_towary.tpg_idpodgrupy
                   FROM ((tg_transakcje
                     JOIN tg_transelem USING (tr_idtrans))
                     JOIN tg_towary USING (ttw_idtowaru))
                  WHERE (tg_transakcje.tr_rodzaj = 45)) pozycje USING (zl_idzlecenia))
             LEFT JOIN ( SELECT tb_pracownicy.p_idpracownika,
                    tb_pracownicy.p_login
                   FROM tb_pracownicy) p ON ((tg_zlecenia.p_odpowiedzialny = p.p_idpracownika)))
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
                     LEFT JOIN ts_regiony USING (rj_idregionu))) n ON ((tg_zlecenia.k_idklienta = n.k_idklienta)))
             LEFT JOIN ( SELECT tb_klient.k_idklienta,
                    tb_klient.k_kod,
                    tb_klient.k_nazwa,
                    ts_regiony.rj_nazwa,
                    tb_klient.rk_idrodzajklienta
                   FROM (tb_klient
                     LEFT JOIN ts_regiony USING (rj_idregionu))) o ON ((tg_zlecenia.k_idzlecajacy = o.k_idklienta)))
             LEFT JOIN ( SELECT tg_hotelezlecen.zl_idzlecenia,
                    tg_hotelezlecen.k_idklienta,
                    (tg_hotelezlecen.ht_iloscosob * tg_hotelezlecen.ht_iloscnoclegow) AS iloscdob
                   FROM tg_hotelezlecen) hotele ON ((tg_zlecenia.zl_idzlecenia = hotele.zl_idzlecenia)))
             LEFT JOIN ( SELECT tb_klient.k_idklienta,
                    tb_klient.k_kod,
                    tb_klient.k_nazwa,
                    ts_regiony.rj_nazwa,
                    tb_klient.rk_idrodzajklienta
                   FROM (tb_klient
                     LEFT JOIN ts_regiony USING (rj_idregionu))) h ON ((hotele.k_idklienta = h.k_idklienta)))) tmp;
