CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF (TG_OP='DELETE') THEN
  IF (OLD.vmp_flaga&1=1) THEN
   UPDATE tr_warianthead SET vmp_flaga=vmp_flaga|1 WHERE vmp_idwariantu IN (SELECT vmp_idwariantu FROM tr_warianthead WHERE th_idtechnologii=OLD.th_idtechnologii AND vmp_idwariantu<>OLD.vmp_idwariantu ORDER BY vmp_idwariantu LIMIT 1);
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END; 
$$;
