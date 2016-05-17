CREATE FUNCTION getinoutmethod(integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _idtowaru ALIAS FOR $1;
BEGIN 
 RETURN COALESCE((SELECT ttw_inoutmethod FROM tg_towary WHERE ttw_idtowaru=_idtowaru),0);
END;
$_$;
