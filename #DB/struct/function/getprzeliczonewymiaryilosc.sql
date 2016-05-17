CREATE FUNCTION getprzeliczonewymiaryilosc(integer, mpq, boolean) RETURNS record
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _ttw_idtowaru    ALIAS FOR $1;
 _ilosc           ALIAS FOR $2;
 _przeliczacIlosc ALIAS FOR $3;
 rec              RECORD;
 ret              RECORD;
 _configValue     TEXT;
 
 _wymiar         NUMERIC:=0;
 
 _iloscprzel     NUMERIC:=0;
 _narzut_procent NUMERIC:=0;
 _wymiar_x       NUMERIC:=0;
 _wymiar_y       NUMERIC:=0;
 _wymiar_z       NUMERIC:=0;
BEGIN
 rec=getPrzeliczanieTowaru(_ttw_idtowaru);
 
 IF (rec IS NOT NULL) THEN
  IF (rec.typprzeliczenia=0) THEN -- Nie mam przelicznika! Wychodze
  SELECT 
  _iloscprzel AS iloscprzel,
  _narzut_procent AS narzut_procent,
  _wymiar_x AS wymiar_x,
  _wymiar_y AS wymiar_y,
  _wymiar_z AS wymiar_z
  INTO ret;
  RETURN ret;
  END IF;
 
  IF (_przeliczacIlosc) THEN
   IF (rec.typprzeliczenia=1) THEN 
    _iloscprzel=(rec.mb*_ilosc)::NUMERIC;
   ELSIF (rec.typprzeliczenia=2) THEN 
    _iloscprzel=(rec.m2*_ilosc)::NUMERIC;
   ELSIF (rec.typprzeliczenia=3) THEN 	
    _configValue=vendo.getconfigvalue('towar_jedn_obj_dzielnik');
    IF (COALESCE(_configValue,'')='') THEN
     _configValue='1';
    END IF;	 
    _iloscprzel=(rec.m3*_ilosc)::NUMERIC;
    _iloscprzel=_iloscprzel*_configValue::NUMERIC;
   ELSE
    _iloscprzel=(rec.kg*_ilosc)::NUMERIC;
   END IF;
   _wymiar=_iloscprzel*1000;
  END IF;
	
  IF (rec.wymiary=FALSE) THEN
   SELECT 
   _iloscprzel AS iloscprzel,
   _narzut_procent AS narzut_procent,
   _wymiar_x AS wymiar_x,
   _wymiar_y AS wymiar_y,
   _wymiar_z AS wymiar_z
   INTO ret;
   RETURN ret;
  END IF; 
 
  IF (rec.typprzeliczenia=1) THEN -- MB
  -----------------------------------------------------------------------------------
   _configValue=vendo.getconfigvalue('struktura_licz_mb');
   IF (_configValue='2') THEN -- Z
    _wymiar_z=_wymiar;	
   ELSIF (_configValue='1') THEN -- Y
    _wymiar_y=_wymiar;
   ELSE -- X
    _wymiar_x=_wymiar;
   END IF;
  -----------------------------------------------------------------------------------
  ELSIF (rec.typprzeliczenia=2) THEN -- M2
  -----------------------------------------------------------------------------------
   _configValue=vendo.getconfigvalue('struktura_licz_pow');
   IF (_configValue='2') THEN -- XZ
    _wymiar_x=_wymiar;
    _wymiar_z=1000;
   ELSIF (_configValue='1') THEN -- YZ
    _wymiar_y=_wymiar;
    _wymiar_z=1000;
   ELSE -- XY
    _wymiar_x=_wymiar;
    _wymiar_y=1000;
   END IF;
  -----------------------------------------------------------------------------------
  ELSIF (rec.typprzeliczenia=3) THEN -- M3
  -----------------------------------------------------------------------------------
   _wymiar_x=_wymiar;
   _wymiar_y=1000;
   _wymiar_z=1000;
  -----------------------------------------------------------------------------------
  ELSE -- KG	
   _wymiar_x=0;
   _wymiar_y=0;
   _wymiar_z=0;
  -----------------------------------------------------------------------------------
  END IF;
 
 END IF; -- IF (rec IS NOT NULL) THEN
 
 SELECT 
 _iloscprzel AS iloscprzel,
 _narzut_procent AS narzut_procent,
 _wymiar_x AS wymiar_x,
 _wymiar_y AS wymiar_y,
 _wymiar_z AS wymiar_z
 INTO ret;
 RETURN ret;
END;
$_$;
