CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _ja_idjednostki ALIAS FOR $1;
 ja ALIAS FOR $2; 
 _ckdt_idkartoteki INT;
BEGIN
 --- 1. Sprawdzma, czy mam klienta, jesli nie to nie mam co robic
 IF (COALESCE(ja.k_idklientfor,0)=0) THEN
  RETURN 0; -- Wlasciciwe ze wzgledu na warunki wykonania funkcji nigdy nie powinienem tu wejsc, ale lepiej sie zabezpieczyc  
 END IF;
 
 _ckdt_idkartoteki=
 (
  SELECT ckdt_idkartoteki FROM tg_charklientdlatow 
  WHERE 
  ckdt_ttw_idtowaru=ja.ttw_idtowaru AND
  ckdt_k_idklienta=ja.k_idklientfor
 );
 
 IF (_ckdt_idkartoteki IS NOT NULL) THEN
  RETURN 0;
 END IF;
 
 INSERT INTO tg_charklientdlatow
 (
  ckdt_ja_idjednostki, ckdt_ttw_idtowaru, ckdt_k_idklienta,
  ckdt_ean, ckdt_nazwauklienta, ckdt_koduklienta, 
  ckdt_tda_idtypu,
  ckdt_flaga
 )
 VALUES
 (
  _ja_idjednostki, ja.ttw_idtowaru, ja.k_idklientfor,
  ja.ja_ean, ja.ja_nazwauklienta, ja.ja_koduklienta,
  ja.tda_idtypu,
  ((ja.ja_flaga & (1<<3))>>3)
 );
 
 RETURN 1;
END
$_$;
