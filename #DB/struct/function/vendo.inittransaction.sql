CREATE OR REPLACE FUNCTION 
    LANGUAGE sql
    AS $$
 SELECT vendo.inittransaction(idpracownika,idcentrali,0);
$$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF (idpracownika IS NOT NULL) THEN
  PERFORM vendo.settparami('P_IDPRACOWNIKA',idpracownika);
 END IF;
 IF (idcentrali IS NOT NULL) THEN
  PERFORM vendo.settparami('FM_IDCENTRALI',idcentrali);
 END IF;
 PERFORM vendo.settparami('NOTIFYFLAG',notifyflag);
 RETURN txid_current();
END
$$;
