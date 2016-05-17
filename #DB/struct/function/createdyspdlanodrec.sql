CREATE FUNCTION createdyspdlanodrec(tr_nodrec, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 nodrec          ALIAS FOR $1;
 _p_idpracownika ALIAS FOR $2;
 _dmag_typ       ALIAS FOR $3; 
 
 rec_rozm RECORD;
 
 _dmag_iddyspozycji INT;
 dmag               RECORD;
  
 _kwh_idheadu      INT;
 _ttw_idtowaru     INT;
 _ttm_idtowmag     INT;
 _knr_idelemu      INT;
 _knr_idelemu_idx  INT;
 _kwe_idelemu      INT;
 _knw_idelemu_koop INT;
 _knw_idelemu      INT;
 _mrpp_idpalety    INT;
 _prt_idpartiipz   INT;
 _prt_idpartiiwz   INT;
 _rmp_idsposobu    INT;
 _tmg_idmagazynu   INT;
 _zl_idzlecenia    INT;
 
 _dmag_ilosc           NUMERIC:=0;
 _dmag_iloscwmag       NUMERIC:=0;
 _dmag_iloscwmagclosed NUMERIC:=0;
 
 _dmag_znacznik TEXT; 
 _dmag_wplywmag INT;
 _dmag_flaga    INT:=(1<<5);
 
