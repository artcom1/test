CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 _reset ALIAS FOR $1; -- id struktury
 _sk_rec RECORD;
 ret INT:=0;
BEGIN
 
 IF (_reset<>0) THEN
  UPDATE tg_towary SET ttw_newflaga=ttw_newflaga&(~((1<<15))), ttw_strukturakonstrukcyjna=NULL WHERE ttw_newflaga&(1<<15)<>0 OR ttw_strukturakonstrukcyjna IS NOT NULL;
 END IF;
  	
 FOR _sk_rec IN 
 SELECT 
 sk.sk_idstruktury, sk.ttw_idtowaru, fm.fm_idindextab, sk.sk_flaga
 FROM tr_strukturakonstrukcyjna AS sk 
 JOIN tb_firma AS fm ON (fm.fm_index=sk.fm_idcentrali)
 JOIN tg_towary AS tow ON (sk.ttw_idtowaru=tow.ttw_idtowaru)
 WHERE 
 sk.sk_flaga&32=32 AND
 sk.sk_flaga&(1<<6)=0 AND
 sk.ttw_idtowaru IS NOT NULL AND
 tow.ttw_strukturakonstrukcyjna[fm.fm_idindextab] IS NULL
 LOOP
  PERFORM naprawa_towar_struktura(_sk_rec.sk_idstruktury,_sk_rec.ttw_idtowaru,_sk_rec.fm_idindextab,_sk_rec.sk_flaga);
  ret=ret+1;
 END LOOP;
 
 RETURN ret;
END;
$_$;
