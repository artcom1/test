CREATE FUNCTION recalcdocvat(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 masknew  INT:=0;
 flagnew  INT:=0;
 vat_data RECORD;
 flagac0  INT:=0;
 flagaw   INT:=0;
BEGIN

 SELECT v.*,tr.tr_zamknieta&(1<<22) AS z,tr.tr_idtrans AS idtrans INTO vat_data FROM tg_transakcje AS tr LEFT OUTER JOIN vat.kv_raport_vat AS v USING (tr_idtrans) WHERE tr.tr_idtrans=$1;
 ---OBliczamy netto i vat
 IF (vat_data.idtrans IS NULL OR (vat_data.z<>0)) THEN
  RETURN FALSE;
 END IF;
  
 masknew=masknew|(1<<5)|(1<<6)|(1<<8); 
 IF (COALESCE(vat_data.l_pozycji,0)>COALESCE(vat_data.l_pozycjiusl,0)) THEN 
  flagnew=flagnew|(1<<5);
 END IF;
 
 IF (COALESCE(vat_data.l_pozycjiusl,0)>0) THEN 
  flagnew=flagnew|(1<<6);
 END IF;  
  
 IF (vat_data.v_kursdokmin IS DISTINCT FROM vat_data.v_kursdokmax) THEN
  flagnew=flagnew|(1<<8);
 END IF;

 IF (COALESCE(vat_data.l_pozycji0,0)>0) THEN flagac0=1; END IF;
 IF (COALESCE(vat_data.v_iloscwyd_sum,0)<>0) THEN flagaw=1; END IF;
 
 ---RAISE NOTICE '% % %',vat_data.netto,vat_data.brutto,vat_data.vat;

 ---Liczenie od netto, zrob update vatu i wartosci brutto
 UPDATE tg_transakcje SET 
  tr_wartosc=nullZero(vat_data.netto),
  tr_dozaplaty=nullZero(vat_data.brutto),
  tr_vat=nullZero(vat_data.vat),
  tr_flaga=CenyZeroFlaga(iloscPozycjiFlaga((tr_flaga&(~1024))|(flagaw<<10),COALESCE(vat_data.l_pozycji,0)),flagac0),
  tr_zamknieta=toTrZamknietaFlaga(tr_zamknieta,COALESCE(vat_data.iloscoo,0)),
  tr_newflaga=(tr_newflaga&(~masknew))|flagnew
 WHERE 
  tr_idtrans=$1 AND 
  (
   (tr_wartosc<>nullZero(vat_data.netto)) OR 
   (tr_vat<>nullZero(vat_data.vat)) OR 
   (tr_dozaplaty<>nullZero(vat_data.brutto)) OR
   (tr_flaga<>CenyZeroFlaga(iloscPozycjiFlaga((tr_flaga&(~1024))|(flagaw<<10),COALESCE(vat_data.l_pozycji,0)),flagac0)) OR
   (tr_zamknieta<>toTrZamknietaFlaga(tr_zamknieta,COALESCE(vat_data.iloscoo,0))) OR
   (tr_newflaga<>((tr_newflaga&(~masknew))|flagnew))
   );

 RETURN TRUE;
END;
$_$;
