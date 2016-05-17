CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 ruch_data RECORD;
 nadmiar NUMERIC;
 t_ile NUMERIC;
 deltapz_old NUMERIC:=0;
 deltapz_new NUMERIC:=0;
BEGIN

 IF (TG_OP<>'INSERT') THEN

  IF (isRezerwacja(OLD.rc_flaga)) THEN
   deltapz_old=deltapz_old+round(-OLD.rc_iloscpoz,4);
  END IF;

 END IF;

/*
 IF (TG_OP='INSERT') THEN
  IF (isRezerwacja(NEW.rc_flaga)) THEN
   RAISE NOTICE 'Dodaje rezerwacje % o SEQID % ',NEW.rc_idruchu,NEW.rc_seqid;
  END IF;
 END IF;
*/


 IF (TG_OP<>'DELETE') THEN

  IF (isRezerwacja(NEW.rc_flaga)) THEN
   deltapz_new=deltapz_new+round(NEW.rc_iloscpoz,4);
  END IF;

  IF (isFV(NEW.rc_flaga) OR isAPZet(NEW.rc_flaga)) THEN
   --- Sprawdz wydanie MWS
   IF (NEW.rc_iloscrezzr>NEW.rc_ilosc) THEN
    t_ile=NEW.rc_iloscrezzr-NEW.rc_ilosc;
    RAISE EXCEPTION '32|%:%|Towar wydany/przyjety juz przez MWS!',NEW.tel_idelem,t_ile;
   END IF;
  END IF;

 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (OLD.rc_ruch=NEW.rc_ruch) THEN
   deltapz_new=deltapz_old+deltapz_new;
   deltapz_old=0;
  END IF;

  IF (isRezerwacja(OLD.rc_flaga)) AND (COALESCE(OLD.tel_idelem,0)<>COALESCE(NEW.tel_idelem,0)) THEN
