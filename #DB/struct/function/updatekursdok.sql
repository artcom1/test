CREATE FUNCTION updatekursdok(integer, integer, mpq) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtrans ALIAS FOR $1;
 _idwaluty ALIAS FOR $2;
 _kurs ALIAS FOR $3;
 kurs_waluty MPQ:=1;
 id INT;
BEGIN
 IF (_kurs is NOT NULL) THEN
  kurs_waluty=_kurs;
 END IF;

 SELECT kd_idkursu INTO id FROM tg_kursdok WHERE tr_idtrans=_idtrans AND wl_idwaluty=_idwaluty FOR UPDATE;

 IF (id IS NOT NULL) THEN
  UPDATE tg_kursdok SET kd_kurs=_kurs WHERE kd_idkursu=id AND kd_kurs<>kurs_waluty;
  RETURN id;
 ELSE
  INSERT INTO tg_kursdok
   (tr_idtrans,wl_idwaluty,kd_kurs)
  VALUES
   (_idtrans,_idwaluty,kurs_waluty);
  RETURN currval('tg_kursdok_s');
 END IF;

 RETURN NULL;
END;
 $_$;
