CREATE VIEW kv_raport_vat AS
 SELECT t.tr_idtrans,
    sum(t.netto) AS netto,
    sum(t.vat) AS vat,
    sum(t.brutto) AS brutto,
    sum(t.kgonetto) AS kgonetto,
    sum(t.kgovat) AS kgovat,
    sum(t.kgobrutto) AS kgobrutto,
    sum(t.netnetto) AS netnetto,
    sum(t.netvat) AS netvat,
    sum(t.netbrutto) AS netbrutto,
    sum(t.l_pozycji) AS l_pozycji,
    sum(t.l_pozycji0) AS l_pozycji0,
    sum(t.l_pozycjiusl) AS l_pozycjiusl,
    sum(t.v_iloscwyd_sum) AS v_iloscwyd_sum,
    sum(t.iloscoo) AS iloscoo,
    public.min(t.v_kursdok) AS v_kursdokmin,
    public.max(t.v_kursdok) AS v_kursdokmax
   FROM kv_raport_vat_wkurs t
  GROUP BY t.tr_idtrans;
