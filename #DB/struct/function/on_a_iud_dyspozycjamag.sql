CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltai_dysp v.delta; 
 deltaimag_dysp v.delta;
 deltaimagc_dysp v.delta;
 
 _ttw_idtowaru     INT; 
 _dmag_flaga       INT; 
 _dmag_typ         INT;
 
 _knr_idelemu      INT;
 _knr_idelemu_idx  INT;
 _kwe_idelemu      INT;
 _knw_idelemu      INT;
 _knw_idelemu_koop INT;
 
 _knw_towar_idx    INT;
 
 _do_update        BOOLEAN;
BEGIN
 IF (TG_OP<>'INSERT') THEN
  deltai_dysp.value_old=OLD.dmag_ilosc;
  deltaimag_dysp.value_old=OLD.dmag_iloscwmag; 
  deltaimagc_dysp.value_old=OLD.dmag_iloscwmagclosed;
   
  _dmag_flaga=OLD.dmag_flaga;
  _dmag_typ=OLD.dmag_typ;
   
  _knr_idelemu=OLD.knr_idelemu;
  _knr_idelemu_idx=OLD.knr_idelemu_idx;
  _kwe_idelemu=OLD.kwe_idelemu;
  _knw_idelemu=OLD.knw_idelemu;
  _ttw_idtowaru=OLD.ttw_idtowaru;
  _knw_idelemu_koop=OLD.knw_idelemu_koop;   
 END IF;
  
 IF (TG_OP<>'DELETE') THEN   
  deltai_dysp.value_new=NEW.dmag_ilosc;
  deltaimag_dysp.value_new=NEW.dmag_iloscwmag; 
  deltaimagc_dysp.value_new=NEW.dmag_iloscwmagclosed;
   
  _dmag_flaga=NEW.dmag_flaga;
  _dmag_typ=NEW.dmag_typ;
   
  _knr_idelemu=NEW.knr_idelemu;
  _knr_idelemu_idx=NEW.knr_idelemu_idx;
  _kwe_idelemu=NEW.kwe_idelemu;
  _knw_idelemu=NEW.knw_idelemu;
  _ttw_idtowaru=NEW.ttw_idtowaru;
  _knw_idelemu_koop=NEW.knw_idelemu_koop;  
 END IF;

 IF (_dmag_flaga&(1<<7)=(1<<7)) THEN -- Naglowkowa - nie uaktualniam nic
  IF (TG_OP='DELETE') THEN 
   RETURN OLD; 
  ELSE 
   RETURN NEW; 
  END IF;
 END IF;
 
 ----------------------------------------------------------------
 ----------------------------------------------------------------
 ---  OLD
 ----------------------------------------------------------------
 ----------------------------------------------------------------
 IF (v.deltavalueold(deltai_dysp)<>0 OR v.deltavalueold(deltaimag_dysp)<>0 OR v.deltavalueold(deltaimagc_dysp)<>0) THEN
  _do_update=TRUE;
  
  ----------------------------------------------------------------
  -- NODREC
  IF (_do_update AND (v.deltavalueold(deltaimag_dysp)<>0 OR v.deltavalueold(deltai_dysp)<>0) AND COALESCE(_knr_idelemu)>0) THEN  
   IF (_dmag_flaga&(1+2)=1) THEN --zamowienia    
    IF (_knr_idelemu_idx IS NOT NULL) THEN
     UPDATE tr_nodrecrozmiarowka SET 
     knrr_iloscdysp[_knr_idelemu_idx]=nullzero(knrr_iloscdysp[_knr_idelemu_idx])-v.deltavalueold(deltai_dysp),
     knrr_ilosczam[_knr_idelemu_idx]=nullzero(knrr_ilosczam[_knr_idelemu_idx])-v.deltavalueold(deltaimag_dysp) 
     WHERE knr_idelemu=_knr_idelemu; 
    ELSE
     UPDATE tr_nodrec SET 
     knr_iloscdysp=knr_iloscdysp-v.deltavalueold(deltai_dysp),
     knr_ilosczam=knr_ilosczam-v.deltavalueold(deltaimag_dysp) 
     WHERE knr_idelemu=_knr_idelemu;
    END IF;
   ELSE
    IF (_knr_idelemu_idx IS NOT NULL) THEN     
     UPDATE tr_nodrecrozmiarowka SET 
     knrr_iloscdysp[_knr_idelemu_idx]=nullzero(knrr_iloscdysp[_knr_idelemu_idx])-v.deltavalueold(deltai_dysp),
     knrr_iloscrozch[_knr_idelemu_idx]=nullzero(knrr_iloscrozch[_knr_idelemu_idx])-v.deltavalueold(deltaimag_dysp) 
     WHERE knr_idelemu=_knr_idelemu;
    ELSE	 	
	 IF (_dmag_typ=4) THEN -- Narzedzia+
      UPDATE tr_nodrec SET 
      knr_iloscdysp=knr_iloscdysp-v.deltavalueold(deltai_dysp),
      knr_iloscnarz_plus=knr_iloscnarz_plus-v.deltavalueold(deltaimag_dysp) 
      WHERE knr_idelemu=_knr_idelemu;
      _do_update=FALSE;	 
	 END IF;	 
	 IF (_dmag_typ=6) THEN -- Narzedzia-
      UPDATE tr_nodrec SET 
      knr_iloscdysp=knr_iloscdysp+v.deltavalueold(deltai_dysp),
      knr_iloscnarz_minus=knr_iloscnarz_minus-v.deltavalueold(deltaimag_dysp) 
      WHERE knr_idelemu=_knr_idelemu;
      _do_update=FALSE;	 
	 END IF;	 	 
	 IF (_do_update) THEN
      UPDATE tr_nodrec SET 
      knr_iloscdysp=knr_iloscdysp-v.deltavalueold(deltai_dysp),
      knr_iloscrozch=knr_iloscrozch-v.deltavalueold(deltaimag_dysp) 
      WHERE knr_idelemu=_knr_idelemu;
	 END IF;	 
    END IF;
   END IF;   
   _do_update=FALSE;
  END IF;
    
  ----------------------------------------------------------------
  -- NODWYK
  IF (_do_update AND (v.deltavalueold(deltaimag_dysp)<>0 OR v.deltavalueold(deltaimagc_dysp)<>0) AND COALESCE(_knw_idelemu)>0) THEN    
   _knw_towar_idx = getTowarIDXForKKWNodWyk(_knw_idelemu,_ttw_idtowaru);  
   IF (_knw_towar_idx IS NULL) THEN
    UPDATE tr_kkwnodwyk SET 
    knw_tomagmag=knw_tomagmag-v.deltavalueold(deltaimag_dysp),
    knw_tomagmagclosed=knw_tomagmagclosed-v.deltavalueold(deltaimagc_dysp) 
    WHERE (knw_idelemu=_knw_idelemu);
   ELSE
    UPDATE tr_kkwnodwyk SET 
    knw_tomagmag=knw_tomagmag-v.deltavalueold(deltaimag_dysp),
    knw_tomagmag_arr[_knw_towar_idx]=knw_tomagmag_arr[_knw_towar_idx]-v.deltavalueold(deltaimag_dysp),
    knw_tomagmagclosed=knw_tomagmagclosed-v.deltavalueold(deltaimagc_dysp),
    knw_tomagmagclosed_arr[_knw_towar_idx]=knw_tomagmagclosed_arr[_knw_towar_idx]-v.deltavalueold(deltaimagc_dysp)
    WHERE (knw_idelemu=_knw_idelemu);
   END IF;
   
   _do_update=FALSE;
  END IF;
  
  ----------------------------------------------------------------
  -- KKWNOD
  IF (_do_update AND (v.deltavalueold(deltaimag_dysp)<>0 OR v.deltavalueold(deltaimagc_dysp)<>0) AND COALESCE(_kwe_idelemu)>0) THEN
   IF (_dmag_typ=5) THEN
    UPDATE tr_kkwnod SET 
    kwe_ilosczamuslkoop=kwe_ilosczamuslkoop-v.deltavalueold(deltaimag_dysp)
    WHERE (kwe_idelemu=_kwe_idelemu);
   ELSE
    UPDATE tr_kkwnod SET 
    kwe_tomagmag=kwe_tomagmag-v.deltavalueold(deltaimag_dysp),
    kwe_tomagmagclosed=kwe_tomagmagclosed-v.deltavalueold(deltaimagc_dysp) 
    WHERE (kwe_idelemu=_kwe_idelemu);
   END IF;
   
   _do_update=FALSE;
  END IF;  
 END IF;
 
 ----------------------------------------------------------------
 ----------------------------------------------------------------
 ---  NEW
 ----------------------------------------------------------------
 ----------------------------------------------------------------
 IF (v.deltavaluenew(deltai_dysp)<>0 OR v.deltavaluenew(deltaimag_dysp)<>0 OR v.deltavaluenew(deltaimagc_dysp)<>0) THEN
  _do_update=TRUE;
  
  ----------------------------------------------------------------
  -- NODREC
  IF (_do_update AND (v.deltavaluenew(deltaimag_dysp)<>0 OR v.deltavaluenew(deltai_dysp)<>0) AND COALESCE(_knr_idelemu)>0) THEN  
   IF (_dmag_flaga&(1+2)=1) THEN --zamowienia    
    IF (_knr_idelemu_idx IS NOT NULL) THEN
     UPDATE tr_nodrecrozmiarowka SET 
     knrr_iloscdysp[_knr_idelemu_idx]=nullzero(knrr_iloscdysp[_knr_idelemu_idx])+v.deltavaluenew(deltai_dysp),
     knrr_ilosczam[_knr_idelemu_idx]=nullzero(knrr_ilosczam[_knr_idelemu_idx])+v.deltavaluenew(deltaimag_dysp) 
     WHERE knr_idelemu=_knr_idelemu; 
    ELSE
     UPDATE tr_nodrec SET 
     knr_iloscdysp=knr_iloscdysp+v.deltavaluenew(deltai_dysp),
     knr_ilosczam=knr_ilosczam+v.deltavaluenew(deltaimag_dysp) 
     WHERE knr_idelemu=_knr_idelemu;
    END IF;
   ELSE      
    IF (_knr_idelemu_idx IS NOT NULL) THEN     
     UPDATE tr_nodrecrozmiarowka SET 
     knrr_iloscdysp[_knr_idelemu_idx]=nullzero(knrr_iloscdysp[_knr_idelemu_idx])+v.deltavaluenew(deltai_dysp),
     knrr_iloscrozch[_knr_idelemu_idx]=nullzero(knrr_iloscrozch[_knr_idelemu_idx])+v.deltavaluenew(deltaimag_dysp) 
     WHERE knr_idelemu=_knr_idelemu;
    ELSE	
	 IF (_dmag_typ=4) THEN -- Narzedzia+
      UPDATE tr_nodrec SET 
      knr_iloscdysp=knr_iloscdysp+v.deltavaluenew(deltai_dysp),
      knr_iloscnarz_plus=knr_iloscnarz_plus+v.deltavaluenew(deltaimag_dysp) 
      WHERE knr_idelemu=_knr_idelemu;
      _do_update=FALSE;	 
	 END IF;	 
	 IF (_dmag_typ=6) THEN -- Narzedzia-
      UPDATE tr_nodrec SET 
      knr_iloscdysp=knr_iloscdysp-v.deltavaluenew(deltai_dysp),
      knr_iloscnarz_minus=knr_iloscnarz_minus+v.deltavaluenew(deltaimag_dysp) 
      WHERE knr_idelemu=_knr_idelemu;
      _do_update=FALSE;	 
	 END IF;	 	 
	 IF (_do_update) THEN
      UPDATE tr_nodrec SET 
      knr_iloscdysp=knr_iloscdysp+v.deltavaluenew(deltai_dysp),
      knr_iloscrozch=knr_iloscrozch+v.deltavaluenew(deltaimag_dysp) 
      WHERE knr_idelemu=_knr_idelemu;
	 END IF;
    END IF;
   END IF;   
   _do_update=FALSE;
  END IF;
    
  ----------------------------------------------------------------
  -- NODWYK
  IF (_do_update AND (v.deltavaluenew(deltaimag_dysp)<>0 OR v.deltavaluenew(deltaimagc_dysp)<>0) AND COALESCE(_knw_idelemu)>0) THEN
   _knw_towar_idx = getTowarIDXForKKWNodWyk(_knw_idelemu,_ttw_idtowaru);  
   IF (_knw_towar_idx IS NULL) THEN
    UPDATE tr_kkwnodwyk SET 
    knw_tomagmag=knw_tomagmag+v.deltavaluenew(deltaimag_dysp),
    knw_tomagmagclosed=knw_tomagmagclosed+v.deltavaluenew(deltaimagc_dysp) 
    WHERE (knw_idelemu=_knw_idelemu); 
   ELSE
    UPDATE tr_kkwnodwyk SET 
    knw_tomagmag=knw_tomagmag+v.deltavaluenew(deltaimag_dysp),
    knw_tomagmag_arr[_knw_towar_idx]=knw_tomagmag_arr[_knw_towar_idx]-v.deltavaluenew(deltaimag_dysp),
    knw_tomagmagclosed=knw_tomagmagclosed+v.deltavaluenew(deltaimagc_dysp),
    knw_tomagmagclosed_arr[_knw_towar_idx]=knw_tomagmagclosed_arr[_knw_towar_idx]-v.deltavaluenew(deltaimagc_dysp)
    WHERE (knw_idelemu=_knw_idelemu);
   END IF;
   
   _do_update=FALSE;
  END IF;
  
  ----------------------------------------------------------------
  -- KKWNOD
  IF (_do_update AND (v.deltavaluenew(deltaimag_dysp)<>0 OR v.deltavaluenew(deltaimagc_dysp)<>0) AND COALESCE(_kwe_idelemu)>0) THEN  
   IF (_dmag_typ=5) THEN
    UPDATE tr_kkwnod SET 
    kwe_ilosczamuslkoop=kwe_ilosczamuslkoop+v.deltavaluenew(deltaimag_dysp)
    WHERE (kwe_idelemu=_kwe_idelemu);
   ELSE
    UPDATE tr_kkwnod SET 
    kwe_tomagmag=kwe_tomagmag+v.deltavaluenew(deltaimag_dysp),
    kwe_tomagmagclosed=kwe_tomagmagclosed+v.deltavaluenew(deltaimagc_dysp) 
    WHERE (kwe_idelemu=_kwe_idelemu); 
   END IF;     
   
   _do_update=FALSE;
  END IF;
 END IF;
     
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
 
END;
$$;
