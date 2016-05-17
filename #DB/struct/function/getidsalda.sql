CREATE FUNCTION getidsalda(integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idklienta ALIAS FOR $1;
 _idkonta ALIAS FOR $2;
 _fm_idcentrali ALIAS FOR $3;
 ret INT;
BEGIN
    
 ret=(SELECT sd_idsalda FROM kr_salda WHERE 
      (CASE WHEN _idklienta IS NULL THEN k_idklienta IS NULL ELSE k_idklienta=_idklienta END) AND 
      (CASE WHEN _idkonta IS NULL THEN kt_idkonta IS NULL ELSE kt_idkonta=_idkonta END) AND
      fm_idcentrali=_fm_idcentrali
     );

 IF (ret IS NOT NULL) THEN
  RETURN ret;
 END IF;

 INSERT INTO kr_salda(k_idklienta,kt_idkonta,fm_idcentrali) VALUES (_idklienta,_idkonta,_fm_idcentrali);

 RETURN currval('kr_salda_s');
END;
$_$;
