CREATE VIEW tbv_vatzal AS
 SELECT tb_vatzal.tr_idtrans,
    sum(tb_vatzal.vz_netto) AS vz_netto,
    sum(tb_vatzal.vz_vat) AS vz_vat,
    sum(tb_vatzal.vz_brutto) AS vz_brutto,
    sum(tb_vatzal.vz_nettoroz) AS vz_nettoroz,
    sum(tb_vatzal.vz_vatroz) AS vz_vatroz,
    sum(tb_vatzal.vz_bruttoroz) AS vz_bruttoroz,
    tb_vatzal.vz_stawkavat,
    tb_vatzal.vz_flagazw
   FROM tb_vatzal
  GROUP BY tb_vatzal.tr_idtrans, tb_vatzal.vz_stawkavat, tb_vatzal.vz_flagazw;
