CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP<>'DELETE') THEN
  NEW.ttw_idtowaru=(SELECT ttw_idtowaru FROM tg_towmag WHERE ttm_idtowmag=NEW.ttm_idtowmag);
 END IF;

 IF ((TG_OP='INSERT') OR (TG_OP='UPDATE')) THEN
  IF (NEW.tk_lp=0) THEN
   NEW.tk_lp=(SELECT nullZero(max(tk_lp))+1 FROM tg_tkelem WHERE tr_idtrans=NEW.tr_idtrans);
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
