CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='INSERT') THEN
  UPDATE tr_technologie SET th_flaga=th_flaga|(1<<9) WHERE th_idtechnologii=NEW.th_idtechnologii;
 END IF;

 IF (TG_OP='DELETE') THEN
  UPDATE tr_technologie SET th_flaga=th_flaga&(~(1<<9)) WHERE th_idtechnologii=OLD.th_idtechnologii;
 END IF;

 IF (TG_OP='UPDATE') THEN
  -- Szukam nowej technologii ostatnio wygenerowanej
  IF (NEW.kalk_th_idtechnologii IS NULL AND OLD.kalk_th_idtechnologii IS NOT NULL) THEN
   NEW.kalk_th_idtechnologii=(SELECT th_idtechnologii FROM tr_technologie WHERE th_kalkulacjasrc=NEW.th_idtechnologii ORDER BY th_idtechnologii DESC LIMIT 1);
  END IF;  
  -- Szukam nowej kalkulacji ostatnio wygenerowanej
  IF (NEW.kalk_sk_idstruktury IS NULL AND OLD.kalk_sk_idstruktury IS NOT NULL) THEN
   NEW.kalk_sk_idstruktury=
   (
    SELECT sk_idstruktury FROM tr_strukturakonstrukcyjna 
	WHERE 
	sk_idstrukkalksrc=(SELECT sk_idstruktury FROM tr_technologie WHERE th_idtechnologii=NEW.th_idtechnologii)
	 ORDER BY sk_idstruktury DESC LIMIT 1
   );
  END IF;  
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