BEGIN
 IF (_dmag_typ<>2) THEN 
  RAISE LOG 'DEBUG: createDyspDlaNodRec(%,%,%): Warunek I', nodrec.knr_idelemu, _p_idpracownika, _dmag_typ;
  RETURN 0;
 END IF;
 
 IF ((nodrec.knr_iloscwyk-nodrec.knr_iloscrozch)<=0) THEN
  RAISE LOG 'DEBUG: createDyspDlaNodRec(%,%,%): Warunek II (%)', nodrec.knr_idelemu, _p_idpracownika, _dmag_typ, (nodrec.knr_iloscwyk-nodrec.knr_iloscrozch);
  RETURN 0;
 END IF;
  
 _knr_idelemu      = nodrec.knr_idelemu;
 _kwe_idelemu      = nodrec.kwe_idelemu;
 _kwh_idheadu      = nodrec.kwh_idheadu;
 _tmg_idmagazynu   = nodrec.tmg_idmagazynu;
 
 _dmag_iloscwmag       = 0;
 _dmag_iloscwmagclosed = 0;
 _dmag_wplywmag        = 1;  

 _zl_idzlecenia=(SELECT zl_idzlecenia FROM tg_planzlecenia WHERE pz_idplanu IN (SELECT pz_idplanu FROM tr_powiazanieplanprzychod WHERE knr_idelemu=_knr_idelemu) LIMIT 1);
 IF (COALESCE(_zl_idzlecenia,0)<=0) THEN
  _zl_idzlecenia=(SELECT zl_idzlecenia FROM tr_kkwhead WHERE kwh_idheadu=_kwh_idheadu LIMIT 1);
 END IF;
 
  
 IF (nodrec.knr_flaga&(1<<12)=0) THEN  -- Normalny nodrec  
  _dmag_ilosc = (nodrec.knr_iloscwyk-nodrec.knr_iloscrozch);
    
  _ttw_idtowaru = nodrec.ttw_idtowaru;
  _ttm_idtowmag = nodrec.ttm_idtowmag;
  -- _prt_idpartiipz = ;
  
  INSERT INTO tr_dyspozycjamag 
  (
   ttw_idtowaru, ttm_idtowmag, tmg_idmagazynu, dmag_wplywmag,
   kwh_idheadu, knr_idelemu, knr_idelemu_idx, kwe_idelemu, knw_idelemu_koop, knw_idelemu, 
   mrpp_idpalety, prt_idpartiipz, prt_idpartiiwz, p_idpracownika, 
   dmag_ilosc, dmag_iloscwmag, dmag_iloscwmagclosed, 
   dmag_znacznik, rmp_idsposobu, dmag_typ, dmag_flaga
  ) 
  VALUES
  (
   _ttw_idtowaru, _ttm_idtowmag, _tmg_idmagazynu, _dmag_wplywmag,
   _kwh_idheadu, _knr_idelemu, _knr_idelemu_idx, _kwe_idelemu, _knw_idelemu_koop, _knw_idelemu,
   _mrpp_idpalety, _prt_idpartiipz, _prt_idpartiiwz, _p_idpracownika,
   _dmag_ilosc, _dmag_iloscwmag, _dmag_iloscwmagclosed,
   _dmag_znacznik, _rmp_idsposobu, _dmag_typ, _dmag_flaga
  )
  RETURNING dmag_iddyspozycji INTO dmag;
 
  _dmag_iddyspozycji=dmag.dmag_iddyspozycji;
    
  UPDATE tr_nodrec SET knr_iloscdysp=_dmag_ilosc WHERE knr_idelemu=_knr_idelemu;
   
  RAISE LOG 'DEBUG: createDyspDlaNodRec(%,%,%): Sukces (%)', nodrec.knr_idelemu, _p_idpracownika, _dmag_typ, _dmag_ilosc;
 ELSE -- Rozmiarowka
  RAISE LOG 'DEBUG: createDyspDlaNodRec(%,%,%): Rozmiarowka - start', nodrec.knr_idelemu, _p_idpracownika, _dmag_typ;
  FOR rec_rozm  IN 
  SELECT 
  DISTINCT knrr.knr_idelemu,
  UNNEST(ARRAY_NULLZERO(ARRAY_MULTI(knrr_rozmiarwyst,knrr_idtowaru)))::int AS knrr_idtowaru,
  UNNEST(ARRAY_NULLZERO(knrr_iloscwyk)) AS knrr_iloscwyk,
  UNNEST(ARRAY_NULLZERO(knrr_iloscrozch)) AS knrr_iloscrozch
  FROM tr_nodrecrozmiarowka AS knrr
  WHERE (knrr.knr_idelemu = nodrec.knr_idelemu)
  LOOP
  
   _dmag_ilosc = (rec_rozm.knrr_iloscwyk-rec_rozm.knrr_iloscrozch);    
   _ttw_idtowaru = rec_rozm.knrr_idtowaru;
   _ttm_idtowmag = gettowmag(_ttw_idtowaru,_tmg_idmagazynu,TRUE);
	
	INSERT INTO tr_dyspozycjamag
    (
     ttw_idtowaru, ttm_idtowmag, tmg_idmagazynu, dmag_wplywmag,
     kwh_idheadu, kwe_idelemu, knw_idelemu_koop, knw_idelemu,
     mrpp_idpalety, p_idpracownika,
     dmag_ilosc, dmag_iloscwmag, dmag_iloscwmagclosed, 
     dmag_znacznik, rmp_idsposobu, dmag_typ, dmag_flaga
    )  
    VALUES
    (
     _ttw_idtowaru, _ttm_idtowmag, _tmg_idmagazynu, _dmag_wplywmag,
     _kwh_idheadu, _kwe_idelemu, _knw_idelemu_koop, _knw_idelemu,
     _mrpp_idpalety, _p_idpracownika,
     _dmag_ilosc, _dmag_iloscwmag, _dmag_iloscwmagclosed, 
     _dmag_znacznik, _rmp_idsposobu, _dmag_typ, _dmag_flaga
    )
    RETURNING dmag_iddyspozycji INTO dmag;
 
    _dmag_iddyspozycji=dmag.dmag_iddyspozycji;
            
    UPDATE tr_ruchy SET dmag_iddyspozycji=_dmag_iddyspozycji WHERE knw_idelemusrc=_knw_idelemu;
  
    RAISE LOG 'DEBUG: createDyspDlaNodRec(%,%,%): Sukces (%)', nodrec.knr_idelemu, _p_idpracownika, _dmag_typ, _dmag_ilosc;
  END LOOP;  
  RAISE LOG 'DEBUG: createDyspDlaNodRec(%,%,%): Rozmiarowka - koniec', nodrec.knr_idelemu, _p_idpracownika, _dmag_typ;    
 END IF; -- (nodrec.knr_flaga&(1<<12)=(1<<12))
 
 --_mrpp_idpalety=rec_kkw.mrpp_idpalety;
 --_rmp_idsposobu=rec_kkw.knw_rmp_idsposobu; 
    
 RETURN _dmag_iddyspozycji;
END;
$_$;
