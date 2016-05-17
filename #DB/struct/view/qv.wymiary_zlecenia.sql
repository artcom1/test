CREATE VIEW wymiary_zlecenia AS
 SELECT zl.zl_idzlecenia AS idzlecenia_wymiaru,
    ((((zl.zl_nrzlecenia || '/'::text) || btrim((zl.zl_seria)::text)) || '/'::text) || (zl.zl_rok)::text) AS nrzlecenia_wymiaru
   FROM public.tg_zlecenia zl;
