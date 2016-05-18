CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idruchupz ALIAS FOR $1;
 nadmiar    ALIAS FOR $2;
 t_ile      NUMERIC;
 ruch_data  RECORD;
 ruch       tg_ruchy;
 whereprms  INT;
 onemore    BOOL:=FALSE;
BEGIN

 LOOP

  ---Na razie sprobuj zdjac tylko ten nadmiar, ktory nie zostal zdjety fakturami
  FOR ruch_data IN SELECT rc_idruchu,rc_iloscpoz-rc_iloscrezzr AS rc_niezr,ttw_idtowaru
                   FROM tg_ruchy 
                   WHERE rc_ruch=_idruchupz AND 
 	 	        (rc_iloscpoz-rc_iloscrezzr)>0 AND 
	 	        isRezerwacja(rc_flaga) 
		  ORDER BY rc_seqid DESC,rc_idruchu DESC
  LOOP
   ---- RAISE NOTICE 'Mam nadmiar % i ilosc niezr % ',nadmiar,ruch_data.rc_niezr;
   t_ile=round(max(min(nadmiar,ruch_data.rc_niezr),0),4);

   CONTINUE WHEN t_ile<=0;

   IF (whereprms IS NULL) THEN
    whereprms=(SELECT ttw_whereparams FROM tg_towary WHERE ttw_idtowaru=ruch_data.ttw_idtowaru);
   END IF;

   IF (gm.isFullPartiaOnly(whereprms,ruch_data.rc_idruchu)=TRUE) THEN
    IF (onemore=TRUE) THEN
     t_ile=ruch_data.rc_niezr;
    END IF;
    IF (t_ile<>ruch_data.rc_niezr) THEN
     CONTINUE;
    END IF;
   END IF;

   ----RAISE NOTICE '4.Zmieniam iloscpoz o %',t_ile;
   -- Powinien ustawic jakas flage tak by rezerwacja poszukala sobie nowego PZeta i ewentualnie rozmnozyla sie
   ---Pozostale ilosci sie obliczaja
   UPDATE tg_ruchy SET rc_iloscpoz=round(rc_iloscpoz-t_ile,4) WHERE rc_idruchu=ruch_data.rc_idruchu;
   SELECT * INTO ruch FROM tg_ruchy WHERE rc_idruchu=ruch_data.rc_idruchu;
   PERFORM gm.findPZetsForRezerwacja(ruch.rc_ilosc-ruch.rc_iloscpoz,ruch,_idruchupz);
   -- Tutaj powinien poszukac nowego PZeta
   nadmiar=round(nadmiar-t_ile,4);
  END LOOP;

  EXIT WHEN nadmiar=0 OR onemore=TRUE;
  onemore=TRUE;
 END LOOP;

 RETURN nadmiar;
END;
$_$;
