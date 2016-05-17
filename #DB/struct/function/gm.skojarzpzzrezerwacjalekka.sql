CREATE FUNCTION skojarzpzzrezerwacjalekka(numeric, public.tg_ruchy, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 t_ile     ALIAS FOR $1;
 _rez      ALIAS FOR $2;
 _idpartii ALIAS FOR $3;
 sr        gm.SKOPIUJ_REZERWACJE_TYPE;
BEGIN

 IF (t_ile<=0) THEN RETURN 0; END IF;

 IF (isRezerwacjaLekka(_rez.rc_flaga)=FALSE) THEN
  RAISE EXCEPTION 'Nie jest kopiowana rezerwacja lekka';
 END IF;

--- RAISE NOTICE 'Kojarze rezerwacje na % ',t_ile;

 IF (_rez.rc_ruch=NULL) AND (_rez.prt_idpartiipz IS NULL) OR (_rez.prt_idpartiipz IS NOT DISTINCT FROM _idpartii) THEN --- Ruch nie byl do niczego podczepiony wiec po prostu go podczep
  UPDATE tg_ruchy SET prt_idpartiipz=_idpartii,rc_iloscpoz=round(rc_iloscpoz+t_ile,4) WHERE rc_idruchu=_rez.rc_idruchu;
 ELSE
  sr.rc_idruchu_src=_rez.rc_idruchu;
  sr.tel_idelem_dst=_rez.tel_idelem;
  sr.tr_idtrans_dst=_rez.tr_idtrans;
  sr.rc_ilosctocopy=t_ile;
  sr.rc_iloscpoztoadd=t_ile;
  sr.rc_addflaga=0;
  sr.rc_delflaga=0;
  sr.prt_idpartiipz_new=_idpartii;
  PERFORM gm.skopiujRezerwacje(sr);
 END IF;
 
 RETURN t_ile;
END;
$_$;
