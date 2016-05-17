CREATE FUNCTION tehasprocentodliczeniavat(tel_newflaga integer, tel_new2flaga integer) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
 SELECT (CASE WHEN (($2&(1<<5))=0) OR (($1>>14)&3)=0 THEN FALSE ELSE TRUE END);
$_$;