---   RAISE NOTICE 'Rezerwacja % - zmiana TE z % na %',NEW.rc_idruchu,OLD.tel_idelem,NEW.tel_idelem;
  END IF;

 END IF;


 IF (TG_OP='DELETE') THEN

  IF (isRezerwacja(OLD.rc_flaga)) THEN
   ----RAISE EXCEPTION 'Kasuje rezerwacje % o SEQID % ',OLD.rc_idruchu,OLD.rc_seqid;
  END IF;

  IF (isFV(OLD.rc_flaga) OR isAPZet(OLD.rc_flaga)) THEN
   --- Sprawdz wydanie MWS
   IF (OLD.rc_iloscrezzr>0) THEN
    t_ile=OLD.rc_iloscrezzr;
	IF (gm.checkMayUsuniecieMWS(OLD.tel_idelem,OLD.tex_idelem,isFV(OLD.rc_flaga))=FALSE) THEN
     RAISE EXCEPTION '32|%:%|Towar wydany/przyjety juz przez MWS!',OLD.tel_idelem,t_ile;
	END IF;
   END IF;
  END IF;

 END IF;


 IF (deltapz_old<>0) THEN
  --- Zdejmij z PZeta ilosc ktora zrealizowana poprzez PZ
  UPDATE tg_ruchy SET rc_iloscrez=rc_iloscrez+deltapz_old WHERE rc_idruchu=OLD.rc_ruch;
 END IF;

 IF (deltapz_new<>0) THEN
  --- Zdejmij z PZeta ilosc ktora zrealizowana poprzez PZ
  UPDATE tg_ruchy SET rc_iloscrez=rc_iloscrez+deltapz_new WHERE rc_idruchu=NEW.rc_ruch;
 END IF;

 /*---------------------------------------*/
 IF (TG_OP<>'DELETE') THEN

  IF isPZet(NEW.rc_flaga) THEN
   --- To co zarezerwowano-to co zrealizowano=to co pozostalo do rezerwacji
   nadmiar=round((NEW.rc_iloscrez-NEW.rc_iloscrezzr)-NEW.rc_iloscpoz,4); -- Jesli zarezerwowano wiecej niz pozostalo
   ---RAISE NOTICE 'Mam nadmiar % przy % % %',nadmiar,NEW.rc_iloscrez,NEW.rc_iloscrezzr,NEW.rc_iloscpoz;
   IF (nadmiar>0) AND (gm.istriggerfunctionactive('ZMNIEJSZREZERWACJEPZ'::gm.triggerfunction)=TRUE) THEN -- Anuluj wykorzystanie na rezerwacjach
    nadmiar=gm.zmniejszRezerwacjePZ(NEW.rc_idruchu,nadmiar);
    --- Mozna przyjac ze powstanie nadmiaru w tym miejscu jest bledem gdyz:
    --- nie moze byc ilosc rezerwacji zrealizowana poprzez FV wieksza od ilosci na PZecie
    --- gdyz wynikaloby z tego ze ilosc na FV jest wieksza od ilosci na PZecie
    IF (nadmiar>0) AND NOT (isBlockedPZ(NEW.rc_flaga)) THEN
     RAISE EXCEPTION 'Blad w AIUz - nie moge zdjac rezerwacji';
    END IF;
   END IF;

   ----------------------------------------------------------------------------------------------------------------------
   IF (TG_OP='INSERT') THEN
    PERFORM gm.updatePTM(NEW.prt_idpartiipz,NEW.ttm_idtowmag,NEW.rc_iloscpoz,NEW.rc_iloscrez-NEW.rc_iloscrezzr,0,FALSE,NEW.rc_iloscpoz+NEW.rc_iloscwzbuf,1);
   ELSE
    IF (NEW.prt_idpartiipz IS NOT DISTINCT FROM OLD.prt_idpartiipz) AND (isPZet(NEW.rc_flaga) AND isPZet(OLD.rc_flaga)) THEN
     PERFORM gm.updatePTM(NEW.prt_idpartiipz,NEW.ttm_idtowmag,NEW.rc_iloscpoz-OLD.rc_iloscpoz,
	                      (NEW.rc_iloscrez-NEW.rc_iloscrezzr)-(OLD.rc_iloscrez-OLD.rc_iloscrezzr),
						  0,FALSE,(NEW.rc_iloscpoz+NEW.rc_iloscwzbuf)-(OLD.rc_iloscpoz+OLD.rc_iloscwzbuf),
						  0
						 );
    ELSE
     IF (isPZet(OLD.rc_flaga)=TRUE) THEN
      PERFORM gm.updatePTM(OLD.prt_idpartiipz,OLD.ttm_idtowmag,-OLD.rc_iloscpoz,-(OLD.rc_iloscrez-OLD.rc_iloscrezzr),0,FALSE,-(OLD.rc_iloscpoz+OLD.rc_iloscwzbuf),-1);
     END IF;
     PERFORM gm.updatePTM(NEW.prt_idpartiipz,NEW.ttm_idtowmag,NEW.rc_iloscpoz,NEW.rc_iloscrez-NEW.rc_iloscrezzr,0,FALSE,NEW.rc_iloscpoz+NEW.rc_iloscwzbuf,1);
    END IF;
   END IF;
   ----------------------------------------------------------------------------------------------------------------------
  
   --- Doszedl nowy PZet lub zmienila sie na nim ilosc na plus, sproboj dobrac rezerwacje
   IF (NEW.rc_flaga&8192)<>0 AND NOT isBlockedPZ(NEW.rc_flaga) AND (NEW.rc_flaga&(1<<20))=0 THEN
    nadmiar=round(NEW.rc_iloscpoz-(NEW.rc_iloscrez-NEW.rc_iloscrezzr),4); -- Sproboj przeniesc nadmiar na rezerwacje
    nadmiar=gm.searchForRezerwacje(nadmiar,NEW);
   END IF;

  END IF;

  /*---------------------------------------*/
  IF isRezerwacja(NEW.rc_flaga) THEN
   nadmiar=round(NEW.rc_iloscrezzr-NEW.rc_iloscpoz,4); -- Jesli wykonano rezerwacje na wiecej niz bylo

   IF (nadmiar>0) THEN -- Anuluj wykorzystanie na fakturach
    ----RAISE NOTICE 'Nadmiar % % %',nadmiar,NEW.rc_iloscrezzr,NEW.rc_iloscpoz;
    FOR ruch_data IN SELECT rc_idruchu,rc_iloscrez AS rc_niezr FROM tg_ruchy WHERE rc_rezerwacja=NEW.rc_idruchu AND (rc_iloscrez>0) ORDER BY rc_dataop DESC,rc_idruchu DESC
    LOOP
     t_ile=round(max(min(nadmiar,ruch_data.rc_niezr),0),4);
     ----RAISE NOTICE 'Znalazlem %',t_ile;
     IF (t_ile>0) THEN
      UPDATE tg_ruchy SET rc_iloscrez=round(rc_iloscrez-t_ile,4) WHERE rc_idruchu=ruch_data.rc_idruchu;
      nadmiar=round(nadmiar-t_ile,4);
     END IF;
    END LOOP;
  
    IF (nadmiar>0) THEN
 ---    RAISE EXCEPTION 'Blad w AIUr - nie moge zdjac rezerwacji';
    END IF;

   END IF;
   
   ---Skasuj rezerwacje automatyczna nie podczepiona do niczego
   IF (RCisRezerwacjaA(NEW.rc_flaga) AND NOT RCisRezerwacjaR(NEW.rc_flaga) AND (NEW.tel_idelem=NULL)) THEN
    IF (NEW.rc_ilosc=0) THEN
     DELETE FROM gm.tg_rezstack WHERE rc_idruchu=NEW.rc_idruchu;
    END IF;
    DELETE FROM tg_ruchy WHERE rc_idruchu=NEW.rc_idruchu AND (gm.istriggerfunctionactive('DELZEROREZ'::gm.triggerfunction)=TRUE);
   END IF;

   IF ((NEW.rc_iloscrez<0) OR (NEW.rc_iloscpoz<0)) THEN
    ---RAISE EXCEPTION '10|%:%|Blad ujemnych rezerwacji % %',NEW.tel_idelem,NEW.rc_idruchu,NEW.rc_iloscrez,NEW.rc_iloscpoz;
   END IF;

   ----------------------------------------------------------------------------------------------------------------------
   IF (TG_OP='INSERT') THEN
    IF (isRezerwacjaLekka(NEW.rc_flaga)/* AND (NEW.rc_ruch IS NULL)*/) THEN
     PERFORM gm.updatePTM(NEW.prt_idpartiipz,NEW.ttm_idtowmag,0,0,NEW.rc_iloscrez,isRezerwacjaLekkaNULL(NEW.rc_flaga),0,0);
    END IF;
   ELSE
    IF (NEW.prt_idpartiipz IS NOT DISTINCT FROM OLD.prt_idpartiipz) AND 
       isRezerwacjaLekka(NEW.rc_flaga)=isRezerwacjaLekka(OLD.rc_flaga) AND
       isRezerwacjaLekkaNULL(NEW.rc_flaga)=isRezerwacjaLekkaNULL(OLD.rc_flaga) AND
       (NEW.rc_ruch IS NOT DISTINCT FROM OLD.rc_ruch)
    THEN
     PERFORM gm.updatePTM(NEW.prt_idpartiipz,NEW.ttm_idtowmag,0,0,NEW.rc_iloscrez-OLD.rc_iloscrez,isRezerwacjaLekkaNULL(NEW.rc_flaga),0,0);
    ELSE
     IF (isRezerwacjaLekka(OLD.rc_flaga) AND (OLD.rc_ruch IS NULL)) THEN
      PERFORM gm.updatePTM(OLD.prt_idpartiipz,OLD.ttm_idtowmag,0,0,-OLD.rc_iloscrez,isRezerwacjaLekkaNULL(OLD.rc_flaga),0,0);
     END IF;
     IF (isRezerwacjaLekka(NEW.rc_flaga) AND (NEW.rc_ruch IS NULL)) THEN
      PERFORM gm.updatePTM(NEW.prt_idpartiipz,NEW.ttm_idtowmag,0,0,NEW.rc_iloscrez,isRezerwacjaLekkaNULL(NEW.rc_flaga),0,0);
     END IF;
    END IF;
   END IF;
   ----------------------------------------------------------------------------------------------------------------------

  END IF;

  IF isBTK(NEW.rc_flaga) AND (NEW.rc_iloscpoz=0) AND (NEW.rc_ilosc=0) THEN
   DELETE FROM tg_ruchy WHERE rc_idruchu=NEW.rc_idruchu AND isBTK(rc_flaga);
  END IF;

  IF isRezerwacjaLekka(NEW.rc_flaga) AND (TG_OP='UPDATE') THEN
   IF (NEW.rc_iloscrez<OLD.rc_iloscrez) THEN
    PERFORM gm.searchAllRezerwacje(NEW.ttm_idtowmag,NEW.prt_idpartiipz);
   END IF;
  END IF;


  IF ((NEW.rc_flaga&(1<<19))=(1<<19)) THEN
   IF (TG_OP='UPDATE') THEN
    PERFORM gm.reinitBackOrderTranElem(OLD.tel_idelem);
   END IF;
   PERFORM gm.reinitBackOrderTranElem(NEW.tel_idelem);
  END IF;

 END IF;

 IF (TG_OP='DELETE') THEN

  IF isRezerwacjaLekka(OLD.rc_flaga) AND (OLD.prt_idpartiipz IS NOT NULL) THEN
   PERFORM gm.searchAllRezerwacje(OLD.ttm_idtowmag,OLD.prt_idpartiipz);
  END IF;

  IF (isFV(OLD.rc_flaga)) THEN
   --- Sprawdz wydanie MWS
   IF (OLD.rc_iloscrezzr>0) THEN
	IF (gm.checkMayUsuniecieMWS(OLD.tel_idelem,OLD.tex_idelem,isFV(OLD.rc_flaga))=FALSE) THEN
     RAISE EXCEPTION '32|%:%|Towar wydany juz przez MWS!',OLD.tel_idelem,OLD.rc_iloscrezzr;
	END IF;
   END IF;
  END IF;

  IF ((OLD.rc_flaga&(1<<19))=(1<<19)) THEN
