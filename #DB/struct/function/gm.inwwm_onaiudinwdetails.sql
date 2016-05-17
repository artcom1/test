CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='UPDATE') THEN
  IF (NEW.mm_idmiejsca IS DISTINCT FROM OLD.mm_idmiejsca) THEN
   RAISE EXCEPTION 'Nie mozna zmieniac miejsca inwentaryzacji';
  END IF;
  IF (NEW.tr_idtrans IS DISTINCT FROM OLD.tr_idtrans) THEN
   RAISE EXCEPTION 'Nie mozna zmieniac dokumentu inwentaryzacji';
  END IF;
  
  IF (NEW.ind_isinbuf=FALSE) THEN
   IF (NEW.ind_iloscf_calc!=OLD.ind_iloscf_calc) THEN
    RAISE EXCEPTION 'Nie mozna zmieniac ilosci calc na zamknietej inwentaryzacji!';
   END IF;
   IF (NEW.ind_iloscf!=OLD.ind_iloscf) THEN
    RAISE EXCEPTION 'Nie mozna zmieniac ilosci na zamknietej inwentaryzacji!';
   END IF;
   IF (NEW.ind_iloscfmoved!=OLD.ind_iloscfmoved) THEN
    RAISE EXCEPTION 'Nie mozna zmieniac ilosci moved na zamknietej inwentaryzacji!';
   END IF;
  END IF;  
 END IF;
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW; 
END;
$$;
