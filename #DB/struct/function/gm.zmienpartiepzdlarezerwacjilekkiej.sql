CREATE FUNCTION zmienpartiepzdlarezerwacjilekkiej(simid integer, idruchurez integer, idpartiinew integer, ilosc numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
 r1    TG_RUCHY;
 cp    GM.SKOPIUJ_REZERWACJE_TYPE;
 ret   GM.SKOPIUJ_REZERWACJE_RETTYPE;
 idret INT;
BEGIN    

 SELECT * INTO r1 FROM tg_ruchy WHERE rc_idruchu=idruchurez;

 IF (isRezerwacjaLekkaNULL(r1.rc_flaga)=FALSE) THEN
  RAISE EXCEPTION 'Zadanie operacji na rezerwacji lekkiej NULL nie na rezerwacji lekkiej!';
 END IF;

 IF (r1.rc_ilosc=ilosc) THEN
  ---Podmiana pelnej ilosci - podmien ID partii
  UPDATE tg_ruchy SET prt_idpartiipz=idpartiinew WHERE rc_idruchu=idruchurez;
  PERFORM gm.updateRezStackWithNewPartia(idruchurez,r1.prt_idpartiipz,idpartiinew);
  RETURN TRUE;
 END IF;

 cp.rc_idruchu_src=idruchurez;
 cp.tel_idelem_dst=r1.tel_idelem;
 cp.tex_idelem_dst=r1.tex_idelem;
 cp.tr_idtrans_dst=r1.tr_idtrans;
 cp.rc_ilosctocopy=ilosc;
 cp.rc_addflaga=0;
 cp.rc_delflaga=0;
 cp.rc_ruch_new=r1.rc_ruch;
 cp.prt_idpartiipz_new=idpartiinew;
 cp.rc_iloscpoztoadd=0;
 cp._leaveflags=true;
 ret=gm.skopiujrezerwacje(cp);
  
 idret=ret.rc_idruchu_new;

 PERFORM gms.copyIDToUse(simid,idruchurez,idret);

 RETURN TRUE;
END;
$$;
