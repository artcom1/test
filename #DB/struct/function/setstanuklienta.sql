CREATE FUNCTION setstanuklienta(integer, integer, numeric) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idklienta ALIAS FOR $1;
 _idtowaru ALIAS FOR $2;
 _stan ALIAS FOR $3;
 id INT;
BEGIN

 IF (_idtowaru IS NULL) THEN
  RETURN NULL;
 END IF;

 id=(SELECT so_idstanu FROM tg_stanyother WHERE k_idklienta=_idklienta AND ttw_idtowaru=_idtowaru);
 IF (id IS NOT NULL) THEN
  UPDATE tg_stanyother SET so_stan=_stan,so_data=now() WHERE so_idstanu=id;
 ELSE
  INSERT INTO tg_stanyother
   (k_idklienta,ttw_idtowaru,so_stan)
  VALUES
   (_idklienta,_idtowaru,_stan);
  id=currval('tg_stanyother_s');
 END IF;

 RETURN id;
END;
$_$;
