CREATE FUNCTION powiazaniedokzeswiadectwem(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idelem ALIAS FOR $1;
 _idswiad ALIAS FOR $2;
 tmp INT;
BEGIN
 
 tmp=(SELECT sr_idruchu FROM tg_swiadruchy WHERE tel_idelem=_idelem AND sw_idswiadectwa=_idswiad);
 IF (tmp>0) THEN
  return 1;
 END IF;

 INSERT INTO tg_swiadruchy (tel_idelem,sw_idswiadectwa,sr_ilosc) SELECT tel_idelem, _idswiad, tel_iloscf FROM tg_transelem WHERE tel_idelem=_idelem;

 RETURN 1;
END;
$_$;
