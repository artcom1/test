CREATE FUNCTION zwiekszpowiazaniepaczek(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 pk_idref ALIAS FOR $1;
 idpow INT;
BEGIN
 IF (pk_idref>0) THEN
  idpow=(SELECT pp_idpowpack FROM tg_powiazaniepaczek WHERE pk_idpaczki=pk_idref);
  IF (idpow>0) THEN
    UPDATE tg_powiazaniepaczek SET pp_ile=pp_ile+1 WHERE pp_idpowpack=idpow;
  ELSE
    INSERT INTO tg_powiazaniepaczek (pk_idpaczki,pp_ile) VALUES (pk_idref,1);
  END IF;
 END IF;
 
 RETURN 0;
END;
$_$;
