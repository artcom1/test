CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _knw_idelem    ALIAS FOR $1;
 _normatyw      ALIAS FOR $2;
 _normatyw_all  ALIAS FOR $3;
 
 _knw_zaangazpracownika NUMERIC:=0;
BEGIN

 IF (_normatyw_all>0) THEN
  _knw_zaangazpracownika=(_normatyw/_normatyw_all)*100;
 END IF;
 
 UPDATE tr_kkwnodwyk SET knw_zaangazpracwykonanie=_knw_zaangazpracownika, knw_flaga=knw_flaga|(1<<8) WHERE knw_idelemu=_knw_idelem;
 
 RETURN TRUE;
END
$_$;
