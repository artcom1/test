CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 id INT;
BEGIN

 IF (cena IS NULL) OR (waluta IS NULL) OR (idtrans IS NULL) THEN
  RETURN NULL;
 END IF;
 
 IF ((SELECT fm_idcentrali FROM tg_transakcje WHERE tr_idtrans=idtrans) IS NULL) THEN
  RETURN NULL;
 END IF;

 id=(SELECT zcz_id FROM tg_zmianycenzakupu WHERE ttw_idtowaru=idtowaru AND tr_idtrans=idtrans AND zcz_typ=typ);
 IF (id IS NOT NULL) THEN
 
  UPDATE tg_zmianycenzakupu SET
         zcz_cena=cena,
         zcz_waluta=waluta,
		 zcz_dataop=now()
		 WHERE zcz_id=id AND (zcz_cena!=cena OR zcz_waluta!=waluta);
  
  RETURN id;
 END IF;

 INSERT INTO tg_zmianycenzakupu
  (ttw_idtowaru,
   fm_idcentrali,
   tr_idtrans,zcz_typ,
   zcz_cena,zcz_waluta)
  VALUES
  (idtowaru,
   (SELECT fm_idcentrali FROM tg_transakcje WHERE tr_idtrans=idtrans),
   idtrans,typ,
   cena,waluta);
 
 RETURN currval('tg_zmianycenzakupu_s');
END;
$$;
