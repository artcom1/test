CREATE VIEW grupacen_nabywcy AS
 SELECT ts_grupycen.tgc_idgrupy AS grupacen_nabywcy,
    ts_grupycen.tgc_nazwa AS nazwa_grupycen_nabywcy
   FROM public.ts_grupycen;
