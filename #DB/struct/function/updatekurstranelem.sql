CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _oldkurs ALIAS FOR $1;
 _tewaluta ALIAS FOR $2;
 _updwaluta ALIAS FOR $3;
 _idtrans ALIAS FOR $4;
BEGIN
 
 IF (_tewaluta<>_updwaluta) OR (_updwaluta IS NULL) THEN
  RETURN _oldkurs;
 END IF;


 RETURN getKursDlaDokumentu(_idtrans,_updwaluta);
END;
$_$;
