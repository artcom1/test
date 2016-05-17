CREATE VIEW kzv_rozliczonepzkwz AS
 SELECT sum(rpzam.rm_iloscf) AS sumilosc,
    rpzam.tel_idpzam AS tel_idelem
   FROM public.tg_realizacjapzam rpzam
  WHERE ((rpzam.rm_powod = 13) AND (rpzam.tel_idpzam IS NOT NULL))
  GROUP BY rpzam.tel_idpzam;
