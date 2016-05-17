CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _fv ALIAS FOR $1;
 _forupdate ALIAS FOR $2;
 kfv RECORD;
 wynik TEXT:='';
BEGIN

 EXECUTE 'CREATE TEMPORARY TABLE korektyFV AS SELECT tel_idelem FROM tg_transelem LIMIT 0 OFFSET 0';
 EXECUTE 'CREATE TEMPORARY TABLE WZety AS SELECT tr_idtrans,tel_idelem FROM tg_transelem LIMIT 0 OFFSET 0';

 --- Wez rekordy pozycji korekty FV
 FOR kfv IN SELECT tel_idelem,tel_skojarzony FROM tg_transelem WHERE tr_idtrans=_fv AND (tel_flaga&65536=65536 OR tel_skojarzony=NULL) ORDER BY tel_idelem
 LOOP

  IF (kfv.tel_skojarzony=NULL) THEN
   -- IDTE korekt FV
   EXECUTE 'INSERT INTO korektyFV SELECT tel_idelem FROM tg_transelem WHERE tel_idelem='||kfv.tel_idelem;
   --IDTE WzetDoFV
   EXECUTE 'INSERT INTO WZety SELECT tr_idtrans,tel_idelem FROM tg_transelem WHERE tel_skojlog='||kfv.tel_idelem;
  ELSE
   -- IDTE korekt FV
   EXECUTE 'INSERT INTO korektyFV SELECT tel_idelem FROM tg_transelem WHERE tel_skojarzony='||kfv.tel_skojarzony||' AND tel_flaga&65536=65536';
   --IDTE WzetDoFV
   EXECUTE 'INSERT INTO WZety SELECT tr_idtrans,tel_idelem FROM tg_transelem WHERE tel_skojlog='||kfv.tel_skojarzony||'';
  END IF;

 END LOOP;

 EXECUTE 'CREATE INDEX WZety_i1 ON WZety(tel_idelem);';

 --IDTE dopisanych korekt
 EXECUTE 'INSERT INTO WZety SELECT te.tr_idtrans,te.tel_idelem FROM korektyFV AS k JOIN tg_transelem AS te ON (te.tel_skojlog=k.tel_idelem) AND (te.tel_skojarzony=NULL OR te.tel_flaga&65536=65536)';

 --IDTE korektWZ
 EXECUTE 'INSERT INTO WZety SELECT te.tr_idtrans,te.tel_idelem FROM WZety AS k JOIN tg_transelem AS te ON (te.tel_skojarzony=k.tel_idelem) AND (te.tel_skojlog=NULL)';


 FOR kfv IN EXECUTE 'SELECT DISTINCT ON (tr_idtrans) tr_idtrans,tr_zamknieta FROM WZety JOIN tg_transakcje USING (tr_idtrans)'
 LOOP
  wynik=wynik||'|('||kfv.tr_idtrans||',';
  IF ((kfv.tr_zamknieta&1::int2)=1::int2) THEN
   wynik=wynik||'1';
  ELSE
   wynik=wynik||'0';
  END IF;
  wynik=wynik||')';
 END LOOP;

 EXECUTE 'DROP TABLE WZety';
 EXECUTE 'DROP TABLE korektyFV';


 RETURN wynik;
END;
$_$;
