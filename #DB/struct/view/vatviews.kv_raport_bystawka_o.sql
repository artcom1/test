CREATE VIEW kv_raport_bystawka_o AS
 SELECT inn.tr_idtrans,
    inn.tel_netto,
    inn.tel_vat,
    inn.tel_vat2,
    inn.tel_vatb,
    inn.tel_vatb2,
    inn.tel_brutto,
    inn.tel_stvat,
    inn.tel_zw,
    inn.tel_iloscwyd_sum,
    inn.l_pozycji,
    inn.tel_zaokl
   FROM kv_raport_bystawka_odetailed inn;
