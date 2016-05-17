CREATE FUNCTION zloz_rezerwacje(integer, integer, numeric, integer, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 _ttm_idtowmag ALIAS FOR $1;
 _k_idklienta ALIAS FOR $2;
 _ilosc ALIAS FOR $3;
 _kierunek ALIAS FOR $4;
 _wsp1 ALIAS FOR $5;
 id INT;
 _wsp INT;
BEGIN

 IF (_wsp1<>0) THEN
  _wsp=1;
 ELSE
  _wsp=0;
 END IF;

 id=(SELECT rz_idrezerwacji FROM tg_rezerwacje WHERE k_idklienta=_k_idklienta AND ttm_idtowmag=_ttm_idtowmag);

 IF id IS NULL THEN
  INSERT INTO tg_rezerwacje (k_idklienta,ttm_idtowmag,rz_ilosc,rz_flaga,rz_iloscdost) VALUES (_k_idklienta,_ttm_idtowmag,_ilosc,((_kierunek+1)<<1)+1,_ilosc*_wsp);
 ELSE
  UPDATE tg_rezerwacje SET rz_ilosc=_ilosc*_kierunek*(((rz_flaga&6::int2)>>1)-1)+rz_ilosc,rz_iloscdost=_wsp*_ilosc*_kierunek*(((rz_flaga&6::int2)>>1)-1)+rz_iloscdost WHERE rz_idrezerwacji=id;
 END IF;

 RETURN _ilosc;
END; $_$;
