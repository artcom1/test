CREATE FUNCTION tolog(txt text, dtype integer, id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
 idpracownika INT;
BEGIN
 idpracownika=vendo.getIDPracownika();
 IF (idpracownika IS NULL) OR (dtype IS NULL) OR (id IS NULL) THEN
  RETURN NULL;
 END IF;

 INSERT INTO tg_log
  (lg_ref,lg_typeref,lg_txt,lg_uid) 
 VALUES 
 (id,dtype,txt,idpracownika);
 
 RETURN currval('tg_log_s');
END;
$$;


--
--

CREATE FUNCTION tolog(txt text, dtype text, id integer) RETURNS integer
    LANGUAGE sql
    AS $_$
 SELECT vendo.toLog($1,vendo.getTableType($2),$3);
$_$;


SET search_path = public, pg_catalog;
