CREATE FUNCTION renumerujlpzdarzen() RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
 id INT;
 r RECORD;
BEGIN

 WHILE TRUE=TRUE LOOP
  SELECT zd_idzdarzenia,zl_idzlecenia,zd_idparent INTO r FROM tb_zdarzenia WHERE zl_idzlecenia IS NOT NULL AND zd_lp IS NULL ORDER BY zd_idzdarzenia ASC LIMIT 1;

  IF (r.zd_idzdarzenia IS NULL) THEN
   EXIT;
  END IF;
 
  UPDATE tb_zdarzenia SET 
    zd_lp=nullZero((SELECT max(zd_lp) FROM tb_zdarzenia WHERE zl_idzlecenia=r.zl_idzlecenia AND zd_lp IS NOT NULL AND COALESCE(zd_idparent,0)=COALESCE(r.zd_idparent,0)))+1
  WHERE zd_idzdarzenia=r.zd_idzdarzenia;

  RAISE NOTICE '% %',r.zd_idzdarzenia,r.zl_idzlecenia;
 END LOOP;

 RETURN TRUE;
END;
$$;


--
--

CREATE FUNCTION renumerujlpzdarzen(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 id INT;
 r RECORD;
 _parent ALIAS FOR $1;
 rlimit int:=10000;
BEGIN


 WHILE TRUE=TRUE LOOP
  SELECT zd_idzdarzenia,zl_idzlecenia INTO r FROM tb_zdarzenia WHERE COALESCE(zd_idparent,0)=COALESCE(_parent,0) AND zl_idzlecenia IS NOT NULL AND zd_lp IS NULL ORDER BY zd_idzdarzenia ASC LIMIT 1;

  IF (r.zd_idzdarzenia IS NULL) THEN
   RETURN TRUE;
  END IF;

  IF (rlimit<=0) THEN
   RETURN FALSE;
  END IF;

  rlimit=rlimit-1;


  UPDATE tb_zdarzenia SET 
    zd_lp=nullZero((SELECT max(zd_lp) FROM tb_zdarzenia WHERE zl_idzlecenia=r.zl_idzlecenia AND zd_lp IS NOT NULL AND COALESCE(zd_idparent,0)=COALESCE(_parent,0)))+1
  WHERE zd_idzdarzenia=r.zd_idzdarzenia;

  RAISE NOTICE '% % %',r.zd_idzdarzenia,r.zl_idzlecenia,rlimit;

  PERFORM renumerujLPZdarzen(r.zd_idzdarzenia);
 END LOOP;

 RETURN TRUE;
END;
$_$;


--
--

CREATE FUNCTION renumerujlpzdarzen(integer, integer DEFAULT NULL::integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 id INT;
 r RECORD;
 _parent     ALIAS FOR $1;
 _idzlecenia ALIAS FOR $2;
 lp INT;
 rlimit int:=1000000;
BEGIN

 PERFORM doescapezdarzeniatriggers(1);

 IF (_idzlecenia IS NOT NULL) THEN
  UPDATE tb_zdarzenia SET zd_lp=NULL WHERE zl_idzlecenia=_idzlecenia;
 END IF;


 WHILE TRUE=TRUE LOOP
  SELECT zd_idzdarzenia,zl_idzlecenia INTO r 
  FROM tb_zdarzenia 
  WHERE COALESCE(zd_idparent,0)=COALESCE(_parent,0) AND 
        zl_idzlecenia IS NOT NULL AND 
		(_idzlecenia IS NULL OR zl_idzlecenia=_idzlecenia) AND
		zd_lp IS NULL 
		ORDER BY zd_idzdarzenia ASC LIMIT 1;

  IF (r.zd_idzdarzenia IS NULL) THEN
   PERFORM doescapezdarzeniatriggers(-1);
   RETURN TRUE;
  END IF;

  IF (rlimit<=0) THEN
   PERFORM doescapezdarzeniatriggers(-1);
   RETURN FALSE;
  END IF;

  rlimit=rlimit-1;

  lp=nullZero((SELECT max(zd_lp) FROM tb_zdarzenia WHERE zl_idzlecenia=r.zl_idzlecenia AND zd_lp IS NOT NULL AND COALESCE(zd_idparent,0)=COALESCE(_parent,0)))+1;

  UPDATE tb_zdarzenia SET 
    zd_lp=lp
  WHERE zd_idzdarzenia=r.zd_idzdarzenia;

  RAISE NOTICE '% % % (%) LP: %',r.zd_idzdarzenia,r.zl_idzlecenia,rlimit,r,lp;

  PERFORM renumerujLPZdarzen(r.zd_idzdarzenia,NULL);
 END LOOP;

 PERFORM doescapezdarzeniatriggers(-1);
 
 RETURN TRUE;
END;
$_$;
