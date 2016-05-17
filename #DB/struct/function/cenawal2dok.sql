CREATE FUNCTION cenawal2dok(_cenawal numeric, _kurswal mpq, _kursdok mpq, _dokladnosc integer) RETURNS numeric
    LANGUAGE sql IMMUTABLE
    AS $_$
SELECT (CASE WHEN $2=$3 THEN round($1,_dokladnosc) ELSE round($1*$2/$3,_dokladnosc) END);
$_$;
