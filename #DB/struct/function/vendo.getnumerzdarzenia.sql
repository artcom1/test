CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _idzlecenia ALIAS FOR $1;
BEGIN
 --ZL_NUMP_N_S_R_Z   = 0
 --ZL_NUMP_N_S_P_R_Z = 1
 --ZL_NUMP_NNADRZ_P  = 2
 RETURN (SELECT vendo.getNumerZdarzenia(zd.zd_numer,zd.zd_rodzaj,zd.zd_prefix) FROM tb_zdarzenia AS zd WHERE zd.zd_idzdarzenia=$1 LIMIT 1); 
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
 tmp TEXT;
BEGIN
 
 IF (COALESCE(zd_prefix,'')!='') THEN
  RETURN zd_numer::text||'/'||zd_prefix;
 END IF;
 
 tmp=(SELECT zdi_code FROM tb_zdarzeniainfo WHERE zdi_id=zd_rodzaj);
 
 if (tmp IS NOT NULL) THEN
  RETURN zd_numer::text||'/'||tmp;
 END IF;
 
 RETURN zd_numer::text;
END;
$$;
