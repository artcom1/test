CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idustawienia ALIAS FOR $1;
 _idklienta ALIAS FOR $2;
 id INT;
BEGIN

 IF (_idustawienia IS NULL) THEN
  RETURN NULL;
 END IF;

 SELECT dpdf_id INTO id
 FROM tc_defaultpdf 
 JOIN tc_ustawieniapdf USING (pdf_idustawienia) 
 WHERE k_idklienta=_idklienta 
 AND pdf_hashcode=(SELECT pdf_hashcode FROM tc_ustawieniapdf WHERE pdf_idustawienia=_idustawienia) FOR UPDATE;

 IF (id IS NULL) THEN
  INSERT INTO tc_defaultpdf
   (pdf_idustawienia,k_idklienta)
  VALUES
   (_idustawienia,_idklienta);
  RETURN currval('tc_defaultpdf_s');
 END IF;

 UPDATE tc_defaultpdf SET pdf_idustawienia=_idustawienia WHERE dpdf_id=id AND pdf_idustawienia<>_idustawienia;

 RETURN id;
END
$_$;
