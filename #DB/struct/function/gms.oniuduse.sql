CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='DELETE') THEN
  UPDATE gms.tm_simcoll SET  sc_ilosc[0]=sc_ilosc[0]-(-OLD.stu_iloscwz_pnull,-OLD.stu_iloscwz_p,OLD.stu_iloscwz_pnull,OLD.stu_iloscwz_p),

                             sc_ilosc[1]=sc_ilosc[1]-(-OLD.stu_iloscrez_pnull,-OLD.stu_iloscrez_p,OLD.stu_iloscrez_pnull,OLD.stu_iloscrez_p),

			     sc_ilosc[2]=sc_ilosc[2]-(-OLD.stu_iloscrezl_pnull,-OLD.stu_iloscrezl_p,OLD.stu_iloscrezl_pnull,OLD.stu_iloscrezl_p)
			WHERE sc_sid=OLD.sc_sid AND sc_simid=OLD.sc_simid AND rc_idruchupz=OLD.rc_idruchupz;
 END IF;


 IF (TG_OP<>'DELETE') THEN
  UPDATE gms.tm_simcoll SET  sc_ilosc[0]=sc_ilosc[0]+(-NEW.stu_iloscwz_pnull,-NEW.stu_iloscwz_p,NEW.stu_iloscwz_pnull,NEW.stu_iloscwz_p),

                             sc_ilosc[1]=sc_ilosc[1]+(-NEW.stu_iloscrez_pnull,-NEW.stu_iloscrez_p,NEW.stu_iloscrez_pnull,NEW.stu_iloscrez_p),

			     sc_ilosc[2]=sc_ilosc[2]+(-NEW.stu_iloscrezl_pnull,-NEW.stu_iloscrezl_p,NEW.stu_iloscrezl_pnull,NEW.stu_iloscrezl_p)

			WHERE sc_sid=NEW.sc_sid AND sc_simid=NEW.sc_simid AND rc_idruchupz=NEW.rc_idruchupz;
 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
