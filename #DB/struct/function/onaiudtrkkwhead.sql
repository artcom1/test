CREATE FUNCTION onaiudtrkkwhead() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 _wynik INT;

 zlecenia_data_old BOOL:=FALSE;
 zlecenia_data_new BOOL:=FALSE;
BEGIN

 --------------------------------------------------------------------------------------
 ---Odnosnie zamykania KKW
 --------------------------------------------------------------------------------------
 IF (TG_OP='UPDATE') THEN
  IF ((NEW.kwh_flaga&3)<>(OLD.kwh_flaga&3)) THEN
   IF ((NEW.kwh_flaga&3)<>0) THEN
    UPDATE tr_kkwnodplan SET knp_flaga=knp_flaga|2 WHERE kwh_idheadu=NEW.kwh_idheadu AND knp_flaga&3=0;
   END IF;
   UPDATE tr_kkwnod SET kwe_flaga=(kwe_flaga&(~3))|(NEW.kwh_flaga&3) WHERE kwh_idheadu=NEW.kwh_idheadu;
   UPDATE tr_nodrec SET knr_flaga=(knr_flaga&(~3))|(NEW.kwh_flaga&3) WHERE kwh_idheadu=NEW.kwh_idheadu;   
   UPDATE tr_nodrecrozmiarowka set knr_idelemu=knr_idelemu WHERE knr_idelemu IN (SELECT nr.knr_idelemu FROM tr_nodrec AS nr WHERE nr.kwh_idheadu=NEW.kwh_idheadu);
  END IF;
 END IF;
 --------------------------------------------------------------------------------------
 ---Koniec odnosnie zamykania KKW
 --------------------------------------------------------------------------------------

 --------------------------------------------------------------------------------------
 ---Odnosnie backorderow
 --------------------------------------------------------------------------------------
 IF (TG_OP='UPDATE') THEN

  IF (NullZero(NEW.zl_idzlecenia)!=NullZero(OLD.zl_idzlecenia)) THEN
   --- zmienilo sie zlecenie - trzeba uaktualnic daty na zleceniach
   zlecenia_data_old=TRUE;
   zlecenia_data_new=TRUE;
  END IF;
  IF (NullZero(NEW.zl_idzlecenia)>0) THEN
   ---mamy zlecenie wiec sprawdzamy czy daty zdarzenia nie ulegly zmianie, jesli tak to uaktualniamy daty na zleceniu
   IF (coalesce(NEW.kwh_dataplanstop,NEW.kwh_datazak)<>coalesce(OLD.kwh_dataplanstop,OLD.kwh_datazak) OR coalesce(NEW.kwh_dataplanstart,NEW.kwh_datarozp)<>coalesce(OLD.kwh_dataplanstart,OLD.kwh_datarozp)) THEN
    zlecenia_data_new=TRUE;
   END IF;
  END IF;

  IF ((NEW.kwh_flaga&3)<>0) THEN
   ---KKW zamkniete, kasujemy backordery
   PERFORM dodajBackOrderKKW(NEW.kwh_idheadu,(SELECT ttm_idtowmag FROM tg_towmag WHERE ttw_idtowaru=NEW.ttw_idtowaru AND tmg_idmagazynu=NEW.tmg_idmagazynu_def),0,4,coalesce(NEW.kwh_dataplanstop,NEW.kwh_datazak)::date,NEW.zl_idzlecenia,NEW.kwh_towary,NEW.tmg_idmagazynu_def);
  ELSE
   ---KKW otwarte sprawdzamy czy trzeba zmieniac cos na backorderach

   ---ODNOSNIE BACKORDEROW z receptur
   IF (coalesce(NEW.kwh_dataplanstop,NEW.kwh_datazak)<>coalesce(OLD.kwh_dataplanstop,OLD.kwh_datazak)) THEN
    ---uaktualniam date na backorderach plusowych
    _wynik=(SELECT sum(i) FROM (SELECT DodajBackOrderNodRec(knr_idelemu,ttm_idtowmag,max(knr_iloscplan-knr_iloscrozch,0),3,1,coalesce(NEW.kwh_dataplanstop,NEW.kwh_datazak)::date,zl_idzlecenia,knr_flaga,nod.tmg_idmagazynu) AS i FROM tr_nodrec AS nod JOIN tr_kkwhead AS kkw USING (kwh_idheadu) WHERE nod.kwh_idheadu=NEW.kwh_idheadu AND knr_flaga&(4+2+1)=0 AND knr_wplywmag=1) AS t);
   END IF;
   IF (coalesce(NEW.kwh_dataplanstart,NEW.kwh_datarozp)<>coalesce(OLD.kwh_dataplanstart,OLD.kwh_datarozp)) THEN
    ---uaktualniam date na backorderach plusowych
    _wynik=(SELECT sum(i) FROM (SELECT DodajBackOrderNodRec(knr_idelemu,ttm_idtowmag,max(knr_iloscplan-knr_iloscrozch,0),3,0,coalesce(NEW.kwh_dataplanstart,NEW.kwh_datarozp)::date,zl_idzlecenia,knr_flaga,nod.tmg_idmagazynu) AS i FROM tr_nodrec AS nod JOIN tr_kkwhead AS kkw USING (kwh_idheadu) WHERE nod.kwh_idheadu=NEW.kwh_idheadu AND knr_flaga&(4+2+1)=0 AND knr_wplywmag=-1) AS t);
   END IF;

   --ODNOSNIE BACKORDEROW z KKW
   IF ((NEW.tmg_idmagazynu_def!=OLD.tmg_idmagazynu_def) OR (NEW.ttw_idtowaru!=OLD.ttw_idtowaru)) THEN  ---zmiana magazynu lub wyrobu wiec musimy przeliczyc backordery
    ---dodajemy nowy wyrob na nowy magazyn
    PERFORM dodajBackOrderKKW(NEW.kwh_idheadu,(SELECT ttm_idtowmag FROM tg_towmag WHERE ttw_idtowaru=NEW.ttw_idtowaru AND tmg_idmagazynu=NEW.tmg_idmagazynu_def),max(0,NEW.kwh_iloscoczek-NEW.kwh_iloscwmag),4,coalesce(NEW.kwh_dataplanstop,NEW.kwh_datazak)::date,NEW.zl_idzlecenia,NEW.kwh_towary,NEW.tmg_idmagazynu_def);
    ---kasujemy stary wyrob na starym magazynie
    PERFORM dodajBackOrderKKW(NEW.kwh_idheadu,(SELECT ttm_idtowmag FROM tg_towmag WHERE ttw_idtowaru=OLD.ttw_idtowaru AND tmg_idmagazynu=OLD.tmg_idmagazynu_def),0,4,coalesce(NEW.kwh_dataplanstop,NEW.kwh_datazak)::date,NEW.zl_idzlecenia,NEW.kwh_towary,OLD.tmg_idmagazynu_def);
   END IF;

   PERFORM dodajBackOrderKKW(NEW.kwh_idheadu,(SELECT ttm_idtowmag FROM tg_towmag WHERE ttw_idtowaru=NEW.ttw_idtowaru AND tmg_idmagazynu=NEW.tmg_idmagazynu_def),max(0,NEW.kwh_iloscoczek-NEW.kwh_iloscwmag),4,coalesce(NEW.kwh_dataplanstop,NEW.kwh_datazak)::date,NEW.zl_idzlecenia,NEW.kwh_towary,NEW.tmg_idmagazynu_def); 
   
  END IF;
 END IF;

 IF (TG_OP='INSERT') THEN
  IF ((NEW.kwh_flaga&3)=0) THEN
   PERFORM dodajBackOrderKKW(NEW.kwh_idheadu,(SELECT ttm_idtowmag FROM tg_towmag WHERE ttw_idtowaru=NEW.ttw_idtowaru AND tmg_idmagazynu=NEW.tmg_idmagazynu_def),max(0,NEW.kwh_iloscoczek-NEW.kwh_iloscwmag),4,coalesce(NEW.kwh_dataplanstop,NEW.kwh_datazak)::date,NEW.zl_idzlecenia,NEW.kwh_towary,NEW.tmg_idmagazynu_def);
  END IF;

  IF (NullZero(NEW.zl_idzlecenia)>0) THEN
   ---mamy zlecenie wiec trzeba uaktualnic date na tym zleceniu
   zlecenia_data_new=TRUE;
  END IF;

 END IF;
 --------------------------------------------------------------------------------------
 ---Koniec odnosnie backorderow
 --------------------------------------------------------------------------------------

 IF (TG_OP='DELETE') THEN
  IF (NullZero(OLD.zl_idzlecenia)>0) THEN
   ---mamy zlecenie wiec trzeba uaktualnic date na tym zleceniu
   zlecenia_data_old=TRUE;
  END IF;
 END IF;

 ---------------------------------------------------------------------
 ----UAKTUALNIAMY DATY NA ZLECENIACH JESLI TAKA POTRZEBA
 ---------------------------------------------------------------------
 
 IF (zlecenia_data_old) THEN
  PERFORM PrzeliczDatyOkresZlecenia(OLD.zl_idzlecenia,NULL, OLD.kwh_idheadu);
 END IF;

 IF (zlecenia_data_new) THEN
  PERFORM PrzeliczDatyOkresZlecenia(NEW.zl_idzlecenia,NULL, NULL);
 END IF;
 ---------------------------------------------------------------------
 ----KONIEC UAKTUALNIANIA DATY NA ZLECENIACH JESLI TAKA POTRZEBA
 ---------------------------------------------------------------------
 
 ---------------------------------------------------------------------
 ----UAKTUALNIAMY DATY NA PIERWSZYCH KKWNODACH 
 --------------------------------------------------------------------- 
 IF (TG_OP='UPDATE') THEN
  IF (NEW.kwh_datarozp<>OLD.kwh_datarozp) THEN
   UPDATE tr_kkwnod AS nod SET kwe_datazakonczenia_prev=NEW.kwh_datarozp WHERE nod.kwh_idheadu=NEW.kwh_idheadu AND nod.kwe_iloscpoprzednikow=0;
  END IF;
 END IF;
 ---------------------------------------------------------------------
 ----KONIEC UAKTUALNIANIA DATY NA PIERWSZYCH KKWNODACH 
 ---------------------------------------------------------------------
 
 ---------------------------------------------------------------------
 ----UAKTUALNIAMY ARRAY planowanych ilosci dla nodrecrozmiarowka
 ---------------------------------------------------------------------   
