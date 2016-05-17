CREATE FUNCTION createdyspdlaruchy(tr_ruchy, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 ruch           ALIAS FOR $1;
 _dmag_typ      ALIAS FOR $2;
 _tel_idelem    ALIAS FOR $3;
 
 rec_transelem RECORD;
 rec_kkw       RECORD;
 
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
 _p_idpracownika   INT;
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
 IF (_dmag_typ=3) THEN 
  RAISE LOG 'DEBUG: createDyspDlaRuchy(%,%,%): Warunek I', ruch.kwc_idruchu, _dmag_typ, _tel_idelem;
  RETURN 0;
 END IF;
 
 IF (COALESCE(ruch.dmag_iddyspozycji,0)>0) THEN
  RAISE LOG 'DEBUG: createDyspDlaRuchy(%,%,%): Warunek II (%)', ruch.kwc_idruchu, _dmag_typ, _tel_idelem, ruch.dmag_iddyspozycji;
  RETURN 0;
 END IF;
 
 _knr_idelemu      = ruch.knr_idelemudst;
 _knr_idelemu_idx  = ruch.knr_idelemu_idx;
 _kwe_idelemu      = ruch.kwe_idelemusrc;
-- _knw_idelemu_koop INT;
 _knw_idelemu      = ruch.knw_idelemusrc;
 _p_idpracownika   = ruch.p_idpracownika;
   
 _dmag_ilosc           = ruch.kwc_ilosc;
 _dmag_iloscwmag       = ruch.kwc_ilosc;
 _dmag_iloscwmagclosed = (CASE WHEN ruch.kwc_flaga&(1<<4)=(1<<4) THEN ruch.kwc_ilosc ELSE 0 END);
 
 _dmag_znacznik = ruch.kwc_znacznik;
 _dmag_wplywmag = (CASE WHEN _dmag_typ=1 THEN -1 WHEN _dmag_typ=2 THEN 1 WHEN _dmag_typ=3 THEN 1 WHEN _dmag_typ=4 THEN 0 ELSE -2 END);
  
 _dmag_flaga=_dmag_flaga|(ruch.kwc_flaga&(3<<0));
  
 IF (_tel_idelem IS NOT NULL) THEN 
  SELECT towmag.ttm_idtowmag, towmag.ttw_idtowaru, towmag.tmg_idmagazynu, tel.prt_idpartii INTO rec_transelem 
  FROM tg_transelem AS tel
  JOIN tg_towmag AS towmag USING (ttm_idtowmag)
  WHERE tel_idelem=_tel_idelem;
  
  _ttm_idtowmag=rec_transelem.ttm_idtowmag;
  _ttw_idtowaru=rec_transelem.ttw_idtowaru;
  _tmg_idmagazynu=rec_transelem.tmg_idmagazynu;
  
  IF (_dmag_wplywmag=1) THEN _prt_idpartiipz=rec_transelem.prt_idpartii; END IF;
  IF (_dmag_wplywmag=-1) THEN _prt_idpartiiwz=rec_transelem.prt_idpartii; END IF;
 END IF;
 
 IF (_knw_idelemu IS NOT NULL) THEN 
  SELECT mrpp_idpalety, knw_rmp_idsposobu, kwh_idheadu INTO rec_kkw FROM tr_kkwnodwyk WHERE knw_idelemu=_knw_idelemu;
  _mrpp_idpalety=rec_kkw.mrpp_idpalety;
  _rmp_idsposobu=rec_kkw.knw_rmp_idsposobu;
  _kwh_idheadu=rec_kkw.kwh_idheadu;
 ELSE
  SELECT kwh_idheadu INTO rec_kkw FROM tr_nodrec WHERE knr_idelemu=_knr_idelemu;
  _kwh_idheadu=rec_kkw.kwh_idheadu;
 END IF;
 
 _zl_idzlecenia=(SELECT zl_idzlecenia FROM tg_planzlecenia WHERE pz_idplanu IN (SELECT pz_idplanu FROM tr_powiazanieplanprzychod WHERE knr_idelemu=_knr_idelemu) LIMIT 1);
 IF (COALESCE(_zl_idzlecenia,0)<=0) THEN
  _zl_idzlecenia=(SELECT zl_idzlecenia FROM tr_kkwhead WHERE kwh_idheadu=_kwh_idheadu LIMIT 1);
 END IF;
  
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
    
 UPDATE tr_ruchy SET dmag_iddyspozycji=_dmag_iddyspozycji WHERE kwc_idruchu=ruch.kwc_idruchu;
   
 RAISE LOG 'DEBUG: createDyspDlaRuchy(%,%,%): Sukces (%<->%)', ruch.kwc_idruchu, _dmag_typ, _tel_idelem, ruch.kwc_idruchu, _dmag_iddyspozycji;
  
 RETURN _dmag_iddyspozycji;
END;
$_$;
