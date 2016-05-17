CREATE VIEW grupytowarow AS
 SELECT tg_grupytow.tgr_idgrupy,
    tg_grupytow.tgr_nazwa,
    tg_grupytow.tgr_sciezka
   FROM public.tg_grupytow;
