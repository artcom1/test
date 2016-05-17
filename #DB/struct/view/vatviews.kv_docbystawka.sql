CREATE VIEW kv_docbystawka AS
 SELECT inn.tr_idtrans,
    sum(inn.tel_netto) AS tel_netto,
    sum(inn.tel_vat) AS tel_vat,
    sum(inn.tel_vat2) AS tel_vat2,
    sum(inn.tel_vatb) AS tel_vatb,
    sum(inn.tel_vatb2) AS tel_vatb2,
    sum(inn.tel_brutto) AS tel_brutto,
    inn.tel_stvat,
    (inn.tel_zw & (3 | (1 << 31))) AS tel_zw,
    sum(inn.tel_iloscwyd_sum) AS tel_iloscwyd_sum,
    sum(inn.l_pozycji) AS l_pozycji,
    inn.isorg,
    inn.iswal,
    inn.tel_waluta
   FROM ( SELECT te.tr_idtrans,
            sum(te.tel_wnettodok) AS tel_netto,
            round(public.vatfromnet(sum(te.tel_wnettodok), te.tel_stvat), 2) AS tel_vat,
            sum(round(public.vatfromnet(te.tel_wnettodok, te.tel_stvat), 2)) AS tel_vat2,
            round(public.vatfrombrt(sum(te.tel_wbruttodok), te.tel_stvat), 2) AS tel_vatb,
            sum(round(public.vatfrombrt(te.tel_wbruttodok, te.tel_stvat), 2)) AS tel_vatb2,
            sum(te.tel_wbruttodok) AS tel_brutto,
            te.tel_stvat,
            (te.tel_flaga & ((3 | (1 << 22)) | (1 << 31))) AS tel_zw,
            sum(abs(te.tel_iloscwyd)) AS tel_iloscwyd_sum,
            sum(
                CASE
                    WHEN te.iskgo THEN 1
                    ELSE 0
                END) AS l_pozycji,
            false AS isorg,
            te.iswal,
            te.tel_waluta
           FROM kv_docbystawka_inner te
          WHERE ((te.tel_flaga & 1024) = 0)
          GROUP BY te.tr_idtrans, te.tel_stvat, (te.tel_flaga & ((3 | (1 << 22)) | (1 << 31))), te.iswal, te.tel_waluta
        UNION ALL
         SELECT te.tr_idtrans,
            sum(round(te.tel_wnettodok, 2)) AS tel_netto,
            round(public.vatfromnet(sum(te.tel_wnettodok), te.tel_stvat), 2) AS tel_vat,
            sum(round(public.vatfromnet(te.tel_wnettodok, te.tel_stvat), 2)) AS tel_vat2,
            round(public.vatfrombrt(sum(te.tel_wbruttodok), te.tel_stvat), 2) AS tel_vatb,
            sum(round(public.vatfrombrt(te.tel_wbruttodok, te.tel_stvat), 2)) AS tel_vatb2,
            sum(te.tel_wbruttodok) AS tel_brutto,
            te.tel_stvat,
            (te.tel_flaga & ((3 | (1 << 22)) | (1 << 31))) AS tel_zw,
            sum(abs(te.tel_iloscwyd)) AS tel_iloscwyd_sum,
            sum(
                CASE
                    WHEN te.iskgo THEN 1
                    ELSE 0
                END) AS l_pozycji,
            true AS isorg,
            te.iswal,
            te.tel_waluta
           FROM kv_docbystawka_oinner te
          GROUP BY te.tr_idtrans, te.tel_stvat, (te.tel_flaga & ((3 | (1 << 22)) | (1 << 31))), te.iswal, te.tel_waluta) inn
  GROUP BY inn.tr_idtrans, inn.tel_stvat, (inn.tel_zw & (3 | (1 << 31))), inn.isorg, inn.iswal, inn.tel_waluta;
