CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _typ_kkw ALIAS FOR $1;   -----typ kkw produkcyjne lub serwisowe
 _zl_idzlecenia ALIAS FOR $2;
 _thg_idgrupy ALIAS FOR $3;
 _centrala ALIAS FOR $4;
 prorytet INT:=1;
 kkw RECORD;
 _zl_id INT;
 query TEXT;
 typprorytetu INT;
BEGIN
 _zl_id=_zl_idzlecenia;
 IF (_zl_idzlecenia<0) THEN
  _zl_id=0;
 END IF;

 typprorytetu=(SELECT cf_defvalue::int FROM tc_config WHERE cf_tabela='KKW_PRORYTET_TYP' LIMIT 1 OFFSET 0);
 query='SELECT kwh_idheadu FROM tr_kkwhead WHERE (kwh_flaga&3)=0 ';

 IF (typprorytetu=0 OR typprorytetu=3 OR typprorytetu=4) THEN ---tam gdzie do prorytetu wchodzi zlecenie
  query=query||'AND NullZero(zl_idzlecenia)=NullZero('||_zl_id||')'; 
 END IF;

 IF (typprorytetu=2 OR typprorytetu=3 OR typprorytetu=4) THEN ---tam gdzie do prorytetu wchodzi grupa technologii
  IF (_thg_idgrupy>0) THEN
   query=query||' AND thg_idgrupy='||_thg_idgrupy;
  END IF;
 END IF;

 query=query||' AND th_rodzaj='||_typ_kkw;

 IF (_centrala IS NOT NULL) THEN
   query = query || ' AND fm_idcentrali=' || _centrala;
 END IF;

 ---dodajemy sortowanie zalezne od rodzaju prorytetow
 IF (typprorytetu=0 OR typprorytetu=1 ) THEN
  query=query||'ORDER BY kwh_prorytet ASC, kwh_idheadu ASC';
 END IF;

 IF (typprorytetu=2 OR typprorytetu=3 OR typprorytetu=4) THEN 
  query=query||'ORDER BY thg_idgrupy ASC, kwh_prorytet ASC, kwh_idheadu ASC';
 END IF;

 FOR kkw IN EXECUTE query
 LOOP
   UPDATE tr_kkwhead SET kwh_prorytet=prorytet WHERE kwh_idheadu=kkw.kwh_idheadu;
   prorytet=1+prorytet;
 END LOOP;
 RETURN 1;
END;
$_$;
