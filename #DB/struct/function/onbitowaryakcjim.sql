CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='INSERT') THEN
  NEW.ta_ilosccurrent=COALESCE((SELECT sum(tel_iloscf) FROM tg_transelem WHERE ttw_idtowaru=NEW.ttw_idtowaru AND a_idakcji=NEW.zl_idzlecenia AND isForAkcjaM(a_idakcji,tel_skojlog,tel_flaga,tel_sprzedaz)),0);
 END IF;

 RETURN NEW;
END;
$$;
