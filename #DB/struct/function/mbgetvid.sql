CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _aplikacja ALIAS FOR $1;
 _typdanych ALIAS FOR $2;
 _extid ALIAS FOR $3;
 _hashcode ALIAS FOR $4;
BEGIN
 RETURN (SELECT mb_vid FROM tm_mobileids WHERE mb_typaplikacji=_aplikacja AND 
                                               mb_datatype=_typdanych AND 
					       mb_extid=_extid AND
					       mb_exthashcode=_hashcode
					       );
END;
$_$;
