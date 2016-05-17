CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 prorytet INT:=1;
 mm RECORD;
 magazyn INT;
 poczatek BOOL:=false;
BEGIN
 FOR mm IN SELECT mm_idmiejsca, mm_magazyn FROM ts_miejscamagazynowe WHERE mm_l=(mm_r-1) ORDER BY mm_magazyn, mm_fullnumer ASC, mm_idmiejsca ASC
 LOOP
  IF (poczatek=FALSE) THEN
   magazyn=mm.mm_magazyn;
   poczatek=TRUE;
  END IF;
  IF (magazyn!=mm.mm_magazyn) THEN
   magazyn=mm.mm_magazyn;
   prorytet=1;
  END IF;

  UPDATE ts_miejscamagazynowe SET mm_prorytet=prorytet WHERE mm_idmiejsca=mm.mm_idmiejsca;
  prorytet=1+prorytet;
 END LOOP;
 RETURN 1;
END;$$;
