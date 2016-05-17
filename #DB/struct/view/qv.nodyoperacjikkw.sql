CREATE VIEW nodyoperacjikkw AS
 SELECT tr_kkwnod.kwe_idelemu AS idnodakkw,
    tr_kkwnod.kwh_idheadu AS idkkwheadu,
    tr_kkwnod.kwe_lp AS lpoperacji,
    tr_kkwnod.kwe_nazwa AS nazwaoperacjikkw,
    tr_kkwnod.the_idelem AS idtechnoloelemu,
    tr_kkwnod.top_idoperacji AS idoperacjitechnologicznej,
    tr_kkwnod.kwe_iloscplanwyk AS iloscplanowana,
    tr_kkwnod.kwe_iloscwyk AS iloscwykonana,
    tr_kkwnod.kwe_nodtype AS typoperacji,
    tr_kkwnod.kwe_opis AS opisoperacji
   FROM public.tr_kkwnod;
