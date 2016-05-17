CREATE FUNCTION totrzamknietaflaga(integer, numeric) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _flaga ALIAS FOR $1;
 _pozycjioo ALIAS FOR $2;
 ret int:=0;
BEGIN
 
 ret=_flaga;

 IF (_pozycjioo>0) THEN
  ret=ret|(1<<27);
 ELSE
  ret=ret&(~(1<<27));
 END IF;

 RETURN ret;
END;
$_$;
