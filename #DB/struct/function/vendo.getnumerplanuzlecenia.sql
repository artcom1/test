CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _idplanuzlecenia ALIAS FOR $1;
BEGIN
  RETURN (SELECT vendo.getNumerZlecenia(zl.zl_nrzlecenia,zl.zl_seria::text,zl.zl_rok::text,zl.zl_typ,zl.zl_rodzajnum,zl.zl_prefixparent,zl.zl_prefix)||'/'||pl.pz_lp FROM tg_planzlecenia pl LEFT JOIN tg_zlecenia AS zl USING(zl_idzlecenia) WHERE pl.pz_idplanu=_idplanuzlecenia LIMIT 1);
END;
$_$;
