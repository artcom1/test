CREATE FUNCTION obupewnijkonto(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _konto ALIAS FOR $1;
 _rok   ALIAS FOR $2;
 ret INT;
 retkt INT;
BEGIN

 --Konto najwyzszego rzedu - pomin je po prostu
 IF (_konto IS NULL) THEN
  RETURN NULL;
 END IF;

 ret=(SELECT ob_id FROM kh_obroty WHERE ro_idroku=_rok AND kt_idkonta=_konto);
 IF (ret IS NOT NULL) THEN
  RETURN ret;
 END IF;

 retkt=(SELECT kt_ref FROM kh_konta WHERE ro_idroku=_rok AND kt_idkonta=_konto);
 ret=ObUpewnijKonto(retkt,_rok);

 INSERT INTO kh_obroty (kt_idkonta,ro_idroku,ob_ref,kt_ref) VALUES (_konto,_rok,ret,retkt);

 RETURN currval('kh_obroty_s');
END;
$_$;
