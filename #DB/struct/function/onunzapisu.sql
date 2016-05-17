CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='INSERT') THEN
  NEW.zk_numer=(SELECT nullZero(max(zk_numer))+1 FROM kh_zapisyhead WHERE ro_idroku=NEW.ro_idroku AND dz_iddziennika=NEW.dz_iddziennika AND mn_miesiac=NEW.mn_miesiac AND zk_flaga&1=NEW.zk_flaga&1 AND zk_typ=NEW.zk_typ);
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF ((NEW.zk_flaga&1)<>(OLD.zk_flaga&1)) OR 
     (NEW.mn_miesiac<>OLD.mn_miesiac) OR 
     (NEW.ro_idroku<>OLD.ro_idroku) OR 
     (NEW.dz_iddziennika<>OLD.dz_iddziennika) OR
     (NEW.zk_typ<>OLD.zk_typ)
  THEN
   NEW.zk_numer=(SELECT nullZero(max(zk_numer))+1 FROM kh_zapisyhead WHERE ro_idroku=NEW.ro_idroku AND dz_iddziennika=NEW.dz_iddziennika AND mn_miesiac=NEW.mn_miesiac AND zk_flaga&1=NEW.zk_flaga&1 AND zk_typ=NEW.zk_typ);
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  NEW.zk_fullnumer=numerZapisu(NEW.zk_numer::text,NEW.mn_miesiac,NEW.dz_iddziennika,0,NEW.zk_typ);
  IF ((NEW.zk_flaga&1)<>0) AND (NEW.zk_wn<>NEW.zk_ma) THEN
   RAISE EXCEPTION 'Niezbilansowany zapis ksiegowy nie moze byc zamkniety';
  END IF;
  NEW.zk_flaga=NEW.zk_flaga&(~24);
  IF (NEW.mn_miesiac=0) THEN
   NEW.zk_flaga=NEW.zk_flaga|(1<<3);
  ELSIF (NEW.mn_miesiac=999999) THEN
   NEW.zk_flaga=NEW.zk_flaga|(3<<3);
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  IF (OLD.zk_flaga&1)<>0 THEN
   RAISE EXCEPTION 'Nie mozna usuwac zaksiegowanych dokumentow';
  END IF;
 END IF;

 RETURN NEW;
END;
$$;
