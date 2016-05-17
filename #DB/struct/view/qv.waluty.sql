CREATE VIEW waluty AS
 SELECT tg_waluty.wl_idwaluty,
    tg_waluty.wl_nazwa AS nazwa_waluty,
    tg_waluty.wl_skrot AS symbol_waluty
   FROM public.tg_waluty;
