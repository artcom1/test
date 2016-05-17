CREATE FUNCTION ustanyother(integer, integer, numeric, numeric, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idklienta ALIAS FOR $1;
 _idtowaru ALIAS FOR $2;
 _stan ALIAS FOR $3;
 _cena ALIAS FOR $4;
 _waluta ALIAS FOR $5;
 r RECORD;
BEGIN

 IF (_idklienta IS NULL) OR (_idtowaru IS NULL) THEN
  RETURN NULL;
 END IF;

 IF (_stan=0) AND (COALESCE(_cena,0)=0) THEN
  DELETE FROM tg_stanyother WHERE k_idklienta=_idklienta AND ttw_idtowaru=_idtowaru;
  RETURN NULL;
 END IF;

 FOR r IN SELECT so_idstanu FROM tg_stanyother WHERE k_idklienta=_idklienta AND ttw_idtowaru=_idtowaru FOR UPDATE
 LOOP
  UPDATE tg_stanyother SET so_stan=_stan,
                           so_data=now(),
			   so_cenanetto=_cena,
			   so_idwaluty=_waluta
		       WHERE so_idstanu=r.so_idstanu AND 
		             NOT
		             (so_stan=_stan AND
			      so_data=now() AND
			      so_cenanetto=_cena AND
			      so_idwaluty=_waluta
			     );
  RETURN r.so_idstanu;
 END LOOP;

 INSERT INTO tg_stanyother (k_idklienta,ttw_idtowaru,so_stan,so_cenanetto,so_idwaluty) VALUES (_idklienta,_idtowaru,_stan,_cena,_waluta);

 RETURN currval('tg_stanyother_s');
END;
$_$;
