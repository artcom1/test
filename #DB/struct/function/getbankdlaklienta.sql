CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idklienta ALIAS FOR $1;
 _idmagazynu ALIAS FOR $2;
 _idwaluty ALIAS FOR $3;
BEGIN
 RETURN getBankDlaKlienta((SELECT fm_idcentrali FROM tg_magazyny WHERE tmg_idmagazynu=_idmagazynu),_idklienta,_idmagazynu,_idwaluty);
END;$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idcentrali ALIAS FOR $1;
 _idklienta ALIAS FOR $2;
 _idmagazynu ALIAS FOR $3;
 _idwaluty ALIAS FOR $4;
 ret INT;
BEGIN
 
 ---Najpierw szukaj dla klienta i wskazanej waluty
 ret=(SELECT br.bk_idbanku FROM tb_bankirel AS br JOIN ts_banki AS bk USING (bk_idbanku) WHERE br.k_idklienta=_idklienta AND bk.wl_idwaluty=_idwaluty AND br_flaga&2=0 AND br_flaga&1=0 AND bk_flaga&1=0 AND bk_type IN (1,8) AND bk.fm_idcentrali=_idcentrali ORDER BY br_priorytet ASC LIMIT 1);
 IF (ret IS NOT NULL) THEN RETURN ret; END IF;

 --Potem dla magazynu i wskazanej waluty
 IF (_idmagazynu IS NOT NULL) THEN 
  ret=(SELECT br.bk_idbanku FROM tb_bankirel AS br JOIN ts_banki AS bk USING (bk_idbanku) WHERE br.tmg_idmagazynu=_idmagazynu AND bk.wl_idwaluty=_idwaluty AND br_flaga&2=0 AND br_flaga&1=0 AND bk_flaga&1=0 AND bk_type IN (1) AND bk.fm_idcentrali=_idcentrali ORDER BY br_priorytet ASC LIMIT 1);
  IF (ret IS NOT NULL) THEN RETURN ret; END IF;
 END IF;

 --Potem dla wskazanej waluty
 ret=(SELECT bk_idbanku FROM ts_banki AS bk WHERE bk.wl_idwaluty=_idwaluty AND bk_flaga&1=0 AND bk_type IN (1) AND bk.fm_idcentrali=_idcentrali ORDER BY bk_priorytet ASC LIMIT 1);
 IF (ret IS NOT NULL) THEN RETURN ret; END IF;

 --Potem dla klienta bez wskazanej waluty
 ret=(SELECT br.bk_idbanku FROM tb_bankirel AS br JOIN ts_banki AS bk USING (bk_idbanku) WHERE br.k_idklienta=_idklienta AND br_flaga&1=0 AND br_flaga&2=0 AND bk_flaga&1=0 AND bk_type IN (1,8) AND bk.fm_idcentrali=_idcentrali ORDER BY br_priorytet ASC LIMIT 1);
 IF (ret IS NOT NULL) THEN RETURN ret; END IF;

 --Potem dla magazynu bez wskazanej waluty
 IF (_idmagazynu IS NOT NULL) THEN 
  ret=(SELECT br.bk_idbanku FROM tb_bankirel AS br JOIN ts_banki AS bk USING (bk_idbanku) WHERE br.tmg_idmagazynu=_idmagazynu AND br_flaga&1=0 AND br_flaga&2=0 AND bk_flaga&1=0 AND bk_type IN (1) AND bk.fm_idcentrali=_idcentrali ORDER BY br_priorytet ASC LIMIT 1);
  IF (ret IS NOT NULL) THEN RETURN ret; END IF;
 END IF;

 --Potem bez wskazanej waluty
 ret=(SELECT bk_idbanku FROM ts_banki AS bk WHERE bk_flaga&1=0 AND bk_type IN (1) AND bk.fm_idcentrali=_idcentrali ORDER BY bk_priorytet ASC LIMIT 1);
 IF (ret IS NOT NULL) THEN RETURN ret; END IF;
    
 RETURN ret;
END
$_$;
