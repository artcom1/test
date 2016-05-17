CREATE VIEW kv_raport_vatpln AS
 SELECT t.tr_idtrans,
    sum(public.round(((t.netto)::public.mpq OPERATOR(public.*) t.v_kursdok), 2)) AS nettopln,
        CASE
            WHEN (tr.tr_kursvat OPERATOR(public.=) tr.tr_przelicznik) THEN sum(public.round(((t.brutto)::public.mpq OPERATOR(public.*) t.v_kursdok), 2))
            ELSE (sum(public.round(((t.netto)::public.mpq OPERATOR(public.*) t.v_kursdok), 2)) + public.round(((sum(t.vat))::public.mpq OPERATOR(public.*) tr.tr_kursvat), 2))
        END AS bruttopln,
        CASE
            WHEN (tr.tr_kursvat OPERATOR(public.=) tr.tr_przelicznik) THEN (sum(public.round(((t.brutto)::public.mpq OPERATOR(public.*) t.v_kursdok), 2)) - sum(public.round(((t.netto)::public.mpq OPERATOR(public.*) t.v_kursdok), 2)))
            ELSE public.round(((sum(t.vat))::public.mpq OPERATOR(public.*) tr.tr_kursvat), 2)
        END AS vatpln
   FROM (kv_raport_vat_wkurs t
     JOIN public.tg_transakcje tr USING (tr_idtrans))
  GROUP BY t.tr_idtrans, tr.tr_kursvat, tr.tr_przelicznik;
