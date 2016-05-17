CREATE FUNCTION isrezerwacjanull(integer) RETURNS boolean
    LANGUAGE sql
    AS $_$
 SELECT (isRezerwacja($1) AND (($1&(1<<26))<>0));
$_$;
