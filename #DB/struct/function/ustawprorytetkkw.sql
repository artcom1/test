CREATE FUNCTION ustawprorytetkkw(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _kwh_idheadu ALIAS FOR $1;
 _new_priorytet INT:=$2;
 kkw RECORD;
 typprorytetu INT;
 max_prorytet INT;
BEGIN
  typprorytetu=(SELECT cf_defvalue::int FROM tc_config WHERE cf_tabela='KKW_PRORYTET_TYP' LIMIT 1 OFFSET 0);

  SELECT zl_idzlecenia, thg_idgrupy, kwh_prorytet, kwh_idheadu, th_rodzaj INTO kkw FROM tr_kkwhead WHERE kwh_idheadu=_kwh_idheadu;

  IF (typprorytetu=0) THEN
   max_prorytet := (SELECT kwh_prorytet FROM tr_kkwhead WHERE NullZero(zl_idzlecenia)=NullZero(kkw.zl_idzlecenia) AND kwh_prorytet IS NOT NULL AND th_rodzaj=kkw.th_rodzaj ORDER BY kwh_prorytet DESC LIMIT 1 OFFSET 0);
  END IF;
  IF (typprorytetu=1) THEN 
   max_prorytet := (SELECT kwh_prorytet FROM tr_kkwhead WHERE kwh_prorytet IS NOT NULL AND th_rodzaj=kkw.th_rodzaj  ORDER BY kwh_prorytet DESC LIMIT 1 OFFSET 0);
  END IF;
  IF (typprorytetu=2) THEN 
   max_prorytet := (SELECT kwh_prorytet FROM tr_kkwhead WHERE thg_idgrupy=kkw.thg_idgrupy AND kwh_prorytet IS NOT NULL AND th_rodzaj=kkw.th_rodzaj  ORDER BY kwh_prorytet DESC LIMIT 1 OFFSET 0);
  END IF;
  IF (typprorytetu=3 OR typprorytetu=4) THEN
   max_prorytet := (SELECT kwh_prorytet FROM tr_kkwhead WHERE thg_idgrupy=kkw.thg_idgrupy AND NullZero(zl_idzlecenia)=NullZero(kkw.zl_idzlecenia) AND kwh_prorytet IS NOT NULL AND th_rodzaj=kkw.th_rodzaj  ORDER BY kwh_prorytet DESC LIMIT 1 OFFSET 0);
  END IF;

  IF (_new_priorytet <= 0) THEN
    _new_priorytet := 1;
  END IF;
  
  IF (_new_priorytet > max_prorytet) THEN
    _new_priorytet := max_prorytet;
  END IF;

  IF (_new_priorytet < kkw.kwh_prorytet) THEN
   IF (typprorytetu=0) THEN
    UPDATE tr_kkwhead SET kwh_prorytet=kwh_prorytet+1 WHERE NullZero(zl_idzlecenia)=NullZero(kkw.zl_idzlecenia) AND kwh_prorytet>=_new_priorytet AND kwh_prorytet<kkw.kwh_prorytet AND kwh_prorytet IS NOT NULL  AND th_rodzaj=kkw.th_rodzaj ;
   END IF;
   IF (typprorytetu=1) THEN 
    UPDATE tr_kkwhead SET kwh_prorytet=kwh_prorytet+1 WHERE kwh_prorytet>=_new_priorytet AND kwh_prorytet<kkw.kwh_prorytet AND kwh_prorytet IS NOT NULL AND th_rodzaj=kkw.th_rodzaj ;
   END IF;
   IF (typprorytetu=2) THEN 
    UPDATE tr_kkwhead SET kwh_prorytet=kwh_prorytet+1 WHERE thg_idgrupy=kkw.thg_idgrupy AND kwh_prorytet>=_new_priorytet AND kwh_prorytet<kkw.kwh_prorytet AND kwh_prorytet IS NOT NULL AND th_rodzaj=kkw.th_rodzaj ;
   END IF;
   IF (typprorytetu=3 OR typprorytetu=4) THEN
    UPDATE tr_kkwhead SET kwh_prorytet=kwh_prorytet+1 WHERE thg_idgrupy=kkw.thg_idgrupy AND NullZero(zl_idzlecenia)=NullZero(kkw.zl_idzlecenia) AND kwh_prorytet>=_new_priorytet AND kwh_prorytet<kkw.kwh_prorytet AND kwh_prorytet IS NOT NULL AND th_rodzaj=kkw.th_rodzaj ;
   END IF;
  ELSE
   IF (typprorytetu=0) THEN
    UPDATE tr_kkwhead SET kwh_prorytet=kwh_prorytet-1 WHERE NullZero(zl_idzlecenia)=NullZero(kkw.zl_idzlecenia) AND kwh_prorytet<=_new_priorytet AND kwh_prorytet>kkw.kwh_prorytet AND kwh_prorytet IS NOT NULL AND th_rodzaj=kkw.th_rodzaj ;
   END IF;
   IF (typprorytetu=1) THEN 
    UPDATE tr_kkwhead SET kwh_prorytet=kwh_prorytet-1 WHERE kwh_prorytet<=_new_priorytet AND kwh_prorytet>kkw.kwh_prorytet AND kwh_prorytet IS NOT NULL AND th_rodzaj=kkw.th_rodzaj ;
   END IF;
   IF (typprorytetu=2) THEN 
    UPDATE tr_kkwhead SET kwh_prorytet=kwh_prorytet-1 WHERE thg_idgrupy=kkw.thg_idgrupy AND kwh_prorytet<=_new_priorytet AND kwh_prorytet>kkw.kwh_prorytet AND kwh_prorytet IS NOT NULL AND th_rodzaj=kkw.th_rodzaj ;
   END IF;
   IF (typprorytetu=3 OR typprorytetu=4) THEN
    UPDATE tr_kkwhead SET kwh_prorytet=kwh_prorytet-1 WHERE thg_idgrupy=kkw.thg_idgrupy AND NullZero(zl_idzlecenia)=NullZero(kkw.zl_idzlecenia) AND kwh_prorytet<=_new_priorytet AND kwh_prorytet>kkw.kwh_prorytet AND kwh_prorytet IS NOT NULL AND th_rodzaj=kkw.th_rodzaj ;
   END IF;
  END IF;

  UPDATE tr_kkwhead SET kwh_prorytet=_new_priorytet WHERE kwh_idheadu=kkw.kwh_idheadu;

  RETURN kkw.kwh_idheadu;
END;
$_$;
