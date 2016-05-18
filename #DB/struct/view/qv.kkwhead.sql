CREATE VIEW kkwhead AS
 SELECT tr_kkwhead.kwh_idheadu AS idkkwheadu,
    tr_kkwhead.zl_idzlecenia AS idzlecenia_wymiaru,
    tr_kkwhead.th_idtechnologii AS idtechnologii,
    tr_kkwhead.kwh_numer AS numerkkw,
    tr_kkwhead.ttw_idtowaru,
    tr_kkwhead.kwh_iloscoczek AS iloscwyrobu,
    tr_kkwhead.thg_idgrupy AS idgrupytechnologii,
    tr_kkwhead.fm_idcentrali AS indexcentrali
   FROM public.tr_kkwhead
  WHERE (tr_kkwhead.th_rodzaj = 1);
