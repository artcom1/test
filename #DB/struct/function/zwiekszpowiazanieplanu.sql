CREATE FUNCTION zwiekszpowiazanieplanu(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 pz_idref ALIAS FOR $1;
 idpow INT;
BEGIN
 IF (pz_idref>0) THEN
  idpow=(SELECT pw_idpowiazania FROM tg_powiazanieplanu WHERE pz_idplanu=pz_idref);
  IF (idpow>0) THEN
    UPDATE tg_powiazanieplanu SET pw_ile=pw_ile+1 WHERE pw_idpowiazania=idpow;
  ELSE
    INSERT INTO tg_powiazanieplanu (pz_idplanu,pw_ile) VALUES (pz_idref,1);
  END IF;
 END IF;
 
 RETURN 0;
END;
$_$;


SET search_path = v, pg_catalog;
