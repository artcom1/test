CREATE FUNCTION nullzero(smallint) RETURNS smallint
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 IF ($1=NULL) THEN
  RETURN 0;
 END IF;

 RETURN $1;
END;$_$;


--
--

CREATE FUNCTION nullzero(bigint) RETURNS bigint
    LANGUAGE sql
    AS $_$
 SELECT COALESCE($1,0::bigint);
$_$;


--
--

CREATE FUNCTION nullzero(mpq) RETURNS mpq
    LANGUAGE sql
    AS $_$
 SELECT COALESCE($1,0::mpq);
$_$;
