CREATE FUNCTION obliczwartoscpozmianieilosci(integer, numeric, numeric, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idelem ALIAS FOR $1;
 _iloscf ALIAS FOR $2;
 _wnettowal ALIAS FOR $3;
 _newflaga ALIAS FOR $4;
 r RECORD;
BEGIN
 
 IF ((_newflaga&(1<<23))=0) THEN
  RETURN _wnettowal;
 END IF;


 SELECT te.* INTO r FROM tg_transelem AS te JOIN tg_realizacjapzam AS p ON (te.tel_idelem=p.tel_idelemsrc AND p.rm_powod=4) WHERE p.tel_idpzam=_idelem;
 IF (r.tel_idelem IS NULL) THEN
  RETURN _wnettowal;
 END IF;

 IF ((_iloscf=r.tel_iloscf) OR (_iloscf=0)) THEN
  RETURN r.tel_wnettowal;
 END IF;

 RETURN round(r.tel_wnettowal*_iloscf/r.tel_iloscf,2);
END;
$_$;
