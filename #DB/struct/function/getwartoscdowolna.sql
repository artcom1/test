CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 typ ALIAS FOR $1;
 idwartoscdowolnej ALIAS FOR $2;
 id ALIAS FOR $3;
 wynik TEXT;
 BEGIN
  IF (idwartoscdowolnej<=0) THEN
   RETURN '';
  END IF;

  wynik=(SELECT mv_inputtype||':_:'||v_value FROM tb_multival JOIN ts_multivalues USING (mv_idvalue) WHERE v_type=typ AND mv_idvalue=idwartoscdowolnej AND v_id=id);

  RETURN wynik;
 END;
 $_$;
