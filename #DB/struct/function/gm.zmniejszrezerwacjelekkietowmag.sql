CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtowmag ALIAS FOR $1;
 _idpartii ALIAS FOR $2;
 _oile     ALIAS FOR $3;
 pozostalo NUMERIC:=_oile;
 tmp       NUMERIC;
 ruch_data RECORD;
 anychange BOOL;
BEGIN

 LOOP

  anychange=FALSE;

  FOR ruch_data IN SELECT r.rc_idruchu,r.rc_iloscrez
                   FROM tg_ruchy AS r
                   WHERE isRezerwacja(r.rc_flaga) AND
	 	         isRezerwacjaLekka(r.rc_flaga) AND
		         r.rc_iloscrez>0 AND
			 r.ttm_idtowmag=_idtowmag AND
			 r.prt_idpartiipz=_idpartii
		   ORDER BY r.rc_seqid
  LOOP
   EXIT WHEN pozostalo<=0;  

   tmp=min(pozostalo,ruch_data.rc_iloscrez);
   CONTINUE WHEN tmp<=0;

   anychange=TRUE;

   ---RAISE WARNING 'Robie update o % na ruchu % (pozostalo %)',tmp,ruch_data.rc_idruchu,pozostalo;

   --Zablokuj triggera dla tg_partietm
   PERFORM gm.blockpzet(NULL,true);
   PERFORM gm.blockTriggerFunction('CHECKRLP',1);
   --Zrob zmniejszenie
   UPDATE tg_ruchy SET 
    rc_iloscpoz=rc_iloscpoz-tmp,prt_idpartiipz=(CASE WHEN rc_iloscpoz=tmp THEN NULL ELSE prt_idpartiipz END) 
   WHERE rc_idruchu=ruch_data.rc_idruchu;
   ---Odblokuj triggera
   PERFORM gm.blockTriggerFunction('CHECKRLP',-1);
   PERFORM gm.blockpzet(NULL,false);


   PERFORM gm.searchWolnePartieForRezerwacja(ruch_data.rc_idruchu);

   pozostalo=pozostalo-tmp;
   EXIT;
  END LOOP;

  EXIT WHEN pozostalo<=0;
  EXIT WHEN anychange=FALSE;
 END LOOP;
 
 IF (pozostalo<>0) THEN
  RAISE EXCEPTION 'Blad zmniejszenia rezerwacji lekkich (pozostalo % z % dla % % %) !',pozostalo,_oile,_idtowmag,_idpartii,_oile;
 END IF;

 RETURN TRUE;
END;
$_$;
