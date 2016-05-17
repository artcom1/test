CREATE VIEW raport_naglowek AS
 SELECT tg_transakcje.tr_numer,
    tg_transakcje.tr_nrobcy,
    tg_transakcje.tr_idtrans,
    tg_transakcje.tr_rodzaj,
    (((((((tg_transakcje.tr_numer)::text || '/'::text) || btrim((tg_transakcje.tr_seria)::text)) || '/'::text) || (tg_transakcje.tr_rok)::text) || '/'::text) || (( SELECT tg_rodzajtransakcji.trt_skrot
           FROM tg_rodzajtransakcji
          WHERE (tg_rodzajtransakcji.tr_rodzaj = tg_transakcje.tr_rodzaj)
         OFFSET 0
         LIMIT 1))::text) AS numer,
    btrim((tg_transakcje.tr_seria)::text) AS seria,
    tg_transakcje.tr_datawystaw AS data2,
    tg_transakcje.tr_datasprzedaz AS data1,
    tg_transakcje.tr_knazwa,
    tg_transakcje.tr_nip,
    ((((tg_transakcje.tr_kadres || ' '::text) || tg_transakcje.tr_kkodpocz) || ' '::text) || tg_transakcje.tr_kmiasto) AS adres,
    tg_transakcje.tr_wartosc,
    tg_transakcje.tr_vat,
    tg_transakcje.tr_dozaplaty
   FROM tg_transakcje
  WHERE ((tg_transakcje.tr_rodzaj = 1) OR (tg_transakcje.tr_rodzaj = 11) OR (tg_transakcje.tr_rodzaj = 0) OR (tg_transakcje.tr_rodzaj = 10) OR (tg_transakcje.tr_rodzaj = 7) OR (tg_transakcje.tr_rodzaj = 17) OR (tg_transakcje.tr_rodzaj = 45));
