CREATE FUNCTION inittransaction(idpracownika integer, idcentrali integer) RETURNS bigint
    LANGUAGE sql
    AS $$
 SELECT vendo.inittransaction(idpracownika,idcentrali,0);
$$;


--
--

CREATE FUNCTION inittransaction(idpracownika integer, idcentrali integer, notifyflag integer) RETURNS bigint
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
