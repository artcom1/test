CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP!='DELETE') THEN
  IF (NEW.zs_counter!=0) OR (NEW.zs_counterext!=0) THEN
   IF (NEW.zs_typ=0) THEN
    --W KH
    UPDATE tg_transakcje SET tr_flaga=tr_flaga|32768 WHERE tr_idtrans=NEW.tr_idtrans AND ((tr_flaga&32768)=0);
    UPDATE kh_platnosci SET pl_flaga=pl_flaga|65536 WHERE pl_idplatnosc=NEW.pl_idplatnosc AND ((pl_flaga&65536)=0);
    UPDATE st_amortyzacja SET am_czyksieg=am_czyksieg|1 WHERE am_id=NEW.am_id AND ((am_czyksieg&1)=0);
    UPDATE kh_platelem SET pp_flaga=pp_flaga|65536 WHERE pp_idplatelem=NEW.pp_idplatelem AND ((pp_flaga&65536)=0);
   END IF;
   IF (NEW.zs_typ=1) THEN
    --Metki
    UPDATE tg_transakcje SET tr_zamknieta=tr_zamknieta|(1<<30) WHERE tr_idtrans=NEW.tr_idtrans AND ((tr_zamknieta&(1<<30))=0);
   END IF;
   IF (NEW.zs_typ=2) THEN
    --Predekretacje
    UPDATE tg_transakcje SET tr_newflaga=tr_newflaga|(1<<0) WHERE tr_idtrans=NEW.tr_idtrans AND ((tr_newflaga&(1<<0))=0);
   END IF;
   IF (NEW.zs_typ=3) THEN
    --Nie do konca rozpisane wymiary
    UPDATE tg_transakcje SET tr_newflaga=tr_newflaga|(1<<1) WHERE tr_idtrans=NEW.tr_idtrans AND ((tr_newflaga&(1<<1))=0);
    UPDATE st_amortyzacja SET am_czyksieg=am_czyksieg|(1<<1) WHERE am_id=NEW.am_id AND ((am_czyksieg&(1<<1))=0);
    UPDATE kh_platnosci SET pl_flaga=pl_flaga|(1<<27) WHERE pl_idplatnosc=NEW.pl_idplatnosc AND ((pl_flaga&(1<<27))=0);
   END IF;
   IF (NEW.zs_typ=4) THEN
    --Rozpisane wymiary
    UPDATE tg_transakcje SET tr_newflaga=tr_newflaga|(1<<2) WHERE tr_idtrans=NEW.tr_idtrans AND ((tr_newflaga&(1<<2))=0);
    UPDATE st_amortyzacja SET am_czyksieg=am_czyksieg|(1<<2) WHERE am_id=NEW.am_id AND ((am_czyksieg&(1<<2))=0);
    UPDATE kh_platnosci SET pl_flaga=pl_flaga|(1<<28) WHERE pl_idplatnosc=NEW.pl_idplatnosc AND ((pl_flaga&(1<<28))=0);
   END IF;
   IF (NEW.zs_typ=5) THEN
    UPDATE tg_transakcje SET tr_newflaga=tr_newflaga|(1<<11) WHERE tr_idtrans=NEW.tr_idtrans AND ((tr_newflaga&(1<<11))=0);
   END IF;
   IF (NEW.zs_typ=6) THEN
    UPDATE tg_transakcje SET tr_newflaga=tr_newflaga|(1<<12) WHERE tr_idtrans=NEW.tr_idtrans AND ((tr_newflaga&(1<<12))=0);
   END IF;
   IF (NEW.zs_typ=7) THEN
    UPDATE tg_transakcje SET tr_newflaga=tr_newflaga|(1<<13) WHERE tr_idtrans=NEW.tr_idtrans AND ((tr_newflaga&(1<<13))=0);
   END IF;
   IF (NEW.zs_typ=8) THEN
    UPDATE tg_transakcje SET tr_newflaga=tr_newflaga|(1<<14) WHERE tr_idtrans=NEW.tr_idtrans AND ((tr_newflaga&(1<<14))=0);
   END IF;
  END IF;

  NEW.zs_counter=max(0,NEW.zs_counter);
  NEW.zs_counterext=max(0,NEW.zs_counterext);

 END IF;
 
 IF (TG_OP='DELETE') THEN

  IF (OLD.zs_counter!=0) OR (OLD.zs_counterext!=0) THEN
   RAISE EXCEPTION 'Nie mozna usuwac rekordu z niezerowym licznikiem skojarzen!';
  END IF;
  
  IF (OLD.zs_typ=0) THEN
   UPDATE tg_transakcje SET tr_flaga=tr_flaga&(~32768) WHERE tr_idtrans=OLD.tr_idtrans AND ((tr_flaga&32768)!=0);
   UPDATE kh_platnosci SET pl_flaga=pl_flaga&(~65536) WHERE pl_idplatnosc=OLD.pl_idplatnosc AND ((pl_flaga&65536)!=0);
   UPDATE st_amortyzacja SET am_czyksieg=am_czyksieg&(~1) WHERE am_id=OLD.am_id AND ((am_czyksieg&1)!=0);
   UPDATE kh_platelem SET pp_flaga=pp_flaga&(~65536) WHERE pp_idplatelem=OLD.pp_idplatelem AND ((pp_flaga&65536)!=0);
  END IF;
  IF NOT (OLD.tr_idtrans=NULL) AND (OLD.zs_typ=1) THEN
   UPDATE tg_transakcje SET tr_zamknieta=tr_zamknieta&(~(1<<30)) WHERE tr_idtrans=OLD.tr_idtrans AND ((tr_zamknieta&(1<<30))!=0);
  END IF;
  IF (OLD.zs_typ=2) THEN
   UPDATE tg_transakcje SET tr_newflaga=tr_newflaga&(~(1<<0)) WHERE tr_idtrans=OLD.tr_idtrans AND ((tr_newflaga&(1<<0))!=0);
  END IF;
  IF (OLD.zs_typ=3) THEN
   UPDATE tg_transakcje SET tr_newflaga=tr_newflaga&(~(1<<1)) WHERE tr_idtrans=OLD.tr_idtrans AND ((tr_newflaga&(1<<1))!=0);
   UPDATE st_amortyzacja SET am_czyksieg=am_czyksieg&(~(1<<1)) WHERE am_id=OLD.am_id AND ((am_czyksieg&(1<<1))!=0);
   UPDATE kh_platnosci SET pl_flaga=pl_flaga&(~(1<<27)) WHERE pl_idplatnosc=OLD.pl_idplatnosc AND ((pl_flaga&(1<<27))!=0);
  END IF;
  IF (OLD.zs_typ=4) THEN
   UPDATE tg_transakcje SET tr_newflaga=tr_newflaga&(~(1<<2)) WHERE tr_idtrans=OLD.tr_idtrans AND ((tr_newflaga&(1<<2))!=0);
   UPDATE st_amortyzacja SET am_czyksieg=am_czyksieg&(~(1<<2)) WHERE am_id=OLD.am_id AND ((am_czyksieg&(1<<2))!=0);
   UPDATE kh_platnosci SET pl_flaga=pl_flaga&(~(1<<28)) WHERE pl_idplatnosc=OLD.pl_idplatnosc AND ((pl_flaga&(1<<28))!=0);
  END IF;
  IF (OLD.zs_typ=5) THEN
   UPDATE tg_transakcje SET tr_newflaga=tr_newflaga&(~(1<<11)) WHERE tr_idtrans=OLD.tr_idtrans AND ((tr_newflaga&(1<<11))!=0);
  END IF;
  IF (OLD.zs_typ=6) THEN
   UPDATE tg_transakcje SET tr_newflaga=tr_newflaga&(~(1<<12)) WHERE tr_idtrans=OLD.tr_idtrans AND ((tr_newflaga&(1<<12))!=0);
  END IF;
  IF (OLD.zs_typ=7) THEN
   UPDATE tg_transakcje SET tr_newflaga=tr_newflaga&(~(1<<13)) WHERE tr_idtrans=OLD.tr_idtrans AND ((tr_newflaga&(1<<13))!=0);
  END IF;
  IF (OLD.zs_typ=8) THEN
   UPDATE tg_transakcje SET tr_newflaga=tr_newflaga&(~(1<<14)) WHERE tr_idtrans=OLD.tr_idtrans AND ((tr_newflaga&(1<<14))!=0);
  END IF;
 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
