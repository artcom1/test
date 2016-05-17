CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 r RECORD;
BEGIN
 
 IF (NEW.tel_stvat=0) AND (NEW.tel_newflaga&2<>0) AND (NEW.tel_newflaga&4<>0) AND ((NEW.tel_flaga&(1<<31))=0) THEN
  SELECT tr_zamknieta, tr_newflaga,tr_rodzaj INTO r FROM tg_transakcje WHERE tr_idtrans=NEW.tr_idtrans;
  IF ((r.tr_zamknieta&(256|512|1024|8192)=0) AND (r.tr_newflaga&(3<<19)=0) AND (r.tr_rodzaj!=77)) THEN
   SELECT ttw_vats INTO r FROM tg_towary WHERE ttw_idtowaru=NEW.ttw_idtowaru;
   IF (r.ttw_vats<>NEW.tel_stvat) THEN
    RAISE EXCEPTION 'Blad stawki Vat - prosze o kontakt z CFI 080100543';
   END IF;
  END IF;
 END IF;

 RETURN NEW;
END;
$$;
