CREATE OR REPLACE FUNCTION 
    LANGUAGE sql IMMUTABLE
    AS $_$
 SELECT (CASE WHEN (($2&(1<<5))=0) OR (($1>>14)&3)=0 THEN FALSE ELSE TRUE END);
$_$;
