CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _kwh_idheadu ALIAS FOR $1;
 _knr_wplywmag ALIAS FOR $2;
 lp INT:=1;
 _rec RECORD;
BEGIN

 FOR _rec IN SELECT knr_idelemu FROM tr_nodrec WHERE kwh_idheadu=_kwh_idheadu AND knr_wplywmag=_knr_wplywmag ORDER BY knr_idelemu ASC
 LOOP
  UPDATE tr_nodrec SET knr_lp=lp WHERE knr_idelemu=_rec.knr_idelemu;
  lp=lp+1;
 END LOOP;

 RETURN lp;
END;
$_$;