--   RAISE EXCEPTION 'Robie reinit';
   PERFORM gm.reinitBackOrderTranElem(OLD.tel_idelem);
  END IF;

  IF (isPZet(OLD.rc_flaga)) THEN
   PERFORM gm.updatePTM(OLD.prt_idpartiipz,OLD.ttm_idtowmag,-OLD.rc_iloscpoz,-(OLD.rc_iloscrez-OLD.rc_iloscrezzr),0,FALSE,-(OLD.rc_iloscpoz+OLD.rc_iloscwzbuf),-1);
  END IF;

  IF (isRezerwacjaLekka(OLD.rc_flaga) AND (OLD.rc_ruch IS NULL)) THEN
   PERFORM gm.updatePTM(OLD.prt_idpartiipz,OLD.ttm_idtowmag,0,0,-OLD.rc_iloscrez,isRezerwacjaLekkaNULL(OLD.rc_flaga),0,0);
  END IF;

 END IF;

 IF (TG_OP<>'DELETE') THEN
  IF (isRezerwacjaLekka(NEW.rc_flaga) AND (NEW.prt_idpartiipz IS NULL) AND (NEW.rc_iloscpoz>0)) THEN
   RAISE EXCEPTION 'Blad rezerwacji lekkich % i %',NEW.prt_idpartiipz,NEW.rc_iloscpoz;
  END IF;
 END IF;

 ----RAISE NOTICE 'Skonczylem after';
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE 
  RETURN NEW;
 END IF;
END;
$$;
