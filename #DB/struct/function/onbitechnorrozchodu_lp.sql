CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (NEW.trr_lp = 0) THEN
  IF (NEW.trr_idparent IS NULL) THEN
   NEW.trr_lp=nullZero((SELECT max(trr_lp) FROM tr_rrozchodu WHERE th_idtechnologii=NEW.th_idtechnologii AND trr_wplywmag=NEW.trr_wplywmag AND trr_idparent IS NULL))+1;
  END IF;
 END IF;

 RETURN NEW;
END;
$$;
