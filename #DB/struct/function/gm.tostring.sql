CREATE FUNCTION tostring(anyelement, boolean DEFAULT false) RETURNS text
    LANGUAGE sql
    AS $_$
 SELECT (CASE WHEN $2=TRUE THEN quote_nullable($1) ELSE COALESCE($1::text,'NULL') END);
$_$;


--
--

CREATE FUNCTION tostring(text, anyarray, boolean DEFAULT false) RETURNS text
    LANGUAGE plpgsql
    AS $_$
BEGIN
 IF ($2 IS NULL) THEN
  RETURN $1||' IS NULL';
 END IF;

  RETURN $1||' = ANY ('||quote_nullable($2)||')';
END;
$_$;


--
--

CREATE FUNCTION tostring(text, anynonarray, boolean DEFAULT false) RETURNS text
    LANGUAGE plpgsql
    AS $_$
BEGIN
 IF ($2 IS NULL) THEN
  RETURN $1||' IS NULL';
 END IF;

 IF ($3=TRUE) THEN
  RETURN $1||' = '||quote_nullable($2);
 END IF;

 RETURN $1||'='||$2::text;
END;
$_$;
