CREATE FUNCTION doskojamortyzacjaex(integer, integer, integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idam ALIAS FOR $1;
 _ile ALIAS FOR $2;
 _typ ALIAS FOR $3;
 r RECORD;
BEGIN

 IF (_idam IS NULL) THEN
  RETURN TRUE;
 END IF;

 IF (_ile<=0) THEN
  UPDATE kh_zapisskoj SET zs_counter=zs_counter+_ile WHERE am_id=_idam AND zs_typ=_typ;
  RETURN TRUE;
 END IF;

 
 FOR r IN SELECT zs_idskoj FROM kh_zapisskoj WHERE am_id=_idam AND zs_typ=_typ
 LOOP
  UPDATE kh_zapisskoj SET zs_counter=zs_counter+_ile WHERE am_id=_idam AND zs_typ=_typ;
  RETURN TRUE;
 END LOOP;
 IF NOT FOUND THEN
  INSERT INTO kh_zapisskoj (am_id,zs_counter,zs_typ) VALUES (_idam,_ile,_typ);
  RETURN TRUE;
 END IF;

 RETURN TRUE;
END;
$_$;
