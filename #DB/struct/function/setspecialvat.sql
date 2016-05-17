CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtowaru ALIAS FOR $1;
 _idkraju ALIAS FOR $2;
 _idstawkivat ALIAS FOR $3;
 id INT;
 idvk INT;
BEGIN

 IF (_idstawkivat IS NULL) THEN
  RETURN removeSpecialVat(_idtowaru,_idkraju);
 END IF;

 idvk=(SELECT vk_idvatkraj FROM tg_vatykraje WHERE pw_idpowiatu=_idkraju AND ttv_idvatu=_idstawkivat);
 IF (idvk IS NULL) THEN
  RAISE EXCEPTION '12|%:%:%|Zly VAT dla kraju ',_idtowaru,_idkraju,_idstawkivat;
 END IF;

 id=(SELECT tv_idvatu FROM tg_vatytowarow WHERE ttw_idtowaru=_idtowaru AND pw_idpowiatu=_idkraju);
 IF (id IS NOT NULL) THEN
  UPDATE tg_vatytowarow SET vk_idvatkraj=idvk WHERE tv_idvatu=id AND vk_idvatkraj<>idvk;
  RETURN id;
 ELSE
  INSERT INTO tg_vatytowarow
   (ttw_idtowaru,pw_idpowiatu,vk_idvatkraj)
  VALUES
   (_idtowaru,_idkraju,idvk);

  id=currval('tg_vatytowarow_s');
 END IF;

 return id;
END
$_$;
