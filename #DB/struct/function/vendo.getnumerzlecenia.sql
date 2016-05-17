CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _idzlecenia ALIAS FOR $1;
BEGIN
 --ZL_NUMP_N_S_R_Z   = 0
 --ZL_NUMP_N_S_P_R_Z = 1
 --ZL_NUMP_NNADRZ_P  = 2
 RETURN (SELECT vendo.getNumerZlecenia(zl.zl_nrzlecenia,zl.zl_seria::text,zl.zl_rok::text,zl.zl_typ,zl.zl_rodzajnum,zl.zl_prefixparent,zl.zl_prefix) FROM tg_zlecenia AS zl WHERE zl.zl_idzlecenia=_idzlecenia LIMIT 1); 
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 zl_nrzlecenia ALIAS FOR $1;
 zl_seria ALIAS FOR $2;
 zl_rok ALIAS FOR $3;
 zl_typ ALIAS FOR $4;
 zl_rodzajnum ALIAS FOR $5;
 zl_prefixparent ALIAS FOR $6;
 zl_prefix ALIAS FOR $7;
BEGIN
 --ZL_NUMP_N_S_R_Z   = 0
 --ZL_NUMP_N_S_P_R_Z = 1
 --ZL_NUMP_NNADRZ_P  = 2
	
 IF (COALESCE(zl_rodzajnum,0)=0) THEN
  RETURN COALESCE(zl_nrzlecenia,0)||'/'||trim(zl_seria)||'/'||mylpad(zl_rok,2,'0')||'/'||vendo.getSkrotRodzajuZlecenia(zl_typ);
 END IF;
     
 zl_prefix=(CASE WHEN COALESCE(zl_prefix,'')='' THEN '' ELSE '/'||zl_prefix END);
 
 IF (zl_rodzajnum=1) THEN 
  RETURN COALESCE(zl_nrzlecenia,0)||'/'||trim(zl_seria)||zl_prefix||'/'||mylpad(zl_rok,2,'0')||'/'||vendo.getSkrotRodzajuZlecenia(zl_typ);
 END IF;
 
 zl_prefixparent=(CASE WHEN COALESCE(zl_prefixparent,'')='' THEN '' ELSE '/'||zl_prefixparent END);
  
 IF (zl_rodzajnum=2) THEN   
  RETURN COALESCE(zl_nrzlecenia,0)||'/'||trim(zl_seria)||'/'||mylpad(zl_rok,2,'0')||'/'||vendo.getSkrotRodzajuZlecenia(zl_typ)||zl_prefixparent||zl_prefix;
 END IF;
 
 RETURN '???';
END;
$_$;
