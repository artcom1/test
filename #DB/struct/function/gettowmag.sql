CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _ttw_idtowaru   ALIAS FOR $1;
 _tmg_idmagazynu ALIAS FOR $2;
 _create_new     ALIAS FOR $3; 
 _ttm_idtowmag   INT:=NULL;
BEGIN 

 IF (COALESCE(_ttw_idtowaru,0)<=0 OR COALESCE(_tmg_idmagazynu,0)<=0) THEN
   RETURN _ttm_idtowmag;
 END IF;
 
  _ttm_idtowmag=(SELECT ttm_idtowmag FROM tg_towmag WHERE ttw_idtowaru=_ttw_idtowaru AND tmg_idmagazynu=_tmg_idmagazynu);
  
  IF (COALESCE(_ttm_idtowmag,0)<=0) THEN -- Nie mam towmaga!
   IF (_create_new) THEN ---dodajemy towmag bo jeszcze nie byl uzywany towar na tym magazynie 
    INSERT INTO tg_towmag (tmg_idmagazynu,ttw_idtowaru)  VALUES (_tmg_idmagazynu,_ttw_idtowaru);
   _ttm_idtowmag=(SELECT currval('tg_towmag_s')); 
   END IF;
 END IF;
  
 RETURN _ttm_idtowmag;
END;
$_$;
