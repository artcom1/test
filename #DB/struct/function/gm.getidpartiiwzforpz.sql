CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idpartiipz        ALIAS FOR $1;
 _createifnotexists ALIAS FOR $2;
 -----------------------------------
 r                  tg_partie;
 ret                INT;
BEGIN
 
 SELECT * INTO r FROM tg_partie WHERE prt_idpartii=_idpartiipz;

 IF (r.prt_idpartii IS NULL) THEN
  RETURN NULL;
 END IF;

 IF (r.prt_wplyw<0) THEN
  RETURN r.prt_idpartii;
 END IF;

 ret=(SELECT prt_idpartii FROM tg_partie AS p WHERE p.prt_wplyw<0 AND prt_idref=_idpartiipz);

 IF (ret IS NOT NULL OR _createifnotexists=FALSE) THEN
  RETURN ret;
 END IF;

 INSERT INTO tg_partie
  (ttw_idtowaru,prt_wplyw,
   prt_idref,
   prt_rtowaru
   )
 VALUES
  (r.ttw_idtowaru,-1,
  _idpartiipz,
  (SELECT ttw_rtowaru FROM tg_towary WHERE ttw_idtowaru=r.ttw_idtowaru)
  );
   
 return currval('tg_partie_s');
END;
$_$;
