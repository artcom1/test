CREATE VIEW powiazanietezkkw AS
 SELECT COALESCE(r.tel_idelemsrc, r.tel_idelemdst) AS tel_idelem,
    COALESCE(wyk.kwh_idheadu, e.kwh_idheadu) AS kwh_idheadu
   FROM ((public.tr_ruchy r
     LEFT JOIN public.tr_nodrec wyk ON (((wyk.knr_idelemu = r.knr_idelemusrc) OR (wyk.knr_idelemu = r.knr_idelemudst))))
     LEFT JOIN public.tr_kkwnod e ON (((e.kwe_idelemu = r.kwe_idelemusrc) OR (e.kwe_idelemu = r.kwe_idelemudst))))
  WHERE (COALESCE(wyk.kwh_idheadu, e.kwh_idheadu) > 0);
