CREATE FUNCTION createdyspdlakkwnodrozmiarowka(tr_kkwnod, integer, boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 kkwnod          ALIAS FOR $1;
 _p_idpracownika ALIAS FOR $2;
 _isRozmiarowka  ALIAS FOR $3;
 
 rec_kkwnodwyk RECORD;
 rec_kkw       RECORD;
 
 _dmag_iddyspozycji   INT;
 _dmag_iddyspozycji_p INT;
 dmag                 RECORD;
  
 _kwh_idheadu    INT;
 _kwe_idelemu    INT;
 _dmag_typ       INT;
 _dmag_wplywmag  INT;
 
 _ttw_idtowaru   INT;
 _ttm_idtowmag   INT;
 _tmg_idmagazynu INT;
 _zl_idzlecenia  INT;
 _zl_idzlecenia_kkw INT;
   
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
 IF (_isRozmiarowka=FALSE) THEN
  RAISE LOG 'DEBUG: createDyspDlaKKWNodRozmiarowka(%,%,%): Warunek I', kkwnod.kwe_idelemu, _p_idpracownika, _isRozmiarowka;
  RETURN 0;
 END IF;
 
 IF ((kkwnod.the_flaga&(1<<0))=0 OR kkwnod.kwe_iloscwyk=0) THEN
  RAISE LOG 'DEBUG: createDyspDlaKKWNodRozmiarowka(%,%,%): Warunek II (%,%)', kkwnod.kwe_idelemu, _p_idpracownika, _isRozmiarowka, kkwnod.the_flaga, kkwnod.kwe_iloscwyk;
  RETURN 0;
 END IF;
  
 IF ((kkwnod.the_flaga&(1<<12))=0) THEN -- Zle ustawienie kkwnoda  
  RAISE LOG 'DEBUG: createDyspDlaKKWNodRozmiarowka(%,%,%): Warunek III (%)', kkwnod.kwe_idelemu, _p_idpracownika, _isRozmiarowka, kkwnod.the_flaga;
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
  _zl_idzlecenia_kkw=rec_kkw.zl_idzlecenia;  
 END IF;
 
 IF (kkwnod.kwe_nodtype=0) THEN -- KKWNWT_NORMALNOD
  RAISE LOG 'DEBUG: createDyspDlaKKWNodRozmiarowka(%,%,%): Operacja - start', kkwnod.kwe_idelemu, _p_idpracownika, _isRozmiarowka;
  FOR rec_kkwnodwyk IN
  SELECT b.*, pz.zl_idzlecenia
  FROM
  (
   SELECT 
   0 AS typ, 
   NULL AS kwc_idruchu,
   knw_idelemu, mrpp_idpalety, ttw_idtowaru, knw_uwagi, knw_iloscwyk, knw_tomagmag, knw_tomagmagclosed, knw_iloscopakrozm, knw_rmp_idsposobu, knw_kwhr_idelemu 
   FROM tr_kkwnodwyk AS knw
   JOIN tr_kkwhead AS kwh USING (kwh_idheadu)
   LEFT JOIN tr_ruchy AS r ON (r.knw_idelemusrc=knw.knw_idelemu)
   WHERE knw_idelemu=kkwnod.kwe_idelemu AND r.knw_idelemusrc IS NULL
   UNION
   SELECT
   1 AS typ,
   r.kwc_idruchu,
   knw_idelemu, mrpp_idpalety, a.ttw_idtowaru, knw_uwagi,
   round(knw_iloscwykrozm*knw_iloscopakrozm,0) AS knw_iloscwyk,
   round(knw_iloscwykrozm*knw_iloscopakrozm*mnoznik,4) AS knw_tomagmag,
   round(knw_iloscwykrozm*knw_iloscopakrozm*mnoznikc,4) AS knw_tomagmagclosed,
   knw_iloscopakrozm, knw_rmp_idsposobu, knw_kwhr_idelemu 
   FROM
   (
    SELECT 
    knw_idelemu, knw_iloscwyk, knw_uwagi, mrpp_idpalety, knw_iloscopakrozm, knw_rmp_idsposobu, knw_kwhr_idelemu,
    UNNEST(array_normalize(kwh_towary, knw_iloscwykrozm)) AS knw_iloscwykrozm,
    knw_tomagmag/(array_sum(array_normalize(kwh_towary, knw_iloscwykrozm))* knw_iloscopakrozm) AS mnoznik, 
    knw_tomagmagclosed/(array_sum(array_normalize(kwh_towary, knw_iloscwykrozm))* knw_iloscopakrozm) AS mnoznikc, 
    UNNEST(kwh_towary) AS ttw_idtowaru
    FROM tr_kkwnodwyk AS knw
    JOIN tr_kkwhead AS kwh USING (kwh_idheadu)
    WHERE knw_idelemu=kkwnod.kwe_idelemu
   ) AS a
   LEFT JOIN tr_ruchy AS r ON (r.knw_idelemusrc=a.knw_idelemu)  
   WHERE a.knw_iloscwykrozm>0 AND r.knw_idelemusrc IS NULL
  )
  AS b
  LEFT JOIN tr_kkwheadrozm AS kwhr ON (knw_kwhr_idelemu=kwhr_idelemu)
  LEFT JOIN tg_planzlecenia AS pz ON (kwhr_pz_idplanu=pz_idplanu)
  ORDER BY typ ASC, kwc_idruchu ASC  
  LOOP    
  
   _knw_idelemu=rec_kkwnodwyk.knw_idelemu;
   _mrpp_idpalety=rec_kkwnodwyk.mrpp_idpalety;
   _rmp_idsposobu=rec_kkwnodwyk.knw_rmp_idsposobu;
   _dmag_ilosc=(rec_kkwnodwyk.knw_iloscwyk*kkwnod.kwe_mnoznikwyrobu_m)/kkwnod.kwe_mnoznikwyrobu_l;
   _dmag_iloscwmag=rec_kkwnodwyk.knw_tomagmag;
   _dmag_iloscwmagclosed=rec_kkwnodwyk.knw_tomagmagclosed;
   _dmag_znacznik=rec_kkwnodwyk.knw_uwagi;
   _zl_idzlecenia=rec_kkwnodwyk.zl_idzlecenia;
   
   IF (rec_kkwnodwyk.typ=0) THEN
    _dmag_flaga=_dmag_flaga|(1<<7);
   END IF;
   
   _dmag_flaga=_dmag_flaga|(1<<2);
   
   INSERT INTO tr_dyspozycjamag
   (
    ttw_idtowaru, ttm_idtowmag, tmg_idmagazynu, dmag_wplywmag,
    kwh_idheadu, kwe_idelemu, knw_idelemu_koop, knw_idelemu,
    mrpp_idpalety, p_idpracownika, zl_idzlecenia, dmag_idparent,
    dmag_ilosc, dmag_iloscwmag, dmag_iloscwmagclosed, 
    dmag_znacznik, rmp_idsposobu, dmag_typ, dmag_flaga
   )  
   VALUES
   (
    _ttw_idtowaru, _ttm_idtowmag, _tmg_idmagazynu, _dmag_wplywmag,
    _kwh_idheadu, _kwe_idelemu, _knw_idelemu_koop, _knw_idelemu,
    _mrpp_idpalety, _p_idpracownika, COALESCE(_zl_idzlecenia,_zl_idzlecenia_kkw), _dmag_iddyspozycji_p,
    _dmag_ilosc, _dmag_iloscwmag, _dmag_iloscwmagclosed, 
    _dmag_znacznik, _rmp_idsposobu, _dmag_typ, _dmag_flaga
   )
   RETURNING dmag_iddyspozycji INTO dmag; 
  
   _dmag_iddyspozycji=dmag.dmag_iddyspozycji;
   
   IF (rec_kkwnodwyk.typ=0) THEN
    _dmag_iddyspozycji_p=_dmag_iddyspozycji|(1<<7);
   END IF;
   
   RAISE LOG 'DEBUG: createDyspDlaKKWNodRozmiarowka(%,%,%): Sukces O (%<->%)', kkwnod.kwe_idelemu, _p_idpracownika, _isRozmiarowka, _knw_idelemu, _dmag_iddyspozycji;
  END LOOP;
  RAISE LOG 'DEBUG: createDyspDlaKKWNodRozmiarowka(%,%,%): Operacja - stop', kkwnod.kwe_idelemu, _p_idpracownika, _isRozmiarowka;
  RETURN 1;
 END IF;
  
 RETURN -1;
END;
$_$;
