CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='INSERT') THEN

  IF (nullZero((SELECT count(*) FROM tr_warianthead WHERE vmp_flaga&1=1 AND th_idtechnologii=NEW.th_idtechnologii AND vmp_idwariantu<>NEW.vmp_idwariantu))=0) THEN
   NEW.vmp_flaga=NEW.vmp_flaga|1;
  END IF;

 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
