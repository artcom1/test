CREATE FUNCTION oniudkpoelem() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltawagi NUMERIC:=0;
 idheadu INT;
 tmp int;
BEGIN
 IF (TG_OP = 'INSERT') THEN
  NEW.kpe_wagaprzelicznik=NullZero((SELECT ttw_waga FROM tg_towary WHERE ttw_idtowaru=NEW.ttw_idtowaru));
  NEW.kpe_waga=round((NEW.kpe_wagaprzelicznik*NEW.kpe_iloscf)/1000,3); ---waga w tonach zaokroglenie do 3 miejsc
  deltawagi=NEW.kpe_waga;
  idheadu=NEW.kpo_idheadu;
  ----uakualniamy flage odnosnie pozycji karty
  UPDATE tg_kpohead SET kpo_flaga=kpo_flaga|8 WHERE kpo_idheadu=NEW.kpo_idheadu;
 END IF;

 IF (TG_OP = 'UPDATE') THEN
  IF (NEW.ttw_idtowaru!=OLD.ttw_idtowaru) THEN
   NEW.kpe_wagaprzelicznik=(SELECT ttw_waga FROM tg_towary WHERE ttw_idtowaru=NEW.ttw_idtowaru);
  END IF;
  NEW.kpe_waga=round((NEW.kpe_wagaprzelicznik*NEW.kpe_iloscf)/1000,3); ---waga w tonach zaokroglenie do 3 miejsc
  deltawagi=NEW.kpe_waga-OLD.kpe_waga;
  idheadu=NEW.kpo_idheadu;
 END IF;

 IF (TG_OP = 'DELETE') THEN  
  deltawagi=-OLD.kpe_waga;
  idheadu=OLD.kpo_idheadu;
 END IF;

 IF (deltawagi!=0) THEN
  UPDATE tg_kpohead SET kpo_waga=kpo_waga+deltawagi WHERE kpo_idheadu=idheadu;
 END IF;

 IF (TG_OP = 'DELETE') THEN  
   ----uakualniamy flage odnosnie pozycji karty
  tmp=(SELECT count(*)  FROM tg_kpoelem WHERE kpo_idheadu=OLD.kpo_idheadu AND kpe_idelemu!=OLD.kpe_idelemu);
  IF (tmp=0) THEN
   UPDATE tg_kpohead SET kpo_flaga=kpo_flaga&(~8) WHERE kpo_idheadu=OLD.kpo_idheadu;
  END IF;
 
  RETURN OLD;
 END IF;

 RETURN NEW;
END;
$$;
