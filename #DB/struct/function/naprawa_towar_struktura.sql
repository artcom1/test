CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 ----funkcja naprawia powiazania miedzy towarem a struktura (ustawia flage na towarze i pole ttw_strukturakonstrukcyjna
 _sk_idstruktury ALIAS FOR $1; -- id struktury
 _ttw_idtowaru   ALIAS FOR $2; -- id towaru
 _fm_idindextab  ALIAS FOR $3; -- index w tablicy
 _sk_flaga       ALIAS FOR $4; -- flaga struktury (tak w razie czego)
 
 rec RECORD;
BEGIN
 IF (_sk_flaga&32<>32 OR _sk_flaga&(1<<6)=(1<<6)) THEN
  RETURN 0;
 END IF;
 
 UPDATE tg_towary SET ttw_newflaga=ttw_newflaga|(1<<15), ttw_strukturakonstrukcyjna[_fm_idindextab]=_sk_idstruktury WHERE ttw_idtowaru=_ttw_idtowaru; 
 
 RAISE NOTICE 'ttw_strukturakonstrukcyjna[%]=% WHERE ttw_idtowaru=%',_fm_idindextab,_sk_idstruktury,_ttw_idtowaru;
 RETURN _ttw_idtowaru;
END;
$_$;
