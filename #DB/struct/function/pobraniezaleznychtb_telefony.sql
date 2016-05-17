CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _ph_datatype ALIAS FOR $1;
 _ph_id       ALIAS FOR $2;
 _flaga       ALIAS FOR $3;
 _mask        ALIAS FOR $4;
 _ph_type     ALIAS FOR $5;
 wynik        TEXT:='';
 r            RECORD;
BEGIN

 FOR r IN SELECT ph_phone FROM tb_telefony WHERE ph_datatype=_ph_datatype AND ph_id=_ph_id AND (ph_flaga&_mask)=_flaga AND ph_type=_ph_type
 LOOP
  wynik=wynik||','||r.ph_phone;
 END LOOP;


 RETURN substring(wynik,2);
END
$_$;
