CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idmagazynu ALIAS FOR $1;
 _idtowaru ALIAS FOR $2;
 _stan ALIAS FOR $3;
 id INT;
 idr INT;
BEGIN

 SELECT ttm_idtowmag INTO id FROM tg_towmag WHERE tmg_idmagazynu=_idmagazynu AND ttw_idtowaru=_idtowaru;

 IF (id IS NULL) THEN
  INSERT INTO tg_towmag
   (tmg_idmagazynu,ttw_idtowaru)
  VALUES
   (_idmagazynu,_idtowaru);
  id=(SELECT currval('tg_towmag_s'));
 END IF;

 SELECT rc_idruchu INTO idr FROM tg_ruchy WHERE ttm_idtowmag=id AND isPZet(rc_flaga) and rc_flaga&1024=1024;

 IF (idr IS NULL) THEN
  INSERT INTO tg_ruchy
   (ttm_idtowmag,ttw_idtowaru,tmg_idmagazynu,rc_kierunek,rc_flaga,rc_dostawa,rc_wspmag) 
  VALUES
   (id,_idtowaru,_idmagazynu,1,2|1024|(1<<30),NULL,1);
  idr=(SELECT currval('tg_ruchy_s'));
 END IF;

 UPDATE 
  tg_ruchy 
 SET 
  rc_iloscpoz=max(0,_stan),
  rc_ilosc=max(0,_stan)+(rc_ilosc-rc_iloscpoz)
 WHERE 
  rc_idruchu=idr AND 
  rc_iloscpoz<>max(0,_stan);

 RETURN id;
END;
$_$;
