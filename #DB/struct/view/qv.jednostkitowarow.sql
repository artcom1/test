CREATE VIEW jednostkitowarow AS
 SELECT tg_jednostki.tjn_idjedn,
    tg_jednostki.tjn_skrot
   FROM public.tg_jednostki;
