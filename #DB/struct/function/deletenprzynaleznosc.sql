CREATE FUNCTION deletenprzynaleznosc(integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idref    ALIAS FOR $1;
 _type     ALIAS FOR $2;
 _rodzaj   ALIAS FOR $3;

BEGIN
 DELETE FROM tm_przynaleznosci WHERE mp_idref=_idref AND mp_type=_type AND mp_rodzaj=_rodzaj;

 RETURN 1;
END;
$_$;
