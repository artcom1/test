CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idelem ALIAS FOR $1;
 _idtowmag ALIAS FOR $2;
BEGIN
 
 --Wyczysc rezerwacje
 PERFORM gm.clear_rezerwacje(_idelem,_idtowmag);

 RETURN gm.clearBackOrder(_idelem);
END;
$_$;


SET search_path = public, pg_catalog;
