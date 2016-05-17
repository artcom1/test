CREATE FUNCTION mrpp_guardonruch(idpalety integer, idmagazynu integer, idmiejsca integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
 r RECORD;
BEGIN
 IF (idpalety IS NULL) THEN
  RETURN TRUE;
 END IF;
 
 SELECT p.mm_idmiejsca,p.tmg_idmagazynu INTO r 
 FROM tr_mrppalety AS p
 WHERE p.mrpp_idpalety=idpalety;
 
 IF (COALESCE(r.tmg_idmagazynu,idmagazynu) IS DISTINCT FROM idmagazynu) THEN
  RAISE EXCEPTION '55|%:%:%|Paleta jest przeznaczona dla innego magazynu',idpalety,idmagazynu,r.tmg_idmagazynu;
 END IF;

 IF (r.mm_idmiejsca IS DISTINCT FROM idmiejsca) THEN
  RAISE EXCEPTION '56|%:%:%|Paleta jest przeznaczona dla innego miejsca magazynowego',idpalety,idmiejsca,r.mm_idmiejsca;
 END IF;
 
 RETURN TRUE;
END;
$$;
