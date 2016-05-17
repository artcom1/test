CREATE FUNCTION onadtechnorrozchodu_lp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='DELETE') THEN
  IF (OLD.trr_idparent IS NULL) THEN
   UPDATE tr_rrozchodu SET trr_lp=trr_lp-1 WHERE th_idtechnologii=OLD.th_idtechnologii AND trr_lp>OLD.trr_lp AND trr_wplywmag=OLD.trr_wplywmag AND trr_idparent IS NULL;
  END IF;
 END IF;

 RETURN OLD;
END;
$$;
