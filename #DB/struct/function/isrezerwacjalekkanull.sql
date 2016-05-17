CREATE FUNCTION isrezerwacjalekkanull(integer) RETURNS boolean
    LANGUAGE sql
    AS $_$
 SELECT (isRezerwacjaLekka($1) AND (($1&(1<<26))<>0));
$_$;
