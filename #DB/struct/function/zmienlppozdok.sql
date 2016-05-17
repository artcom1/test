CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _tel_idelem ALIAS FOR $1;
 typ ALIAS FOR $2;
 te RECORD;
 te2 RECORD;
 query TEXT;
 wynik INT:=0;
 lpprefix TEXT:='';
BEGIN
  SELECT tel_idelem, tel_lp, tel_lpprefix, tr_idtrans,tel_newflaga INTO te FROM tg_transelem WHERE tel_idelem=_tel_idelem;

  IF (te.tel_lpprefix is not NULL) THEN
   lpprefix=te.tel_lpprefix;
  END IF;

  IF (typ) THEN
   query='SELECT tel_idelem, tel_lp,tel_newflaga, tel_lpprefix  FROM tg_transelem WHERE tr_idtrans='||te.tr_idtrans||' AND tel_lp='||te.tel_lp-1||' AND tel_lp>0 AND tel_lpprefix='''||lpprefix||'''  ORDER BY tel_lp DESC, tel_flaga&1024 ASC ';
  ELSE
   query='SELECT tel_idelem, tel_lp,tel_newflaga, tel_lpprefix  FROM tg_transelem WHERE tr_idtrans='||te.tr_idtrans||' AND tel_lp='||te.tel_lp+1||' AND tel_lp>0 AND tel_lpprefix='''||lpprefix||''' ORDER BY tel_lp ASC, tel_flaga&1024 ASC ';
  END IF;

---    RAISE NOTICE 'zapytanie, % ',query;

 FOR te2 IN EXECUTE query
 LOOP
   IF (wynik=0) THEN
    wynik=te2.tel_idelem;
    UPDATE tg_transelem SET tel_flaga=tel_flaga|16384, tel_lp=te2.tel_lp WHERE tr_idtrans=te.tr_idtrans AND tel_lp=te.tel_lp AND tel_lpprefix=te.tel_lpprefix;
    IF (te.tel_newflaga&256=256) THEN
    --pozycja dla ktorej zmienilismy ma elementy powiazane, musimy na nich zmienic lpprefix wedlug nowego
     PERFORM uaktualnijLpPrefix(te.tel_idelem,numerkonta(te.tel_lpprefix,te2.tel_lp));
    END IF;
   END IF;
   UPDATE tg_transelem SET tel_flaga=tel_flaga|16384, tel_lp=te.tel_lp WHERE tr_idtrans=te.tr_idtrans AND tel_idelem=te2.tel_idelem;
   PERFORM uaktualnijLpPrefix(te2.tel_idelem,numerkonta(te2.tel_lpprefix,te.tel_lp));
 END LOOP;

 RETURN wynik;
END;
$_$;
