CREATE VIEW raporty_opoznieniaplatnosci AS
 SELECT tb_pracownicy.p_login,
    (((((((tg_transakcje.tr_numer)::text || '/'::text) || btrim((tg_transakcje.tr_seria)::text)) || '/'::text) || (tg_transakcje.tr_rok)::text) || '/'::text) || (( SELECT tg_rodzajtransakcji.trt_skrot
           FROM tg_rodzajtransakcji
          WHERE (tg_rodzajtransakcji.tr_rodzaj = tg_transakcje.tr_rodzaj)
         OFFSET 0
         LIMIT 1))::text) AS numer,
    n.k_kod AS nabywca,
    odb.k_kod AS odbiorca,
    tg_transakcje.tr_datawystaw AS data_wystawienia,
    tg_transakcje.tr_dataplatnosci,
    tg_transakcje.tr_wartosc AS netto,
    (tg_transakcje.tr_wartosc - tg_transakcje.tr_koszt) AS zysk,
    ( SELECT kh_platelem.pp_datawplywu
           FROM kh_platelem
          WHERE ((kh_platelem.tr_idtrans = tg_transakcje.tr_idtrans) AND (tg_transakcje.tr_dozaplaty = tg_transakcje.tr_zaplacono))
          ORDER BY kh_platelem.pp_datawplywu DESC
         OFFSET 0
         LIMIT 1) AS data_rozliczenia
   FROM (((tg_transakcje
     JOIN tb_klient n ON ((n.k_idklienta = tg_transakcje.k_idklienta)))
     JOIN tb_klient odb ON ((odb.k_idklienta = tg_transakcje.tr_oidklienta)))
     JOIN tb_pracownicy ON ((tg_transakcje.tr_zaliczonedla = tb_pracownicy.p_idpracownika)))
  WHERE (((tg_transakcje.tr_rodzaj = 1) OR (tg_transakcje.tr_rodzaj = 11) OR (tg_transakcje.tr_rodzaj = 7) OR (tg_transakcje.tr_rodzaj = 17)) AND ((tg_transakcje.tr_zamknieta & ((1)::smallint)::integer) = 1));
