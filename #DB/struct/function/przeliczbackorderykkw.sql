CREATE FUNCTION przeliczbackorderykkw(tr_kkwhead) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _kkwhead ALIAS FOR $1;
 
 _ttm_idtowmag INT;
 _data         DATE:=now();
 
BEGIN
 
 _ttm_idtowmag = (SELECT ttm_idtowmag FROM tg_towmag WHERE ttw_idtowaru=_kkwhead.ttw_idtowaru AND tmg_idmagazynu=_kkwhead.tmg_idmagazynu_def);
 _data = COALESCE(_kkwhead.kwh_dataplanstop,_kkwhead.kwh_datazak)::DATE;
 
 IF ((_kkwhead.kwh_flaga&3)<>0) THEN
  ---KKW zamkniete, kasujemy backordery
  PERFORM dodajBackOrderKKW(_kkwhead.kwh_idheadu,_ttm_idtowmag,0,4,_data,_kkwhead.zl_idzlecenia,_kkwhead.kwh_towary,_kkwhead.tmg_idmagazynu_def);
  RETURN -_kkwhead.kwh_idheadu;
 END IF; 
  
 PERFORM dodajBackOrderKKW(_kkwhead.kwh_idheadu,_ttm_idtowmag,max(0,_kkwhead.kwh_iloscoczek-_kkwhead.kwh_iloscwmag),4,_data,_kkwhead.zl_idzlecenia,_kkwhead.kwh_towary,_kkwhead.tmg_idmagazynu_def); 
  
 RETURN _kkwhead.kwh_idheadu;
END;
$_$;
