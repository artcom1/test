CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _ilosc ALIAS FOR $1;
 _wartosczakupu ALIAS FOR $2;
 _narzut ALIAS FOR $3;
 w NUMERIC;  
BEGIN
 w=round(round(_wartosczakupu,6)+round(_narzut,6),6);

 return w-floorRound(w);
END;
$_$;
