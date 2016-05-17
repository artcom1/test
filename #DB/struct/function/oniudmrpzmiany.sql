CREATE FUNCTION oniudmrpzmiany() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 dataroz TIMESTAMP;
 datazak TIMESTAMP;
 kubelek RECORD;
BEGIN
 IF (TG_OP='UPDATE') THEN
 ---przy zapisywaniu zmian sprawdzamy czy zmianily sie termin zmian jesli tak to akutualizujemy plany niewykonane
  IF (NEW.zm_godzinaroz<>OLD.zm_godzinaroz OR NEW.zm_godzinazak<>OLD.zm_godzinazak) THEN
   ---pobieramy kubelki dla danej zmiany
    FOR kubelek IN SELECT kb_idkubelka, kb_data FROM tr_kubelki WHERE zm_idzmiany=NEW.zm_idzmiany ORDER BY kb_data ASC
    LOOP  
     dataroz=(kubelek.kb_data||' '||NEW.zm_godzinaroz)::timestamp;
     IF (NEW.zm_godzinaroz<NEW.zm_godzinazak) THEN 
      datazak=(kubelek.kb_data||' '||NEW.zm_godzinazak)::timestamp;
     ELSE ---zmiana przechodzaca przez polnoc dodajemy do daty jeden dzien
      datazak=(kubelek.kb_data+1||' '||NEW.zm_godzinazak)::timestamp;
     END IF;
     UPDATE tr_kkwnodplan SET knp_datarozpoczecia=dataroz, knp_datazakonczenia=datazak WHERE knp_flaga&(1|2|32)=32 AND kb_idkubelka=kubelek.kb_idkubelka;
    END LOOP;
   END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
