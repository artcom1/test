CREATE FUNCTION realizujpzam(integer, integer, integer, numeric, integer, integer DEFAULT NULL::integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _elemsrc  ALIAS FOR $1;
 _elemdst  ALIAS FOR $2;
 _texdst   ALIAS FOR $3;
 _dilosc   ALIAS FOR $4;
 _powodalt ALIAS FOR $5;
 _powod    ALIAS FOR $6; 
 id INT;
 cozrobic  INT DEFAULT 1<<4;
BEGIN

 IF (_dilosc=0) THEN
  RETURN NULL;
 END IF;
 
 _powod=COALESCE(_powod,_powodalt);
 
 id=(SELECT rm_idrealizacji FROM tg_realizacjapzam WHERE (tel_idelemsrc=_elemsrc) AND (tel_idpzam=_elemdst) AND (tex_idpzam IS NOT DISTINCT FROM _texdst) AND (rm_powod IN (_powod,_powodalt)));
 IF (id IS NULL) THEN

  PERFORM gm.disableTouch(1);
  
  CASE _powod 
   WHEN 18 THEN   --Realizacja naglowka rozmiarowki
    cozrobic=(1<<1); 
   WHEN 16 THEN 
    cozrobic=(8<<4)|(1<<1)|(1<<2); 
   ELSE
    cozrobic=cozrobic;
  END CASE;

  INSERT INTO tg_realizacjapzam
   (tel_idelemsrc,tel_idpzam,rm_iloscf,rm_powod,rm_flaga,tex_idpzam)
  VALUES
   (_elemsrc,_elemdst,_dilosc,_powod,cozrobic,_texdst);

  id=(SELECT currval('tg_realizacjapzam_s'));

  PERFORM gm.disableTouch(-1);

  RETURN id;
 ELSE
  PERFORM gm.disableTouch(1);

  UPDATE tg_realizacjapzam SET rm_iloscf=rm_iloscf+_dilosc WHERE rm_idrealizacji=id;
  
 PERFORM gm.disableTouch(-1);

  RETURN id;
 END IF;

 RETURN NULL;
END;
$_$;
