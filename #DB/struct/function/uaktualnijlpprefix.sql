CREATE FUNCTION uaktualnijlpprefix(integer, text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _tel_idelem ALIAS FOR $1;
 _tel_lpprefix ALIAS FOR $2;
 te RECORD;
BEGIN
 UPDATE tg_transelem SET tel_flaga=tel_flaga|16384, tel_lpprefix=_tel_lpprefix WHERE tel_skojzestaw=_tel_idelem;

 FOR te IN SELECT tel_idelem, tel_newflaga, tel_lp FROM tg_transelem WHERE tel_skojzestaw=_tel_idelem
 LOOP   ---rekurencyjnie sprawdzamy czy mamy jeszcze galezie w przypadku natrafienia rekurencyjnie przeliczamy prefixy
  IF (te.tel_newflaga&256=256) THEN 
   --pozycja dla ktorej zmienilismy ma elementy powiazane, musimy na nich zmienic lpprefix wedlug nowego
    PERFORM uaktualnijLpPrefix(te.tel_idelem,numerkonta(_tel_lpprefix,te.tel_lp));
  END IF;
 END LOOP;

 return 1;
END;
$_$;
