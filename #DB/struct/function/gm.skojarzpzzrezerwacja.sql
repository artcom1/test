CREATE FUNCTION skojarzpzzrezerwacja(numeric, public.tg_ruchy, public.tg_ruchy) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 t_ile  ALIAS FOR $1;
 _pz    ALIAS FOR $2;
 _rez   ALIAS FOR $3;
 sr     gm.SKOPIUJ_REZERWACJE_TYPE;
BEGIN

 IF (t_ile<=0) THEN RETURN 0; END IF;

--- RAISE NOTICE 'Kojarze rezerwacje na % ',t_ile;
 IF (isRezerwacjaLekka(_rez.rc_flaga)=TRUE) THEN
  RAISE EXCEPTION 'Nie jest kopiowana rezerwacja ciezka';
 END IF;

 IF (_rez.rc_ruch=NULL) THEN --- Ruch nie byl do niczego podczepiony wiec po prostu go podczep
  UPDATE tg_ruchy SET rc_ruch=_pz.rc_idruchu,rc_iloscpoz=round(rc_iloscpoz+t_ile,4) WHERE rc_idruchu=_rez.rc_idruchu;
 ELSE
  sr.rc_idruchu_src=_rez.rc_idruchu;
  sr.tel_idelem_dst=_rez.tel_idelem;
  sr.tr_idtrans_dst=_rez.tr_idtrans;
  sr.rc_ilosctocopy=t_ile;
  sr.rc_addflaga=0;
  sr.rc_delflaga=0;
  sr.rc_ruch_new=_pz.rc_idruchu;
  PERFORM gm.skopiujRezerwacje(sr);
 END IF;
 
 RETURN t_ile;
END;
$_$;
