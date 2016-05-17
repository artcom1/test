CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 r        RECORD;
 isoznaczony    BOOL;
 il       NUMERIC;
 op       INT;
 t        RECORD;
 rt       gm.DODAJ_REZERWACJE_TYPE; 
BEGIN

 IF (TG_OP<>'DELETE') THEN

  IF (NEW.rc_idruchupz IS NULL) THEN
   RETURN NEW;
  END IF;

  IF (TG_OP='UPDATE') THEN
   ----- Zupdatuj rezerwacje na ruchach przy zmianie id transelemu na wskrez
   IF (NEW.tel_idelem_inw<>OLD.tel_idelem_inw) THEN
    UPDATE tg_ruchy 
    SET tel_idelem=NEW.tel_idelem_inw,
        tr_idtrans=(SELECT tr_idtrans FROM tg_transelem WHERE tel_idelem=NEW.tel_idelem_inw)
    WHERE tel_idelem=OLD.tel_idelem_inw AND
          rc_seqid=OLD.wr_rezid;
   END IF;
  END IF;

  IF (NEW.wr_rezid IS NULL) THEN 
   NEW.wr_rezid=(SELECT nextval('tg_ruchy_seqid'));
  END IF;

  SELECT te.tr_idtrans,te.ttw_idtowaru,te.ttm_idtowmag,tm.tmg_idmagazynu,te.tel_oidklienta,tr.tr_datasprzedaz INTO r 
  FROM tg_transelem AS te
  JOIN tg_towmag AS tm USING (ttm_idtowmag)
  JOIN tg_transakcje AS tr USING (tr_idtrans)
  WHERE te.tel_idelem=NEW.tel_idelem_inw;

  isoznaczony=gm.isOznaczonyRuchN(NEW.rc_idruchupz);
  il=(SELECT rc_iloscpoz-(rc_iloscrez-rc_iloscrezzr) FROM tg_ruchy WHERE rc_idruchu=NEW.rc_idruchupz);
  

  il=il+nullZero((SELECT sum(rc_iloscrez) FROM tg_ruchy WHERE isRezerwacja(rc_flaga) AND rc_ruch=NEW.rc_idruchupz AND rc_seqid=NEW.wr_rezid));
  
  IF (isoznaczony=FALSE) THEN
   op=gm.nextOznaczRuchN();
   PERFORM gm.markAnyOznaczonyRuchN(op,TRUE);
   PERFORM gm.oznaczRuchN(op,NEW.rc_idruchupz,TRUE);
  END IF;

  il=min(NEW.wr_ilosc_inw,il);


  PERFORM gm.marknotfullpartiaonly(NEW.rc_idruchupz,1);

  SELECT rc_iloscpoz,rc_iloscrez,rc_iloscrezzr INTO t FROM tg_ruchy WHERE rc_idruchu=26159;  
  
  rt.tel_idelem_for=NEW.tel_idelem_inw;
  rt.tr_idtrans_for=r.tr_idtrans;
  rt.ttw_idtowaru=r.ttw_idtowaru;
  rt.ttm_idtowmag=r.ttm_idtowmag;
  rt.tmg_idmagazynu=r.tmg_idmagazynu;
  rt.k_idklienta_for=r.tel_oidklienta;
  rt.data_rezerwacji=r.tr_datasprzedaz;
  rt.rc_ilosc=il;
  rt._zewskazaniem=TRUE;
  rt._rezid=NEW.wr_rezid;
  rt._onlywskazane=TRUE;
  rt._rezerwacjalekka=FALSE;
  rt.rc_idruchupz=NEW.rc_idruchupz;
    
  PERFORM gm.dodaj_rezerwacje(rt,FALSE);
  
  SELECT rc_iloscpoz,rc_iloscrez,rc_iloscrezzr INTO t FROM tg_ruchy WHERE rc_idruchu=26159;  
				  				  
  PERFORM gm.marknotfullpartiaonly(NEW.rc_idruchupz,-1);

  IF (isoznaczony=FALSE) THEN
   PERFORM gm.markAnyOznaczonyRuchN(op,FALSE);
  END IF;

 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;

 RETURN NEW;
END;
$$;
