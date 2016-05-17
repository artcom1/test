CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 numerwol INT:=1;
 numer INT:=1;
BEGIN

 SELECT 1 INTO numer 
 FROM tg_rodzajtransakcji 
 WHERE tr_rodzaj=_rodzaj AND 
       trt_ostseria=_seria 
 FOR UPDATE;

 SELECT nullZero((tr_numer))+1 INTO numer 
 FROM tg_transakcje 
 WHERE tr_numer IS NOT NULL AND 
       fm_idcentrali=_centrala AND 
	   tr_rodzaj=_rodzaj AND 
	   ((_byinfix=FALSE) OR (CASE WHEN COALESCE(_infix,'')='' THEN tr_infix IS NULL ELSE tr_infix=_infix END)) AND 
	   (_byseria=FALSE OR tr_seria=_seria) AND 
	   (_byrok=FALSE OR tr_rok=_rok)
 ORDER BY tr_numer DESC LIMIT 1 OFFSET 0;

 SELECT tr_numer INTO numerwol 
 FROM tg_wolnenumery 
 WHERE fm_idcentrali=_centrala AND 
       tr_rodzaj=_rodzaj AND 
	   ((_byinfix=FALSE) OR (tr_infix=COALESCE(_infix,''))) AND 
	   (_byseria=FALSE OR tr_seria=_seria) AND 
	   tr_datasprzedaz=date(now()) AND
	   (_byrok=FALSE OR tr_rok=_rok)
 ORDER BY tr_numer ASC LIMIT 1 OFFSET 0; --''
 IF FOUND THEN
  IF (numer IS NULL) THEN
   RETURN numerwol;
  END IF;
  RETURN min(numerwol,numer);
 END IF;

 IF (numer=NULL) THEN
  numer=1;
 END IF;

 RETURN numer;
END;
$$;
