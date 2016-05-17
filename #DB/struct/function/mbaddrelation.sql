CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _aplikacja ALIAS FOR $1;
 _typdanych ALIAS FOR $2;
 _extid ALIAS FOR $3;
 _vid ALIAS FOR $4;
 _oid ALIAS FOR $5;
 _hashcode ALIAS FOR $6;
BEGIN
 
 INSERT INTO tm_mobileids 
               (mb_typaplikacji,mb_datatype,mb_vid,mb_extid,mb_oid,mb_exthashcode) 
	       VALUES
	       (_aplikacja,_typdanych,_vid,_extid,_oid,_hashcode);

 RETURN currval('tm_mobileids_s');
END;
$_$;
