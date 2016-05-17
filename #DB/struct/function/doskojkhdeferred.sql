CREATE FUNCTION doskojkhdeferred(integer, boolean, boolean, integer, integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _ile     ALIAS FOR $1;
 _iskh    ALIAS FOR $2;
 _iserror ALIAS FOR $3;
 _idtrans ALIAS FOR $4;
 _idplat  ALIAS FOR $5;
 typ      INT:=5;  --KH
 r RECORD;
 --Uzyte zs_typ: 5,6,7,8
BEGIN

 IF (_idtrans IS NULL AND _idplat IS NULL) THEN
  RAISE EXCEPTION 'Nie podano ani ID dokumentu ani ID platnosci do skojarzenia';
 END IF;

 IF (_idtrans IS NOT NULL AND _idplat IS NOT NULL) THEN
  RAISE EXCEPTION 'Podano i ID dokumentu i ID platnosci do skojarzenia';
 END IF;
  
 IF (_iskh=FALSE) THEN
  typ=7;
 END IF;

 IF (_iserror=TRUE) THEN typ=typ+1; END IF;
 
 IF (_ile<=0) THEN
  UPDATE kh_zapisskoj SET zs_counter=zs_counter+_ile WHERE zs_typ=typ AND tr_idtrans IS NOT DISTINCT FROM _idtrans AND pl_idplatnosc IS NOT DISTINCT FROM _idplat;
  RETURN TRUE;
 END IF;

 
 FOR r IN SELECT zs_idskoj FROM kh_zapisskoj WHERE zs_typ=typ AND tr_idtrans IS NOT DISTINCT FROM _idtrans AND pl_idplatnosc IS NOT DISTINCT FROM _idplat
 LOOP
  UPDATE kh_zapisskoj SET zs_counter=zs_counter+_ile WHERE zs_typ=typ AND tr_idtrans IS NOT DISTINCT FROM _idtrans AND pl_idplatnosc IS NOT DISTINCT FROM _idplat;
  RETURN TRUE;
 END LOOP;
 IF NOT FOUND THEN
  INSERT INTO kh_zapisskoj (zs_counter,zs_typ,tr_idtrans,pl_idplatnosc) VALUES (_ile,typ,_idtrans,_idplat);
  RETURN TRUE;
 END IF;

 RETURN TRUE;
END;
$_$;
