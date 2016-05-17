CREATE VIEW magazyny AS
 SELECT tg_magazyny.tmg_idmagazynu AS tr_idmagazynu,
    tg_magazyny.tmg_kod AS kod_magazynu,
    tg_magazyny.tmg_nazwa AS nazwa_magazynu
   FROM public.tg_magazyny;
