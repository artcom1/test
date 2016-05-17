CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idzlecenia ALIAS FOR $1;
 _idtowaru ALIAS FOR $2;
 _idklienta ALIAS FOR $3;
 _deltailosc ALIAS FOR $4;
 id INT;
BEGIN

 id=(SELECT d.tad_id 
     FROM tg_towaryakcjimdet AS d 
	 JOIN tg_towaryakcjim AS m USING (ta_idtowaru) 
	 WHERE m.zl_idzlecenia=_idzlecenia AND 
	       m.ttw_idtowaru=_idtowaru AND
		   d.k_idklienta=_idklienta
    );
	
 IF (id IS NOT NULL) THEN
  --Znalazlem juz szczegoly dla tego klienta - wiec rob update
  UPDATE tg_towaryakcjimdet
  SET tam_ilosccurrent=tam_ilosccurrent+_deltailosc 
  WHERE tad_id=id;
  
  RETURN _deltailosc;
 END IF;

 id=(SELECT m.ta_idtowaru
	 FROM tg_towaryakcjim AS m
	 WHERE m.zl_idzlecenia=_idzlecenia AND 
	       m.ttw_idtowaru=_idtowaru
    );
 IF (id IS NULL) THEN
  RETURN _deltailosc;
 END IF;

 INSERT INTO tg_towaryakcjimdet
  (ta_idtowaru,tam_ilosccurrent,k_idklienta)
 VALUES
  (id,_deltailosc,_idklienta); 

 RETURN _deltailosc;
END;
$_$;
