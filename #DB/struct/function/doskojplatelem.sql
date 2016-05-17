CREATE FUNCTION doskojplatelem(integer, integer, integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idplatelem ALIAS FOR $1;
 _ile ALIAS FOR $2;
 _ileext ALIAS FOR $3;
 r RECORD;
BEGIN

 IF (_idplatelem=NULL) THEN
  RETURN TRUE;
 END IF;

 IF (_ile<=0) AND (_ileext<=0) THEN
  UPDATE kh_zapisskoj SET zs_counter=zs_counter+_ile,zs_counterext=zs_counterext+_ileext WHERE pp_idplatelem=_idplatelem;
  RETURN TRUE;
 END IF;

 
 FOR r IN SELECT zs_idskoj FROM kh_zapisskoj WHERE pp_idplatelem=_idplatelem
 LOOP
  UPDATE kh_zapisskoj SET zs_counter=zs_counter+_ile,zs_counterext=zs_counterext+_ileext WHERE pp_idplatelem=_idplatelem;
  RETURN TRUE;
 END LOOP;
 IF NOT FOUND THEN
  INSERT INTO kh_zapisskoj (pp_idplatelem,zs_counter,zs_counterext) VALUES (_idplatelem,_ile,_ileext);
  RETURN TRUE;
 END IF;

 RETURN TRUE;
END;
$_$;
