CREATE FUNCTION createdyspdlakkwnodnormal(tr_kkwnod, integer, boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 kkwnod          ALIAS FOR $1;
 _p_idpracownika ALIAS FOR $2;
 _isRozmiarowka  ALIAS FOR $3;
 
 rec_kkwnodwyk RECORD;
 rec_kkw       RECORD;
 
 _dmag_iddyspozycji INT;
 dmag               RECORD;
  
 _kwh_idheadu    INT;
 _kwe_idelemu    INT;
 _dmag_typ       INT;
 _dmag_wplywmag  INT;
 
 _ttw_idtowaru   INT;
 _ttm_idtowmag   INT;
 _tmg_idmagazynu INT;
 _zl_idzlecenia  INT;
   
 _knw_idelemu    INT;
 _mrpp_idpalety  INT;
 _rmp_idsposobu  INT; 
 
 _dmag_ilosc           NUMERIC:=0; 
 _dmag_iloscwmag       NUMERIC:=0;
 _dmag_iloscwmagclosed NUMERIC:=0;
 
 _dmag_znacznik    TEXT; 
 _dmag_flaga       INT:=(1<<5);
 
 _knw_idelemu_koop INT; 
BEGIN
 IF (_isRozmiarowka=TRUE) THEN
  RAISE LOG 'DEBUG: createDyspDlaKKWNodNormal(%,%,%): Warunek I', kkwnod.kwe_idelemu, _p_idpracownika, _isRozmiarowka;
  RETURN 0;
 END IF;
 
 IF ((kkwnod.the_flaga&(1<<0))=0 OR kkwnod.kwe_iloscwyk=0) THEN
  RAISE LOG 'DEBUG: createDyspDlaKKWNodNormal(%,%,%): Warunek II (%,%)', kkwnod.kwe_idelemu, _p_idpracownika, _isRozmiarowka, kkwnod.the_flaga, kkwnod.kwe_iloscwyk;
  RETURN 0;
 END IF;
 
 -- Z Noda
 _kwh_idheadu   = kkwnod.kwh_idheadu;
 _kwe_idelemu   = kkwnod.kwe_idelemu;
 _dmag_typ      = 3;
 _dmag_wplywmag = 1;
 
 IF (_kwh_idheadu IS NOT NULL) THEN  
  SELECT gettowmag(ttw_idtowaru,tmg_idmagazynu_def,TRUE) AS ttm_idtowmag, ttw_idtowaru, tmg_idmagazynu_def, zl_idzlecenia INTO rec_kkw
  FROM tr_kkwhead WHERE kwh_idheadu=_kwh_idheadu;
  _ttw_idtowaru=rec_kkw.ttw_idtowaru;
  _ttm_idtowmag=rec_kkw.ttm_idtowmag;
  _tmg_idmagazynu=rec_kkw.tmg_idmagazynu_def;
  _zl_idzlecenia=rec_kkw.zl_idzlecenia;  
 END IF;
  
 IF ((kkwnod.the_flaga&(1<<12))=0) THEN -- jedna dyspozycja dla calego kkwnoda  
 
  _dmag_ilosc=(kkwnod.kwe_iloscwyk*kkwnod.kwe_mnoznikwyrobu_m)/kkwnod.kwe_mnoznikwyrobu_l;
  _dmag_iloscwmag=kkwnod.kwe_tomagmag;
  _dmag_iloscwmagclosed=kkwnod.kwe_tomagmagclosed;
   
  INSERT INTO tr_dyspozycjamag 
  (
   ttw_idtowaru, ttm_idtowmag, tmg_idmagazynu, dmag_wplywmag,
   kwh_idheadu, kwe_idelemu, knw_idelemu_koop, knw_idelemu,
   mrpp_idpalety, p_idpracownika, zl_idzlecenia,
   dmag_ilosc, dmag_iloscwmag, dmag_iloscwmagclosed, 
   dmag_znacznik, rmp_idsposobu, dmag_typ, dmag_flaga
  ) 
  VALUES
  (
   _ttw_idtowaru, _ttm_idtowmag, _tmg_idmagazynu, _dmag_wplywmag,
   _kwh_idheadu, _kwe_idelemu, _knw_idelemu_koop, _knw_idelemu,
   _mrpp_idpalety, _p_idpracownika, _zl_idzlecenia,
   _dmag_ilosc, _dmag_iloscwmag, _dmag_iloscwmagclosed, 
   _dmag_znacznik, _rmp_idsposobu, _dmag_typ, _dmag_flaga
  )
  RETURNING dmag_iddyspozycji INTO dmag;
  _dmag_iddyspozycji=dmag.dmag_iddyspozycji;
    
  UPDATE tr_ruchy SET dmag_iddyspozycji=_dmag_iddyspozycji WHERE kwe_idelemusrc=kkwnod.kwe_idelemu;
  
  RAISE LOG 'DEBUG: createDyspDlaKKWNodNormal(%,%,%): Sukces (%<->%)', kkwnod.kwe_idelemu, _p_idpracownika, _isRozmiarowka, kkwnod.kwe_idelemu, _dmag_iddyspozycji;
  RETURN _dmag_iddyspozycji;
 ELSE  
  IF (kkwnod.kwe_nodtype=1) THEN -- KKWNWT_KOOPERACJA
   RAISE LOG 'DEBUG: createDyspDlaKKWNodNormal(%,%,%): Kooperacja - start', kkwnod.kwe_idelemu, _p_idpracownika, _isRozmiarowka;
   FOR rec_kkwnodwyk IN 
   SELECT knw_idelemu, mrpp_idpalety, knw_rmp_idsposobu, knw_uwagi, knw_iloscwyk, knw_tomagmag, knw_tomagmagclosed   
   FROM tr_kkwnodwyk WHERE kwe_idelemu=kkwnod.kwe_idelemu
   LOOP
    _knw_idelemu=rec_kkwnodwyk.knw_idelemu;
	_mrpp_idpalety=rec_kkwnodwyk.mrpp_idpalety;
    _rmp_idsposobu=rec_kkwnodwyk.knw_rmp_idsposobu;
	_dmag_ilosc=(rec_kkwnodwyk.knw_iloscwyk*kkwnod.kwe_mnoznikwyrobu_m)/kkwnod.kwe_mnoznikwyrobu_l;
    _dmag_iloscwmag=rec_kkwnodwyk.knw_tomagmag;
    _dmag_iloscwmagclosed=rec_kkwnodwyk.knw_tomagmagclosed;
    _dmag_znacznik=rec_kkwnodwyk.knw_uwagi;
    _dmag_flaga=_dmag_flaga|(1<<2);
	
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
  
    RAISE LOG 'DEBUG: createDyspDlaKKWNodNormal(%,%,%): Sukces K (%<->%)', kkwnod.kwe_idelemu, _p_idpracownika, _isRozmiarowka, _knw_idelemu, _dmag_iddyspozycji;  
   END LOOP;
   RAISE LOG 'DEBUG: createDyspDlaKKWNodNormal(%,%,%): Kooperacja - stop', kkwnod.kwe_idelemu, _p_idpracownika, _isRozmiarowka;
   RETURN 1;
  END IF;
  
  IF (kkwnod.kwe_nodtype=0) THEN -- KKWNWT_NORMALNOD
   RAISE LOG 'DEBUG: createDyspDlaKKWNodNormal(%,%,%): Operacja - start', kkwnod.kwe_idelemu, _p_idpracownika, _isRozmiarowka;
   FOR rec_kkwnodwyk IN 
   SELECT knw_idelemu, mrpp_idpalety, knw_rmp_idsposobu, knw_uwagi, knw_iloscwyk, knw_tomagmag, knw_tomagmagclosed   
   FROM tr_kkwnodwyk WHERE kwe_idelemu=kkwnod.kwe_idelemu
   LOOP    
    _knw_idelemu=rec_kkwnodwyk.knw_idelemu;
	_mrpp_idpalety=rec_kkwnodwyk.mrpp_idpalety;
    _rmp_idsposobu=rec_kkwnodwyk.knw_rmp_idsposobu;
	_dmag_ilosc=(rec_kkwnodwyk.knw_iloscwyk*kkwnod.kwe_mnoznikwyrobu_m)/kkwnod.kwe_mnoznikwyrobu_l;
    _dmag_iloscwmag=rec_kkwnodwyk.knw_tomagmag;
    _dmag_iloscwmagclosed=rec_kkwnodwyk.knw_tomagmagclosed;
    _dmag_znacznik=rec_kkwnodwyk.knw_uwagi;
    _dmag_flaga=_dmag_flaga|(1<<2);
	
	INSERT INTO tr_dyspozycjamag
    (
     ttw_idtowaru, ttm_idtowmag, tmg_idmagazynu, dmag_wplywmag,
     kwh_idheadu, kwe_idelemu, knw_idelemu_koop, knw_idelemu,
     mrpp_idpalety, p_idpracownika, zl_idzlecenia,
     dmag_ilosc, dmag_iloscwmag, dmag_iloscwmagclosed, 
     dmag_znacznik, rmp_idsposobu, dmag_typ, dmag_flaga
    )  
    VALUES
    (
     _ttw_idtowaru, _ttm_idtowmag, _tmg_idmagazynu, _dmag_wplywmag,
     _kwh_idheadu, _kwe_idelemu, _knw_idelemu_koop, _knw_idelemu,
     _mrpp_idpalety, _p_idpracownika, _zl_idzlecenia,
     _dmag_ilosc, _dmag_iloscwmag, _dmag_iloscwmagclosed, 
     _dmag_znacznik, _rmp_idsposobu, _dmag_typ, _dmag_flaga
    )
    RETURNING dmag_iddyspozycji INTO dmag;
 
    _dmag_iddyspozycji=dmag.dmag_iddyspozycji;
            
    UPDATE tr_ruchy SET dmag_iddyspozycji=_dmag_iddyspozycji WHERE knw_idelemusrc=_knw_idelemu;
  
    RAISE LOG 'DEBUG: createDyspDlaKKWNodNormal(%,%,%): Sukces O (%<->%)', kkwnod.kwe_idelemu, _p_idpracownika, _isRozmiarowka, _knw_idelemu, _dmag_iddyspozycji;
   END LOOP;
   RAISE LOG 'DEBUG: createDyspDlaKKWNodNormal(%,%,%): Operacja - stop', kkwnod.kwe_idelemu, _p_idpracownika, _isRozmiarowka;
   RETURN 1;
  END IF;
 END IF; 
 
 RETURN -1;
END;
$_$;
