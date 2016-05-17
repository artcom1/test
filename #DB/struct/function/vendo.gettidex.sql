CREATE FUNCTION gettidex(integer, integer, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
 SELECT mylpad(vendo.number_to_base($3,35),2,'0')||mylpad(vendo.number_to_base($1,35),2,'0')||':'||vendo.number_to_base($2,35);
$_$;
