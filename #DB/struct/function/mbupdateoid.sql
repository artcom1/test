CREATE FUNCTION mbupdateoid(integer, integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _aplikacja ALIAS FOR $1;
 _typdanych ALIAS FOR $2;
BEGIN

 IF (_typdanych=8) THEN --TG_TRANSAKCJE
  UPDATE tm_mobileids 
   SET mb_oid=(SELECT oid FROM tg_transakcje AS tr WHERE tr.tr_idtrans=tm_mobileids.mb_vid) 
   WHERE mb_typaplikacji=_aplikacja AND
         mb_datatype=_typdanych AND
	 mb_oid<>(SELECT oid FROM tg_transakcje AS tr WHERE tr.tr_idtrans=tm_mobileids.mb_vid);
 END IF;
 
 RETURN TRUE;
END;
 $_$;
