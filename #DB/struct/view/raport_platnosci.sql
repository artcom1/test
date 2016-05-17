CREATE VIEW raport_platnosci AS
 SELECT rap.handlowiec,
    rap.merchandiser,
    rap.opiekun_nabywcy,
    rap.opiekun_odbiorcy,
    rap.numer,
    rap.nabywca_kod,
    rap.nabywca_nazwa,
    rap.odbiorca_kod,
    rap.odbiorca_nazwa,
    rap.data_wystawienia,
    rap.data_wystawienia_rok,
    rap.data_wystawienia_miesiac,
    rap.data_platnosci,
    rap.data_platnosci_rok,
    rap.data_platnosci_miesiac,
    rap.netto,
    rap.zysk,
    rap.data_rozliczenia,
    rap.seria_dokumentu,
    rap.wartosc_brutto,
    rap.pozostalo_do_rozliczenia,
    rap.rodzaj_dokumentu,
    rap.formaplatnosci,
    date_part('year'::text, rap.data_rozliczenia) AS data_rozliczenia_rok,
    date_part('month'::text, rap.data_rozliczenia) AS data_rozliczenia_miesiac,
    (((date_part('year'::text, rap.data_rozliczenia))::text || '.'::text) || uzupelnijmiesiac((date_part('month'::text, rap.data_rozliczenia))::text)) AS data_rozliczenia_rok_miesiac,
    (((rap.data_platnosci_rok)::text || '.'::text) || uzupelnijmiesiac((rap.data_platnosci_miesiac)::text)) AS data_platnosci_rok_miesiac,
    (((rap.data_wystawienia_rok)::text || '.'::text) || uzupelnijmiesiac((rap.data_wystawienia_miesiac)::text)) AS data_wystawienia_rok_miesiac,
    rozliczonydata(rap.data_rozliczenia) AS rozliczony,
    (roznicadatyrozliczeniadatyplatn(rap.data_rozliczenia, rap.data_platnosci))::double precision AS opoznienie_rozliczenia
   FROM ( SELECT zl.p_login AS handlowiec,
            mc.p_login AS merchandiser,
            onb.p_login AS opiekun_nabywcy,
            oodb.p_login AS opiekun_odbiorcy,
            (((((((tg_transakcje.tr_numer)::text || '/'::text) || btrim((tg_transakcje.tr_seria)::text)) || '/'::text) || (tg_transakcje.tr_rok)::text) || '/'::text) || (( SELECT tg_rodzajtransakcji.trt_skrot
                   FROM tg_rodzajtransakcji
                  WHERE (tg_rodzajtransakcji.tr_rodzaj = tg_transakcje.tr_rodzaj)
                 OFFSET 0
                 LIMIT 1))::text) AS numer,
            n.k_kod AS nabywca_kod,
            n.k_nazwa AS nabywca_nazwa,
            odb.k_kod AS odbiorca_kod,
            odb.k_nazwa AS odbiorca_nazwa,
            tg_transakcje.tr_datawystaw AS data_wystawienia,
            date_part('year'::text, tg_transakcje.tr_datawystaw) AS data_wystawienia_rok,
            date_part('month'::text, tg_transakcje.tr_datawystaw) AS data_wystawienia_miesiac,
            tg_transakcje.tr_dataplatnosci AS data_platnosci,
            date_part('year'::text, tg_transakcje.tr_dataplatnosci) AS data_platnosci_rok,
            date_part('month'::text, tg_transakcje.tr_dataplatnosci) AS data_platnosci_miesiac,
            tg_transakcje.tr_wartosc AS netto,
            (tg_transakcje.tr_wartosc - tg_transakcje.tr_koszt) AS zysk,
            ( SELECT kh_platelem.pp_datawplywu
                   FROM kh_platelem
                  WHERE ((kh_platelem.tr_idtrans = tg_transakcje.tr_idtrans) AND (tg_transakcje.tr_dozaplaty = tg_transakcje.tr_zaplacono))
                  ORDER BY kh_platelem.pp_datawplywu DESC
                 OFFSET 0
                 LIMIT 1) AS data_rozliczenia,
            tg_transakcje.tr_seria AS seria_dokumentu,
            tg_transakcje.tr_dozaplaty AS wartosc_brutto,
            (tg_transakcje.tr_dozaplaty - tg_transakcje.tr_zaplacono) AS pozostalo_do_rozliczenia,
            numery.trt_skrot AS rodzaj_dokumentu,
            rodzajplatnosci(int4(tg_transakcje.tr_formaplat)) AS formaplatnosci
           FROM (((((((tg_transakcje
             LEFT JOIN tb_klient n ON ((n.k_idklienta = tg_transakcje.k_idklienta)))
             LEFT JOIN tb_klient odb ON ((odb.k_idklienta = tg_transakcje.tr_oidklienta)))
             LEFT JOIN tb_pracownicy zl ON ((tg_transakcje.tr_zaliczonedla = zl.p_idpracownika)))
             LEFT JOIN tb_pracownicy mc ON ((tg_transakcje.tr_zaliczonoukl = mc.p_idpracownika)))
             LEFT JOIN tb_pracownicy onb ON ((n.p_idpracownika = onb.p_idpracownika)))
             LEFT JOIN tb_pracownicy oodb ON ((odb.p_idpracownika = oodb.p_idpracownika)))
             LEFT JOIN ( SELECT DISTINCT tg_rodzajtransakcji.trt_skrot,
                    tg_rodzajtransakcji.tr_rodzaj
                   FROM tg_rodzajtransakcji
                  ORDER BY tg_rodzajtransakcji.trt_skrot, tg_rodzajtransakcji.tr_rodzaj) numery ON ((tg_transakcje.tr_rodzaj = numery.tr_rodzaj)))
          WHERE (((tg_transakcje.tr_rodzaj = 1) OR (tg_transakcje.tr_rodzaj = 11) OR (tg_transakcje.tr_rodzaj = 7) OR (tg_transakcje.tr_rodzaj = 17) OR (tg_transakcje.tr_rodzaj = 0) OR (tg_transakcje.tr_rodzaj = 10) OR (tg_transakcje.tr_rodzaj = 45)) AND ((tg_transakcje.tr_zamknieta & ((1)::smallint)::integer) = 1))) rap;
