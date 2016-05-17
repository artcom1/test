CREATE FUNCTION doskojplatnosci(integer, integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN doSkojPlatnosci($1,$2,0);
END;
$_$;


--
--

CREATE FUNCTION doskojplatnosci(integer, integer, integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN doSkojPlatnosci($1,$2,$3,0);
END;
$_$;


--
--

CREATE FUNCTION doskojplatnosci(integer, integer, integer, integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idplatnosc ALIAS FOR $1;
 _ile        ALIAS FOR $2;
 _ileext     ALIAS FOR $3;
 _typ        ALIAS FOR $4;
 r RECORD;
BEGIN

 IF (_idplatnosc=NULL) THEN
  RETURN TRUE;
 END IF;

 IF (_ile<=0) AND (_ileext<=0) THEN
  UPDATE kh_zapisskoj SET zs_counter=zs_counter+_ile,zs_counterext=zs_counterext+_ileext WHERE pl_idplatnosc=_idplatnosc AND zs_typ=_typ;
  RETURN TRUE;
 END IF;

 
 FOR r IN SELECT zs_idskoj FROM kh_zapisskoj WHERE pl_idplatnosc=_idplatnosc AND zs_typ=_typ
 LOOP
  UPDATE kh_zapisskoj SET zs_counter=zs_counter+_ile,zs_counterext=zs_counterext+_ileext WHERE pl_idplatnosc=_idplatnosc AND zs_typ=_typ;
  RETURN TRUE;
 END LOOP;
 IF NOT FOUND THEN
  INSERT INTO kh_zapisskoj (pl_idplatnosc,zs_counter,zs_counterext,zs_typ) VALUES (_idplatnosc,_ile,_ileext,_typ);
  RETURN TRUE;
 END IF;

 RETURN TRUE;
END;
$_$;
