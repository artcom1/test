CREATE OR REPLACE FUNCTION 
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
