CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idelem ALIAS FOR $1;
 _ilosc ALIAS FOR $2;
 _nadmiar ALIAS FOR $3;
BEGIN

 UPDATE tg_realizacjapzam SET rm_iloscf=_ilosc,rm_iloscfnadmiar=_nadmiar WHERE (tel_idelemsrc=_idelem) AND (rm_flaga&8<>0) AND ((rm_iloscf<>_ilosc) OR (rm_iloscfnadmiar!=_nadmiar));

 RETURN NULL;
END;
$_$;
