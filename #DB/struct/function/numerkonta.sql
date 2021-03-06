CREATE OR REPLACE FUNCTION 
    LANGUAGE sql IMMUTABLE
    AS $_$
SELECT numerKonta($1,$2::text);
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 IF ($1='') THEN
  RETURN $2;
 ELSE
  RETURN $1||'-'||$2;
 END IF;
 END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE sql IMMUTABLE
    AS $_$
 SELECT numerKonta($1,$2::text,$3);
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 IF ($1='') THEN
  RETURN mylpad($2::text,($3&240)>>4,'0');
 ELSE
  IF (($3&(1<<9))!=0) THEN
   RETURN $1||'-'||upper($2);
  END IF;
  RETURN $1||'-'||mylpad($2,max(2,($3&240)>>4)::int,'0');
 END IF;

END;
 $_$;
