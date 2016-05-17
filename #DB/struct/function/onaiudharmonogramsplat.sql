CREATE FUNCTION onaiudharmonogramsplat() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 ile INT;
 rectr RECORD;
 rechs RECORD;
 ile_za INT:=0;
BEGIN

 IF (TG_OP='DELETE') THEN
  ile=(SELECT count(*) FROM tb_hmsplat WHERE tr_idtrans=OLD.tr_idtrans AND hs_idelementu<>OLD.hs_idelementu);
  IF (ile=0) THEN
   UPDATE tg_transakcje SET tr_flaga=tr_flaga&(~(1<<26)),tr_formaplat=flipFormaPlatnosci(tr_formaplat,FALSE) WHERE tr_idtrans=OLD.tr_idtrans;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  SELECT tr_dozaplaty,tr_zaplacono,tr_zamknieta INTO rectr FROM tg_transakcje WHERE tr_idtrans=OLD.tr_idtrans;
 ELSE
  SELECT tr_dozaplaty,tr_zaplacono,tr_zamknieta INTO rectr FROM tg_transakcje WHERE tr_idtrans=NEW.tr_idtrans;
 END IF;

 IF ((rectr.tr_zamknieta&1::int2)<>0) THEN
  ----pobieramy ile jest dokumentow za do tego dokumentu
  
  IF (TG_OP='DELETE') THEN
   ile_za=(SELECT count(*) FROM tg_transakcje WHERE (tr_skojlog=OLD.tr_idtrans) AND (tr_rodzaj IN (103,113)));
   SELECT nullZero(sum(hs_dozaplaty)) AS dozaplaty,nullZero(sum(hs_zaplacono)) AS zaplacono INTO rechs FROM tb_hmsplat WHERE hs_idelementu<>OLD.hs_idelementu AND tr_idtrans=OLD.tr_idtrans;
  ELSE
   ile_za=(SELECT count(*) FROM tg_transakcje WHERE (tr_skojlog=NEW.tr_idtrans) AND (tr_rodzaj IN (103,113)));
   SELECT nullZero(sum(hs_dozaplaty)) AS dozaplaty,nullZero(sum(hs_zaplacono)) AS zaplacono INTO rechs FROM tb_hmsplat WHERE tr_idtrans=NEW.tr_idtrans;
  END IF;

  IF (ile_za=0) THEN
   ---sprawdzamy czy nie rozjezdza sie nam wartosc dokumentu z harmonogramem
   IF (rechs.zaplacono<>rectr.tr_zaplacono) THEN
    RAISE EXCEPTION 'Suma zap??aconych rat jest r????na od warto??ci sp??aty dokumentu (%,%)!',rechs.zaplacono,rectr.tr_zaplacono;
   END IF;

   IF (rechs.dozaplaty<>rectr.tr_dozaplaty) AND (rechs.dozaplaty<>0) THEN
    RAISE EXCEPTION 'Suma rat jest r????na od warto??ci dokumentu (%,%)!',rechs.dozaplaty,rectr.tr_dozaplaty;
   END IF;
  END IF;

 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
