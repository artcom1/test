CREATE OR REPLACE FUNCTION aktywujprevnext(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _kwe_idelemu ALIAS FOR $1;
 
 _kwh_idheadu INT;
 _record      RECORD;
 _return      INT:=0;
BEGIN
 
 _kwh_idheadu=(SELECT kwh_idheadu FROM tr_kkwnod WHERE kwe_idelemu=_kwe_idelemu);
 _kwh_idheadu=(SELECT kwh_idheadu FROM tr_kkwnod WHERE kwe_idelemu=_kwe_idelemu);
 
 IF (COALESCE(_kwh_idheadu,0)=0) THEN
  RETURN -2;
 END IF;
 
 -- 6     (64) - Powiazanie tymczasowe 
 DELETE FROM tr_kkwnodprevnext WHERE kwh_idheadu=_kwh_idheadu AND knpn_flaga&(1<<5)=(1<<5); 
 -- 5     (32) - Powiazanie niewidoczne
 UPDATE tr_kkwnodprevnext SET knpn_flaga=knpn_flaga&(~(3<<0)) WHERE kwh_idheadu=_kwh_idheadu;
 
 FOR _record IN
 SELECT kwe_idelemu FROM tr_kkwnod WHERE kwh_idheadu=_kwh_idheadu AND kwe_idelemu<>_kwe_idelemu AND kwe_flaga&(1<<11)=(1<<11) 
 LOOP
  IF (COALESCE(_record.kwe_idelemu,0)>0) THEN
   _return=_return+dezaktywujPrevNext(_record.kwe_idelemu);
  END IF;
 END LOOP;
 
 RETURN _return;
END;
$_$;
