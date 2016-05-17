CREATE FUNCTION onbiupodindexes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 ---Trigger BEFORE dla podindeksow

 IF (NEW.ttw_idxref IS NULL) THEN
  RETURN NEW;
 END IF;

 ---Ustaw flage
 NEW.ttw_newflaga=NEW.ttw_newflaga|(1<<23);

 IF (TG_OP='INSERT') THEN
  NEW.ttw_parentkod=(SELECT ttw_klucz FROM tg_towary WHERE ttw_idtowaru=NEW.ttw_idxref);
 ELSE
  IF (NEW.ttw_idxsufix IS DISTINCT FROM OLD.ttw_idxsufix) THEN
   NEW.ttw_parentkod=(SELECT ttw_klucz FROM tg_towary WHERE ttw_idtowaru=NEW.ttw_idxref);
  END IF;
 END IF;
 
 NEW.ttw_klucz=NEW.ttw_parentkod||COALESCE(NEW.ttw_idxinfix,'')||COALESCE(NEW.ttw_idxsufix,'');
  
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END;
$$;
