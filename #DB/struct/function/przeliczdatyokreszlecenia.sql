CREATE FUNCTION przeliczdatyokreszlecenia(integer, integer, integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _zl_idzlecenia ALIAS FOR $1;
 _zd_idzdarzenia ALIAS FOR $2;
 _kwh_idheadu ALIAS FOR $3;
 r RECORD;
 drz TIMESTAMP;
 dzz TIMESTAMP;

BEGIN

 SELECT min(zd_datarozpoczecia) AS zd_datarozpoczecia, max(zd_datazakonczenia) AS zd_datazakonczenia INTO r FROM tb_zdarzenia WHERE zl_idzlecenia=_zl_idzlecenia AND zd_idzdarzenia!=NullZero(_zd_idzdarzenia::numeric);

 drz=r.zd_datarozpoczecia;
 dzz=r.zd_datazakonczenia;

RAISE NOTICE 'UAK - ZLECENIE !!!! % % % %',drz, dzz, _zl_idzlecenia, _zd_idzdarzenia;

 SELECT min(COALESCE(kwh_dataplanstart,kwh_datarozp)::timestamp) AS datastart, max(COALESCE(kwh_dataplanstop,kwh_datazak)::timestamp) AS datastop INTO r FROM tr_kkwhead WHERE zl_idzlecenia=_zl_idzlecenia AND kwh_idheadu!=NullZero(_kwh_idheadu::numeric);

 IF (drz>r.datastart) THEN
  drz=r.datastart;
 END IF;

 IF (dzz<r.datastop) THEN
  dzz=r.datastop;
 END IF;

RAISE NOTICE 'UAK - ZLECENIE !!!! % %  ',drz, dzz;

 UPDATE tg_zlecenia SET zl_dataroz_zdarzenie_kkw=drz, zl_datazak_zdarzenie_kkw=dzz WHERE zl_idzlecenia=_zl_idzlecenia;


 RETURN TRUE;
END
$_$;
