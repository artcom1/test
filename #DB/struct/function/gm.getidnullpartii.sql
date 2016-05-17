CREATE FUNCTION getidnullpartii(integer, boolean DEFAULT true, integer DEFAULT 1) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtowaru ALIAS FOR $1;
 _create   ALIAS FOR $2;
 _wsp      ALIAS FOR $3;
 ret INT;
BEGIN

 IF (_wsp<0) THEN _wsp=-2; END IF;

 ret=gm.getIDNULLPartiiFast(_idtowaru,_wsp);

 IF (ret IS NOT NULL OR (_create=FALSE)) THEN
  RETURN ret;
 END IF;

 INSERT INTO tg_partie 
 (ttw_idtowaru,prt_wplyw,
  prt_rtowaru) 
 VALUES 
 (_idtowaru,_wsp,
  (SELECT ttw_rtowaru FROM tg_towary WHERE ttw_idtowaru=_idtowaru)
 );

 RETURN currval('tg_partie_s');
END;
$_$;
