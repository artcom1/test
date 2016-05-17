CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
BEGIN
 UPDATE tg_ceny SET tcn_valuebrt=round(Net2Brt(tcn_value,$2),tcn_dokladnosc) WHERE ttw_idtowaru=$1;
 RETURN TRUE;
END;
$_$;
