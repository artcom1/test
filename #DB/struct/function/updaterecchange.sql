CREATE FUNCTION updaterecchange(integer, integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN updateRecChange($1,$2,FALSE);
END
$_$;


--
--

CREATE FUNCTION updaterecchange(integer, integer, boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _type ALIAS FOR $1;
 _id ALIAS FOR $2;
 _create ALIAS FOR $3;
 id INT;
BEGIN
 IF (_id IS NULL) THEN
  RETURN TRUE;
 END IF;

 IF (_create) THEN
  id=(SELECT rg_id FROM tg_recchanges WHERE rg_type=_type AND rg_id=_id);
  IF (id IS NULL) THEN
   INSERT INTO tg_recchanges VALUES (_type,_id);
   RETURN TRUE;
  END IF;
 END IF;

 UPDATE tg_recchanges SET rg_date=now() WHERE rg_type=_type AND rg_id=_id AND rg_date<>now();
 
 RETURN TRUE;
END
$_$;
