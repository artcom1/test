CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idcentrali ALIAS FOR $1;
 _prefix     ALIAS FOR $2;
 _numer      ALIAS FOR $3;
 _zerosto    ALIAS FOR $4;
 t           TEXT;
 ret         INT;
BEGIN
 t=sortkonta(numerkonta(_prefix,_numer,_zerosto), 8);

 ret=(SELECT ktn_idkonta FROM kh_kontanorm WHERE fm_idcentrali=_idcentrali AND ktn_nrkonta=t);
 IF (ret IS NOT NULL) THEN
  RETURN ret;
 END IF;

 ret=nextval('kh_konta_s');
 INSERT INTO kh_kontanorm (ktn_idkonta,fm_idcentrali,ktn_nrkonta) VALUES (ret,_idcentrali,t);

 RETURN ret;
END;
$_$;
