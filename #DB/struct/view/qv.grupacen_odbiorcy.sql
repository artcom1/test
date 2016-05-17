CREATE VIEW grupacen_odbiorcy AS
 SELECT ts_grupycen.tgc_idgrupy AS grupacen_odbiorcy,
    ts_grupycen.tgc_nazwa AS nazwa_grupycen_odbiorcy
   FROM public.ts_grupycen;
