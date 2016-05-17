CREATE VIEW kzv_rozliczonepzwzpz AS
 SELECT sum(rpzam.rm_iloscf) AS sumilosc,
    rpzam.pz_idplanu
   FROM public.tg_realizacjapzam rpzam
  WHERE ((rpzam.rm_powod = ANY (ARRAY[12, 13])) AND (rpzam.pz_idplanu IS NOT NULL))
  GROUP BY rpzam.pz_idplanu;


SET search_path = gm, pg_catalog;
