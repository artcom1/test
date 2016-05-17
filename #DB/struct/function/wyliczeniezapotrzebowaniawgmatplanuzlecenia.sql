CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _zlecenie    ALIAS FOR $1; ---int
 _idplanu     ALIAS FOR $2; ---int
 _idmaterialu ALIAS FOR $3; ---int
 _data         ALIAS FOR $4; ---data
 _iloscplanu     ALIAS FOR $5; ---numeric
 _wymiar_x       ALIAS FOR $6; ---numeric
 _wymiar_y       ALIAS FOR $7; ---numeric
 _wymiar_z       ALIAS FOR $8; ---numeric
 _nadmiar_x      ALIAS FOR $9; ---numeric
 _nadmiar_y      ALIAS FOR $10; ---numeric
 _nadmiar_z      ALIAS FOR $11; ---numeric
 _narzut         ALIAS FOR $12; ---numeric

 iloscmat        NUMERIC:=0;
BEGIN

 IF (_iloscplanu=0) THEN ---ilosc jest zero wiec zerujemy backorder
  RETURN dodajbackorderzplanu(_idplanu,_idmaterialu,0,FALSE,_data,_zlecenie,6);
 END IF;
 
 iloscmat=getiloscmatplanuzlecenia(_idmaterialu, _iloscplanu, _wymiar_x, _wymiar_y, _wymiar_z, _nadmiar_x, _nadmiar_y, _nadmiar_z, _narzut);

 IF (iloscmat=0) THEN
  RETURN 0;
 END IF;
 
 ---dodajemy backorder
 RETURN dodajbackorderzplanu(_idplanu,_idmaterialu,iloscmat,FALSE,_data,_zlecenie,6);
END;
$_$;
