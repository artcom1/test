CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 ret TEXT;
 idtrans INT;
 r RECORD;
BEGIN
 ret=gm.zmianacenypzinner($1);

 IF (checkwholetrans=TRUE) THEN
  ---Konieczny jest update rowniez pozostalych pozycji na dokumencie jesli zmieniona zostala cena lub wartosc
  ---a dokument posiada koszty transportu. Potrzebne jest to z uwagi na to ze koszty transportu wyliczane sa proporcjonalnie
  ---a zmieniajac cene/wartosc zmienia sie proporcja
  idtrans=(SELECT tr_idtrans FROM tg_transakcje WHERE tr_idtrans=(SELECT tr_idtrans FROM tg_transelem WHERE tel_idelem=$1) AND (tr_kosztkraj!=0 OR tr_kosztzag!=0));
 
  IF (idtrans IS NOT NULL) THEN
   FOR r IN SELECT tel_idelem,tel_cenawal,tel_cenabwal,tel_walutawal FROM tg_transelem WHERE tr_idtrans=idtrans AND tel_idelem!=idtranselem AND tel_flaga&1024=0
   LOOP
    PERFORM gm.zmiencosnapz(r.tel_idelem);
    PERFORM gm.zmianacenypz(r.tel_idelem,false);
   END LOOP;
  END IF;
 END IF;
  
 RETURN ret;
END;
$_$;
