CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 cntid SMALLINT:=0;
 idmm INT;
BEGIN

 IF (TG_OP!='INSERT') THEN
 
  IF (OLD.ine_isinbuf=TRUE) THEN
   cntid=cntid-1;
   idmm=OLD.mm_idmiejsca;
  END IF;
  
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (NEW.mm_idmiejsca IS DISTINCT FROM OLD.mm_idmiejsca) THEN
   RAISE EXCEPTION 'Nie mozna zmieniac miejsca inwentaryzacji';
  END IF;
  IF (NEW.tr_idtrans IS DISTINCT FROM OLD.tr_idtrans) THEN
   RAISE EXCEPTION 'Nie mozna zmieniac dokumentu inwentaryzacji';
  END IF;
 END IF;
 
 IF (TG_OP!='DELETE') THEN
 
  IF (NEW.ine_isinbuf=TRUE) THEN
   cntid=cntid+1;
   idmm=NEW.mm_idmiejsca;
  END IF;
  
 END IF; 
 
 IF (cntid!=0) THEN
  UPDATE ts_miejscamagazynowe SET mm_openinwscount=mm_openinwscount+cntid WHERE mm_idmiejsca=idmm;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW; 
END;
$$;
