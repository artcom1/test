CREATE FUNCTION dodaj_rezerwacje_lekka(dodaj_rezerwacje_type, public.tg_partie, boolean DEFAULT false) RETURNS dodaj_rezerwacje_rettype
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 _in        ALIAS FOR $1;
 _rp        ALIAS FOR $2;
 _dodelete  ALIAS FOR $3;
 ---------------------------------------------------------------------------
 ret        gm.DODAJ_REZERWACJE_RETTYPE;
 ---------------------------------------------------------------------------
 iloscpoz   NUMERIC:=_in.rc_ilosc;
 t_iloscel  NUMERIC;
 ruch_data  RECORD;
 flaga      INT:=0;
 r          RECORD;
 q          TEXT;
BEGIN


 IF (_in.tel_idelem_for IS NOT NULL) THEN
  flaga=256|512;
 END IF;

 IF (_in._rezdopzam=TRUE) THEN
  flaga=flaga|(1<<19);
 END IF;
 
 q=$$SELECT tm.prt_idpartii,tm.ptm_stanmag-tm.ptm_rezerwacje-tm.ptm_rezerwacjel AS maxilosc 
    FROM tg_partietm AS tm
    JOIN tg_partie AS ppz ON (tm.prt_idpartii=ppz.prt_idpartii)
	JOIN tg_towary AS tw ON (tw.ttw_idtowaru=tm.ttw_idtowaru)
    WHERE tm.ttm_idtowmag=$$||_in.ttm_idtowmag||$$ AND 
          tm.ptm_stanmag-tm.ptm_rezerwacje-tm.ptm_rezerwacjel>0
          $$||gm.getWhereClause('ppz',_rp,_in.ttw_whereparams)||$$
    ORDER BY gm.comparePartie(ppz,$$||vendo.record2string(_rp)||$$::tg_partie,tw.ttw_whereparams) DESC,$$||gm.getinoutsortclause(_in.ttw_inoutmethod,NULL,'ppz',FALSE);
 ---RAISE NOTICE '%',gm.toNotice(q);
 FOR r IN EXECUTE q
 LOOP
  t_iloscel=min(r.maxilosc,iloscpoz);

---  RAISE EXCEPTION 'Znalazlem lekka%',t_iloscel;

  CONTINUE WHEN t_iloscel<=0;

  INSERT INTO tg_ruchy 
   (tel_idelem,tr_idtrans,ttw_idtowaru,
    ttm_idtowmag,tmg_idmagazynu,
    rc_data,
    rc_ilosc,rc_iloscpoz,
    rc_flaga,
    k_idklienta,rc_seqid,
    prt_idpartiiwz,prt_idpartiipz)
  VALUES
   (_in.tel_idelem_for,_in.tr_idtrans_for,_in.ttw_idtowaru,
   _in.ttm_idtowmag,_in.tmg_idmagazynu,
   _in.data_rezerwacji,
   round(t_iloscel,4),t_iloscel,
   1|flaga|(1<<24),
   abs(_in.k_idklienta_for),ret.rezid,
   _in.prt_idpartii,r.prt_idpartii); 

  iloscpoz=iloscpoz-t_iloscel;
 END LOOP;

 IF (iloscpoz<=0) THEN
  DELETE FROM tg_ruchy WHERE tel_idelem=_in.tel_idelem_for AND NOT RCisRezerwacjaR(rc_flaga) AND rc_ilosc=0;
  RETURN NULL;
 END IF;


 INSERT INTO tg_ruchy 
  (tel_idelem,tr_idtrans,ttw_idtowaru,
   ttm_idtowmag,tmg_idmagazynu,
   rc_data,
   rc_ilosc,rc_iloscpoz,
   rc_flaga,
   k_idklienta,rc_seqid,
   prt_idpartiiwz)
 VALUES
  (_in.tel_idelem_for,_in.tr_idtrans_for,_in.ttw_idtowaru,
  _in.ttm_idtowmag,_in.tmg_idmagazynu,
  _in.data_rezerwacji,
  round(iloscpoz,4),0,
  1|flaga|(1<<24),
  abs(_in.k_idklienta_for),ret.rezid,
  _in.prt_idpartii); 

 DELETE FROM tg_ruchy WHERE tel_idelem=_in.tel_idelem_for AND NOT RCisRezerwacjaR(rc_flaga) AND rc_ilosc=0;

 RETURN ret;
END;
$_$;
