CREATE OR REPLACE FUNCTION 
    LANGUAGE sql
    AS $_$
SELECT calcKurs($1,$2,(SELECT wl_podstawadefault FROM tg_waluty WHERE wl_idwaluty=$3));
$_$;
