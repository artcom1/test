CREATE VIEW kv_raport_bystawka_detailed AS
 SELECT inn.tr_idtrans,
    sum(inn.tel_netto) AS tel_netto,
    sum(inn.tel_vat) AS tel_vat,
    sum(inn.tel_vat2) AS tel_vat2,
    sum(inn.tel_vatb) AS tel_vatb,
    sum(inn.tel_vatb2) AS tel_vatb2,
    sum(inn.tel_brutto) AS tel_brutto,
    sum(inn.tel_netnetto) AS tel_netnetto,
    sum(inn.tel_netvat) AS tel_netvat,
    sum(inn.tel_netvat2) AS tel_netvat2,
    sum(inn.tel_netvatb) AS tel_netvatb,
    sum(inn.tel_netvatb2) AS tel_netvatb2,
    sum(inn.tel_netbrutto) AS tel_netbrutto,
    inn.tel_stvat,
    ((inn.tel_zw & 3) | (((inn.tel_zw >> 31) & 1) << 2)) AS tel_zw,
    sum(inn.tel_iloscwyd_sum) AS tel_iloscwyd_sum,
    sum(inn.l_pozycji) AS l_pozycji,
    (inn.tel_zw & (1 << 26)) AS tel_zaokl
   FROM ( SELECT te.tr_idtrans,
            sum((te.tel_wnettodok + te.tel_wnettodokkgo)) AS tel_netto,
            round(public.vatfromnet(sum((te.tel_wnettodok + te.tel_wnettodokkgo)), te.tel_stvat), 2) AS tel_vat,
            sum(round(public.vatfromnet((te.tel_wnettodok + te.tel_wnettodokkgo), te.tel_stvat), 2)) AS tel_vat2,
            round(public.vatfrombrt(sum((te.tel_wbruttodok + te.tel_wbruttodokkgo)), te.tel_stvat), 2) AS tel_vatb,
            sum(round(public.vatfrombrt((te.tel_wbruttodok + te.tel_wbruttodokkgo), te.tel_stvat), 2)) AS tel_vatb2,
            sum((te.tel_wbruttodok + te.tel_wbruttodokkgo)) AS tel_brutto,
            sum(te.tel_wnettodok) AS tel_netnetto,
            round(public.vatfromnet(sum(te.tel_wnettodok), te.tel_stvat), 2) AS tel_netvat,
            sum(round(public.vatfromnet(te.tel_wnettodok, te.tel_stvat), 2)) AS tel_netvat2,
            round(public.vatfrombrt(sum(te.tel_wbruttodok), te.tel_stvat), 2) AS tel_netvatb,
            sum(round(public.vatfrombrt(te.tel_wbruttodok, te.tel_stvat), 2)) AS tel_netvatb2,
            sum(te.tel_wbruttodok) AS tel_netbrutto,
            te.tel_stvat,
            (te.tel_flaga & (((3 | (1 << 22)) | (1 << 26)) | (1 << 31))) AS tel_zw,
            sum(abs(te.tel_iloscwyd)) AS tel_iloscwyd_sum,
            count(
                CASE
                    WHEN ((te.tel_flaga & (1 << 7)) = 0) THEN 1
                    ELSE NULL::integer
                END) AS l_pozycji
           FROM kv_raport_te te
          WHERE ((te.tel_flaga & 1024) = 0)
          GROUP BY te.tr_idtrans, te.tel_stvat, (te.tel_flaga & (((3 | (1 << 22)) | (1 << 26)) | (1 << 31)))) inn
  GROUP BY inn.tr_idtrans, inn.tel_stvat, inn.tel_zw;
