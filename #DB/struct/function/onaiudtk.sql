CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 value NUMERIC:=0;
BEGIN
 
 IF (TG_OP='DELETE') THEN
  value=(SELECT round(sum((tk_wydano-tk_przyjeto)*tk_kaucjajedn),2) FROM tg_tkelem WHERE tr_idtrans=OLD.tr_idtrans);
  value=nullZero(value);
  UPDATE tg_transakcje SET tr_wartosc=value WHERE tr_wartosc!=value AND tr_idtrans=OLD.tr_idtrans;
 ELSE
  value=(SELECT round(sum((tk_wydano-tk_przyjeto)*tk_kaucjajedn),2) FROM tg_tkelem WHERE tr_idtrans=NEW.tr_idtrans);
  value=nullZero(value);
  UPDATE tg_transakcje SET tr_wartosc=value WHERE tr_wartosc!=value AND tr_idtrans=NEW.tr_idtrans;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END; 
$$;
