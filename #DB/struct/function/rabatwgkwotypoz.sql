CREATE FUNCTION rabatwgkwotypoz(integer, numeric, numeric) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _tel_idelem ALIAS FOR $1;
 _rabat ALIAS FOR $2;
 _rabatbtr ALIAS FOR $3;
 id_rabatu INT;
BEGIN
 id_rabatu=(SELECT ur_idrabatu FROM tg_udzielonerabaty WHERE tel_idelem=_tel_idelem LIMIT 1 OFFSET 0);

 IF (id_rabatu>0) THEN
    UPDATE tg_udzielonerabaty SET ur_rabat=_rabat, ur_rabatbtr=_rabatbtr  WHERE ur_idrabatu=id_rabatu;
 ELSE
    INSERT INTO tg_udzielonerabaty (tel_idelem, ur_rabat, ur_rabatbtr) VALUES (_tel_idelem,_rabat,_rabatbtr);
 END IF;
 return 1;
END;
$_$;
