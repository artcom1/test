CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtowaru ALIAS FOR $1;
 _idkraju ALIAS FOR $2;
 ret INT;
BEGIN
 ret=getSpecialVat(_idtowaru,_idkraju);
 IF (ret IS NULL) THEN
  RAISE EXCEPTION '13|%:%|Brak VAT dla towaru/kraju ',_idtowaru,_idkraju;
 END IF;

 ret=(SELECT ttv_vat FROM tg_vaty WHERE ttv_idvatu=ret);
 
 RETURN ret;
END
$_$;
