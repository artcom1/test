CREATE VIEW raport_handlowcow_d_roz AS
 SELECT gotowe.tr_zaliczonedla,
    gotowe.tgr_idgrupy,
    gotowe.data_rozliczenia_miesiac,
    gotowe.zaplacone,
    gotowe.zysk,
    gotowe.zaplacono_termin,
    gotowe.zysk_termin,
    gotowe.zaplacono_od15do30,
    gotowe.zysk_od15do30,
    gotowe.zaplacono_po30,
    gotowe.zysk_po30,
    tb_pracownicy.p_nazwisko,
    tb_pracownicy.p_imie,
    ((tb_pracownicy.p_nazwisko || (' '::character varying)::text) || tb_pracownicy.p_imie) AS nazwisko_imie,
    tg_grupytow.tgr_nazwa
   FROM ((( SELECT got.tr_zaliczonedla,
            got.tgr_idgrupy,
            got.data_rozliczenia_miesiac,
            sum(got.tel_wartoscf) AS zaplacone,
            sum((got.tel_wartoscf - got.tel_kosztnabycia)) AS zysk,
            sum(got.zaplacono_termin) AS zaplacono_termin,
            sum(got.zysk_termin) AS zysk_termin,
            sum(got.zaplacono_od15do30) AS zaplacono_od15do30,
            sum(got.zysk_od15do30) AS zysk_od15do30,
            sum(got.zysk_po30) AS zysk_po30,
            sum(got.zaplacono_po30) AS zaplacono_po30
           FROM ( SELECT tmp.tr_zaliczonedla,
                    tg_towary.tgr_idgrupy,
                    (((date_part('year'::text, tmp.data_rozliczenia))::text || '.'::text) || uzupelnijmiesiac((date_part('month'::text, tmp.data_rozliczenia))::text)) AS data_rozliczenia_miesiac,
                    getwartoscpln(tg_transelem.tel_ilosc, tg_transelem.tel_cenawal, tg_transelem.tel_kurswal) AS tel_wartoscf,
                    tg_transelem.tel_kosztnabycia,
                    (getwartoscpln(tg_transelem.tel_ilosc, tg_transelem.tel_cenawal, tg_transelem.tel_kurswal) * "numeric"(rozliczonyprzed15(tmp.data_rozliczenia, tmp.tr_dataplatnosci))) AS zaplacono_termin,
                    ((getwartoscpln(tg_transelem.tel_ilosc, tg_transelem.tel_cenawal, tg_transelem.tel_kurswal) - tg_transelem.tel_kosztnabycia) * "numeric"(rozliczonyprzed15(tmp.data_rozliczenia, tmp.tr_dataplatnosci))) AS zysk_termin,
                    (getwartoscpln(tg_transelem.tel_ilosc, tg_transelem.tel_cenawal, tg_transelem.tel_kurswal) * "numeric"(rozliczonyprzed30(tmp.data_rozliczenia, tmp.tr_dataplatnosci))) AS zaplacono_od15do30,
                    ((getwartoscpln(tg_transelem.tel_ilosc, tg_transelem.tel_cenawal, tg_transelem.tel_kurswal) - tg_transelem.tel_kosztnabycia) * "numeric"(rozliczonyprzed30(tmp.data_rozliczenia, tmp.tr_dataplatnosci))) AS zysk_od15do30,
                    (getwartoscpln(tg_transelem.tel_ilosc, tg_transelem.tel_cenawal, tg_transelem.tel_kurswal) * "numeric"(rozliczonypo30(tmp.data_rozliczenia, tmp.tr_dataplatnosci))) AS zaplacono_po30,
                    ((getwartoscpln(tg_transelem.tel_ilosc, tg_transelem.tel_cenawal, tg_transelem.tel_kurswal) - tg_transelem.tel_kosztnabycia) * "numeric"(rozliczonypo30(tmp.data_rozliczenia, tmp.tr_dataplatnosci))) AS zysk_po30
                   FROM ((( SELECT tg_transakcje.tr_idtrans,
                            tg_transakcje.tr_zaliczonedla,
                            tg_transakcje.tr_dataplatnosci,
                            ( SELECT kh_platelem.pp_datawplywu
                                   FROM kh_platelem
                                  WHERE ((kh_platelem.tr_idtrans = tg_transakcje.tr_idtrans) AND (tg_transakcje.tr_dozaplaty = tg_transakcje.tr_zaplacono))
                                  ORDER BY kh_platelem.pp_datawplywu DESC
                                 OFFSET 0
                                 LIMIT 1) AS data_rozliczenia
                           FROM tg_transakcje
                          WHERE ((tg_transakcje.tr_dozaplaty = tg_transakcje.tr_zaplacono) AND ((tg_transakcje.tr_rodzaj = 1) OR (tg_transakcje.tr_rodzaj = 7) OR (tg_transakcje.tr_rodzaj = 11) OR (tg_transakcje.tr_rodzaj = 17)))) tmp
                     JOIN tg_transelem USING (tr_idtrans))
                     JOIN tg_towary USING (ttw_idtowaru))) got
          GROUP BY got.tr_zaliczonedla, got.tgr_idgrupy, got.data_rozliczenia_miesiac) gotowe
     JOIN tb_pracownicy ON ((gotowe.tr_zaliczonedla = tb_pracownicy.p_idpracownika)))
     JOIN tg_grupytow ON ((gotowe.tgr_idgrupy = tg_grupytow.tgr_idgrupy)));
