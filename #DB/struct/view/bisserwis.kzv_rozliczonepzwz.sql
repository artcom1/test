CREATE VIEW kzv_rozliczonepzwz AS
 SELECT sum(rpzam.rm_iloscf) AS sumilosc,
    rpzam.tel_idelemsrc AS tel_idelem
   FROM public.tg_realizacjapzam rpzam
  WHERE (rpzam.rm_powod = ANY (ARRAY[12, 13]))
  GROUP BY rpzam.tel_idelemsrc;
