CREATE VIEW tv_distzmianycenzakupu AS
 SELECT a.zcz_id,
    a.ttw_idtowaru,
    a.fm_idcentrali,
    a.tr_idtrans,
    a.zcz_typ,
    a.zcz_cena,
    a.zcz_waluta,
    a.zcz_dataop,
    a.tr_datasprzedaz
   FROM ( SELECT z.zcz_id,
            z.ttw_idtowaru,
            z.fm_idcentrali,
            z.tr_idtrans,
            z.zcz_typ,
            z.zcz_cena,
            z.zcz_waluta,
            z.zcz_dataop,
            tr.tr_datasprzedaz,
            lag(z.zcz_cena, 1, NULL::numeric) OVER w AS prevcena,
            lag(z.zcz_waluta, 1, NULL::integer) OVER w AS prevwaluta
           FROM (tg_zmianycenzakupu z
             JOIN tg_transakcje tr ON ((tr.tr_idtrans = z.tr_idtrans)))
          WINDOW w AS (PARTITION BY z.fm_idcentrali, z.zcz_typ, z.ttw_idtowaru ORDER BY tr.tr_datasprzedaz, z.tr_idtrans, z.zcz_id)) a
  WHERE (((a.prevcena IS NULL) AND (a.prevwaluta IS NULL)) OR (a.prevcena IS DISTINCT FROM a.zcz_cena) OR (a.prevwaluta IS DISTINCT FROM a.zcz_waluta));
