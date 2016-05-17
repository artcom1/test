CREATE VIEW kv_checktk_magklienta AS
 SELECT b.tr_idtrans,
    b.ttw_idtowaru,
    b.iloscwyd,
    b.iloscp,
    b.rwyd,
    b.rp
   FROM ( SELECT a.tr_idtrans,
            a.ttw_idtowaru,
            a.iloscwyd,
            a.iloscp,
            nullzero(( SELECT sum(r.rc_ilosc) AS sum
                   FROM (tg_ruchy r
                     JOIN tg_magazyny USING (tmg_idmagazynu))
                  WHERE ((tg_magazyny.tmg_isfortk = 1) AND (r.tr_idtrans = a.tr_idtrans) AND (r.ttw_idtowaru = a.ttw_idtowaru) AND (r.rc_wspmag > 0) AND ((r.rc_flaga & (1 << 22)) = 0)))) AS rwyd,
            nullzero(( SELECT sum(r.rc_ilosc) AS sum
                   FROM (tg_ruchy r
                     JOIN tg_magazyny USING (tmg_idmagazynu))
                  WHERE ((tg_magazyny.tmg_isfortk = 1) AND (r.tr_idtrans = a.tr_idtrans) AND (r.ttw_idtowaru = a.ttw_idtowaru) AND (r.rc_wspmag < 0)))) AS rp
           FROM ( SELECT tr.tr_idtrans,
                    te.ttw_idtowaru,
                    sum(te.tk_wydano) AS iloscwyd,
                    sum(te.tk_przyjeto) AS iloscp
                   FROM (tg_transakcje tr
                     JOIN tg_tkelem te USING (tr_idtrans))
                  WHERE ((tr.tr_zamknieta & 1) = 1)
                  GROUP BY tr.tr_idtrans, te.ttw_idtowaru) a) b
  WHERE ((NOT ((b.iloscwyd = b.rwyd) AND (b.iloscp = b.rp))) AND (NOT ((b.iloscwyd - b.iloscp) = (b.rwyd - b.rp))));