IF (TG_OP='UPDATE') THEN
 IF (
     NEW.kwh_iloscoczek_array IS DISTINCT FROM OLD.kwh_iloscoczek_array  OR
     NEW.kwh_iloscwyk_array   IS DISTINCT FROM OLD.kwh_iloscwyk_array
	) THEN
  RAISE NOTICE '+: kwh_iloscoczek_array: %->%, kwh_iloscwyk_array: %->%', OLD.kwh_iloscoczek_array, NEW.kwh_iloscoczek_array, OLD.kwh_iloscwyk_array, NEW.kwh_iloscwyk_array;
  UPDATE tr_nodrecrozmiarowka SET knr_idelemu=knr_idelemu WHERE knr_idelemu IN (SELECT knr_idelemu FROM tr_nodrec WHERE kwe_idelemu is NULL AND kwh_idheadu=NEW.kwh_idheadu);
 ELSE
  RAISE NOTICE '-: kwh_iloscoczek_array: %->%, kwh_iloscwyk_array: %->%', OLD.kwh_iloscoczek_array, NEW.kwh_iloscoczek_array, OLD.kwh_iloscwyk_array, NEW.kwh_iloscwyk_array;
 END IF;
END IF;
 ---------------------------------------------------------------------
 ----KONIEC UAKTUALNIAMY ARRAY planowanych ilosci dla nodrecrozmiarowka
 ---------------------------------------------------------------------

 ---------------------------------------------------------------------
 ----UAKTUALNIAMY ILOSCI NA ROZCHODACH NAGLOWKOWYCH
 --------------------------------------------------------------------- 
 IF (TG_OP='UPDATE') THEN ---aktualizacja ilosci planowanych
  IF (NEW.kwh_iloscoczek<>OLD.kwh_iloscoczek) THEN
   UPDATE tr_kkwnodprevnext SET knpn_kwhilosc=NEW.kwh_iloscoczek WHERE kwh_idheadu=NEW.kwh_idheadu;
  END IF;
  
  IF ((NEW.kwh_iloscwyk<>OLD.kwh_iloscwyk) OR (NEW.kwh_iloscoczek<>OLD.kwh_iloscoczek)) THEN    
   UPDATE tr_nodrec SET 
   knr_iloscplan=KKWNODobliczilosc(NEW.kwh_iloscoczek,0,knr_licznik,knr_mianownik,trr_flaga,knr_flaga),
   knr_iloscwyk=KKWNODobliczilosc(NEW.kwh_iloscwyk,0,knr_licznik,knr_mianownik,trr_flaga,knr_flaga) 
   WHERE 
   kwe_idelemu IS NULL AND 
   kwh_idheadu=NEW.kwh_idheadu AND
   knr_flaga&(1<<12)=0;
    
   UPDATE tr_nodrec SET 
   knr_iloscplan=array_sum(KKWNODObliczIlosc_ARRAY(NEW.kwh_iloscoczek_array,NULL,(SELECT knrr_rozmiarwyst FROM tr_nodrecrozmiarowka AS ro WHERE ro.knr_idelemu=tr_nodrec.knr_idelemu),knr_licznik,knr_mianownik,trr_flaga,knr_flaga,0)),
   knr_iloscwyk=array_sum(KKWNODObliczIlosc_ARRAY(NEW.kwh_iloscwyk_array,NULL,(SELECT knrr_rozmiarwyst FROM tr_nodrecrozmiarowka AS ro WHERE ro.knr_idelemu=tr_nodrec.knr_idelemu),knr_licznik,knr_mianownik,trr_flaga,knr_flaga,0))
   WHERE 
   kwe_idelemu IS NULL AND 
   kwh_idheadu=NEW.kwh_idheadu AND
   knr_flaga&(1<<12)=(1<<12);
  END IF;
  
 END IF; ---koniec - aktualizacja ilosci planowanych
 ---------------------------------------------------------------------
 ----KONIEC UAKTUALNIAMY ILOSCI NA ROZCHODACH NAGLOWKOWYCH
 ---------------------------------------------------------------------


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
