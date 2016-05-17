CREATE VIEW podgrupytowarow AS
 SELECT tg_podgrupytow.tpg_idpodgrupy,
    tg_podgrupytow.tpg_nazwa,
    tg_podgrupytow.tpg_sciezka
   FROM public.tg_podgrupytow;
