CREATE FUNCTION calckurswaluty(licznik numeric, mianownik numeric, idwaluty integer) RETURNS mpq
    LANGUAGE sql
    AS $_$
SELECT calcKurs($1,$2,(SELECT wl_podstawadefault FROM tg_waluty WHERE wl_idwaluty=$3));
$_$;
