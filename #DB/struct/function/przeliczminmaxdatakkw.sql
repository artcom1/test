CREATE FUNCTION przeliczminmaxdatakkw(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _kwh_idheadu ALIAS FOR $1;
 r RECORD;
 d TIMESTAMP;
 dp TIMESTAMP;
 tmp TEXT;
BEGIN

 DELETE FROM tr_wt_tmp;

 ---Utworz drzewko
 PERFORM CreateWszerzTree(_kwh_idheadu);

 dp='1979-11-29';
 FOR r IN SELECT * FROM tr_wt_tmp ORDER BY seq ASC
 LOOP 
  d=minTS(r.minplan,
          COALESCE(
	   (SELECT max(maxTS(COALESCE(kwe_datamin,'1979-11-29'),datanext)) 
	    FROM tr_kkwnod AS nd 
	    JOIN tr_wt_tmp ON (kwe_idelemu=ide) 
	    JOIN tr_kkwnodprevnext AS pn ON (nd.kwe_idelemu=pn.kwe_idprev) 
	    WHERE pn.kwe_idnext=r.ide AND pn.kwh_idheadu=_kwh_idheadu AND kwe_datamin IS NOT NULL LIMIT 1)
	   ,'1979-11-29')
	  );
---  d=maxTS(d,dp);
  UPDATE tr_kkwnod SET kwe_datamin=d WHERE (d<>kwe_datamin OR kwe_datamin IS NULL) AND kwe_idelemu=r.ide;
--  dp=d;
 END LOOP;

 dp='2079-11-29';
 FOR r IN SELECT * FROM tr_wt_tmp ORDER BY seq DESC
 LOOP 
  d=maxTS(r.maxplan,
          COALESCE(
	    (SELECT min(minTS(COALESCE(kwe_datamax,'2079-11-29'),datanext))
	     FROM tr_kkwnod AS nd 
	     JOIN tr_wt_tmp ON (kwe_idelemu=ide) 
	     JOIN tr_kkwnodprevnext AS pn ON (nd.kwe_idelemu=pn.kwe_idnext) 
	     WHERE pn.kwe_idprev=r.ide AND pn.kwh_idheadu=_kwh_idheadu AND kwe_datamax IS NOT NULL LIMIT 1)
	    ,'2079-11-29')
	   );
--  d=minTS(d,dp);
  UPDATE tr_kkwnod SET kwe_datamax=d WHERE (d<>kwe_datamax OR kwe_datamax IS NULL) AND kwe_idelemu=r.ide;
--  dp=d;
 END LOOP;


 RETURN TRUE;
END
$_$;
