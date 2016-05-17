CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _rc_idruchu ALIAS FOR $1;
 rs gm.tg_rezstack;
 flags INT:=(256|512|524288);
BEGIN

 SELECT r.* INTO rs 
 FROM gm.tg_rezstack AS r 
 JOIN tg_ruchy AS rc ON (r.rc_idruchu=rc.rc_idruchu AND 
                         r.rc_recver_new=rc.rc_recver
			)
 WHERE r.rc_idruchu=_rc_idruchu;

 IF (rs.rs_id IS NULL) THEN
  ---RAISE NOTICE 'Brak pop dla ruchu %',_rc_idruchu;
  RETURN FALSE;
 END IF;

 RAISE NOTICE 'Robie pop dla ruchu % (%)',_rc_idruchu,rs;
 ---RAISE EXCEPTION 'Tu';

 DELETE FROM gm.tg_rezstack WHERE rs_id=rs.rs_id;

 UPDATE tg_ruchy SET tel_idelem=rs.tel_idelem_old,
                     tex_idelem=rs.tex_idelem_old,
                     tr_idtrans=(SELECT tr_idtrans FROM tg_transelem WHERE tel_idelem=rs.tel_idelem_old),
                     prt_idpartiiwz=rs.prt_idpartii_old,
		     rc_flaga=(rc_flaga&(~flags))|(rs.rc_flaga_old&flags),
		     rc_recver=rs.rc_recver_old
                 WHERE rc_idruchu=rs.rc_idruchu;

 INSERT INTO gm.tg_tetotouch (tel_idelem) VALUES (rs.tel_idelem_old);		

 RETURN TRUE;
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idruchu           ALIAS FOR $1;
 _iloscmniej        ALIAS FOR $2;
 r                  RECORD;
 sr                 gm.SKOPIUJ_REZERWACJE_TYPE;
 srret              gm.skopiuj_rezerwacje_rettype;
BEGIN 
 IF (_iloscmniej<0) THEN
  RAISE EXCEPTION 'Blad w ilosci do zmniejszenia';
 END IF;
 IF (_iloscmniej=0) THEN
  RETURN TRUE;
 END IF;

 ---RAISE NOTICE 'Robie popstack ruchu % dla ilosci %',_idruchu,_iloscmniej;

 SELECT rc.*,rs.rs_id INTO r 
 FROM tg_ruchy AS rc 
 LEFT OUTER JOIN gm.tg_rezstack AS rs ON (rs.rc_idruchu=rc.rc_idruchu AND rs.tel_idelem_new=rc.tel_idelem AND rs.tex_idelem_new IS NOT DISTINCT FROM rc.tex_idelem) 
 WHERE rc.rc_idruchu=_idruchu;


 IF (r.rc_idruchu IS NULL) THEN
  ---RAISE NOTICE 'Nie udany popstack ruchu % dla ilosci %',_idruchu,_iloscmniej;
  RETURN TRUE;
 END IF;

 
 IF (r.rs_id IS NOT NULL) THEN
  --Mamy informacje na stosie - wykorzystaj ja
  ----RAISE NOTICE 'Ilosci (%) % %',_idruchu,r.rc_ilosc,_iloscmniej;
  IF (r.rc_ilosc-r.rc_iloscrezzr=_iloscmniej) THEN
   ---Mozemy odtworzyc wszystko
   ---RAISE NOTICE 'M1: Chce zmniejszyc o % dla % (%)',_iloscmniej,_idruchu,r;
   RETURN gm.popRezStack(_idruchu);
  END IF;
  
  ---Trzeba skopiowac do nowego ruchu to co chcemy przeniesc
  sr=NULL;
  sr.rc_idruchu_src=_idruchu;
  sr.tel_idelem_dst=r.tel_idelem;
  sr.tex_idelem_dst=r.tex_idelem;
  sr.tr_idtrans_dst=r.tr_idtrans;
  sr.rc_ilosctocopy=_iloscmniej;
  sr.rc_addflaga=0;
  sr.rc_delflaga=0;
  ---RAISE NOTICE 'M2: Chce zmniejszyc o % dla % (%)',_iloscmniej,_idruchu,r;
  srret=gm.skopiujrezerwacje(sr);
  RETURN gm.popRezStack(srret.rc_idruchu_new);
 END IF;

 ---RAISE NOTICE 'Czy rezerwacja reczna % ',RCisRezerwacjaR(r.rc_flaga);

 ---Nie ma informacji na stosie
 IF (RCisRezerwacjaR(r.rc_flaga)=FALSE) OR NOT RCisRezerwacjaA(r.rc_flaga) THEN
  UPDATE tg_ruchy SET rc_ilosc=rc_ilosc-_iloscmniej WHERE rc_idruchu=_idruchu;
  DELETE FROM tg_ruchy WHERE rc_idruchu=_idruchu AND r.rc_ilosc=0;
  RETURN TRUE;
 END IF;

 ---Rezerwacja reczna - trzeba skopiowac nadmiar
 sr=NULL;
 sr.rc_idruchu_src=_idruchu;
 sr.tel_idelem_dst=NULL;
 sr.tex_idelem_dst=NULL;
 sr.tr_idtrans_dst=NULL;
 sr.rc_ilosctocopy=_iloscmniej;
 sr.rc_addflaga=0;
 sr.rc_delflaga=0;
 ---RAISE NOTICE 'M4: Chce zmniejszyc o % dla % (%)',_iloscmniej,_idruchu,r;
 PERFORM gm.skopiujrezerwacje(sr);
 RETURN TRUE;
END;
$_$;
