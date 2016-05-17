CREATE FUNCTION dodaj_wz_wtex_safe(dodaj_wz_type, boolean DEFAULT false) RETURNS dodaj_wz_rettype
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _in       ALIAS FOR $1;
 _dodelete ALIAS FOR $2;

 ret gm.DODAJ_WZ_RETTYPE;
BEGIN

 _in._isteex=COALESCE(_in._isteex,0);

 PERFORM gm.disableTouch(1);

 ret=gm.dodaj_wz_wtex(_in,_dodelete);

 PERFORM gm.disableTouch(-1);

 RETURN ret;
END; 
$_$;
