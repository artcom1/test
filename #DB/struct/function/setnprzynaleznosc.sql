CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idref    ALIAS FOR $1;
 _type     ALIAS FOR $2;
 _rodzaj   ALIAS FOR $3;
 id        INT;

BEGIN
 id=(SELECT mp_idprzywiazania FROM tm_przynaleznosci WHERE mp_idref=_idref AND mp_type=_type AND mp_rodzaj=_rodzaj);

 IF (id IS NULL) THEN
  INSERT INTO tm_przynaleznosci
   (mp_idref,mp_type,mp_rodzaj)
  VALUES
   (_idref,_type,_rodzaj);
  id=(SELECT currval('tm_przynaleznosci_s'));
 END IF;

 RETURN id;
END;
$_$;
