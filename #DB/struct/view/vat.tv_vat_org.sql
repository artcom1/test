CREATE VIEW tv_vat_org AS
 SELECT tb_vat.tr_idtrans,
    tb_vat.v_stvat,
    tb_vat.v_zw,
    tb_vat.v_kurswal,
    tb_vat.v_idwaluty,
    tb_vat.v_isorg,
    tb_vat.v_iswal,
    tb_vat.v_iscorr,
    tb_vat.v_ispkormakro,
    tb_vat.v_iskgoforwal,
    tb_vat.v_id,
    tb_vat.v_nettokgo,
    tb_vat.v_vatkgon,
    tb_vat.v_vatkgob,
    tb_vat.v_bruttokgo,
    tb_vat.v_netnetto,
    tb_vat.v_netvatn,
    tb_vat.v_netvatb,
    tb_vat.v_netbrutto,
    tb_vat.v_netto,
    tb_vat.v_vatn,
    tb_vat.v_vatb,
    tb_vat.v_brutto,
    tb_vat.v_iloscpoz,
    tb_vat.v_iloscwyd,
    tb_vat.v_ilosc0cena
   FROM tb_vat
  WHERE (tb_vat.v_isorg = ANY (ARRAY[0, 2]));


SET search_path = vatviews, pg_catalog;
