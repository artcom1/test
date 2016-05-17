CREATE FUNCTION ustawieniewykdyspozycji(_dyspozycjamag tr_dyspozycjamag) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
 _rec RECORD;
BEGIN

 SELECT 
 count(*) AS ilosc, max(knw_idelemu) AS knw_idelemu
 INTO _rec
 FROM tr_kkwnodwyk 
 WHERE kwe_idelemu=_dyspozycjamag.kwe_idelemu 
 GROUP BY kwe_idelemu;
 
 IF (_rec.ilosc<>1) THEN
  RETURN NULL;
 END IF;
  
 UPDATE tr_dyspozycjamag SET knw_idelemu=_rec.knw_idelemu WHERE dmag_iddyspozycji=_dyspozycjamag.dmag_iddyspozycji; 
 RETURN _rec.knw_idelemu;
END;
$$;
