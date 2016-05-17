CREATE FUNCTION zmienprorytetkkw(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _typ_kkw INT; ---jaki rodzaj kkw (produkcyjne czy serwisowe)
 _kwh_idheadu ALIAS FOR $1;
 typ ALIAS FOR $2;
 kkw RECORD;
 kkw2 RECORD;
 typprorytetu INT;
BEGIN
  typprorytetu=(SELECT cf_defvalue::int FROM tc_config WHERE cf_tabela='KKW_PRORYTET_TYP' LIMIT 1 OFFSET 0);

  SELECT zl_idzlecenia, thg_idgrupy, kwh_prorytet, kwh_idheadu, th_rodzaj INTO kkw FROM tr_kkwhead WHERE kwh_idheadu=_kwh_idheadu;

  _typ_kkw=kkw.th_rodzaj;

  IF (typ) THEN
   IF (typprorytetu=0) THEN
    SELECT kwh_idheadu, kwh_prorytet INTO kkw2 FROM tr_kkwhead WHERE NullZero(zl_idzlecenia)=NullZero(kkw.zl_idzlecenia) AND kwh_prorytet<kkw.kwh_prorytet AND kwh_prorytet>0 AND th_rodzaj=_typ_kkw ORDER BY kwh_prorytet DESC LIMIT 1 OFFSET 0;
   END IF;
   IF (typprorytetu=1) THEN 
    SELECT kwh_idheadu, kwh_prorytet INTO kkw2 FROM tr_kkwhead WHERE  kwh_prorytet<kkw.kwh_prorytet AND kwh_prorytet>0 AND th_rodzaj=_typ_kkw ORDER BY kwh_prorytet DESC LIMIT 1 OFFSET 0;
   END IF;
   IF (typprorytetu=2) THEN 
    SELECT kwh_idheadu, kwh_prorytet INTO kkw2 FROM tr_kkwhead WHERE  thg_idgrupy=kkw.thg_idgrupy AND kwh_prorytet<kkw.kwh_prorytet AND kwh_prorytet>0 AND th_rodzaj=_typ_kkw ORDER BY kwh_prorytet DESC LIMIT 1 OFFSET 0;
   END IF;
   IF (typprorytetu=3 OR typprorytetu=4) THEN
    SELECT kwh_idheadu, kwh_prorytet INTO kkw2 FROM tr_kkwhead WHERE thg_idgrupy=kkw.thg_idgrupy AND NullZero(zl_idzlecenia)=NullZero(kkw.zl_idzlecenia) AND kwh_prorytet<kkw.kwh_prorytet AND kwh_prorytet>0 AND th_rodzaj=_typ_kkw ORDER BY kwh_prorytet DESC LIMIT 1 OFFSET 0;
   END IF;
  ELSE
   IF (typprorytetu=0) THEN
    SELECT kwh_idheadu, kwh_prorytet INTO kkw2 FROM tr_kkwhead WHERE NullZero(zl_idzlecenia)=NullZero(kkw.zl_idzlecenia) AND kwh_prorytet>kkw.kwh_prorytet AND kwh_prorytet>0 AND th_rodzaj=_typ_kkw ORDER BY kwh_prorytet ASC LIMIT 1 OFFSET 0;
   END IF;
   IF (typprorytetu=1) THEN 
    SELECT kwh_idheadu, kwh_prorytet INTO kkw2 FROM tr_kkwhead WHERE  kwh_prorytet>kkw.kwh_prorytet AND kwh_prorytet>0 AND th_rodzaj=_typ_kkw ORDER BY kwh_prorytet ASC LIMIT 1 OFFSET 0;
   END IF;
   IF (typprorytetu=2) THEN 
    SELECT kwh_idheadu, kwh_prorytet INTO kkw2 FROM tr_kkwhead WHERE  thg_idgrupy=kkw.thg_idgrupy AND kwh_prorytet>kkw.kwh_prorytet AND kwh_prorytet>0 AND th_rodzaj=_typ_kkw ORDER BY kwh_prorytet ASC LIMIT 1 OFFSET 0;
   END IF;
   IF (typprorytetu=3 OR typprorytetu=4) THEN
    SELECT kwh_idheadu, kwh_prorytet INTO kkw2 FROM tr_kkwhead WHERE thg_idgrupy=kkw.thg_idgrupy AND NullZero(zl_idzlecenia)=NullZero(kkw.zl_idzlecenia) AND kwh_prorytet>kkw.kwh_prorytet AND kwh_prorytet>0 AND th_rodzaj=_typ_kkw ORDER BY kwh_prorytet ASC LIMIT 1 OFFSET 0;
   END IF;
  END IF;

  IF (kkw2.kwh_idheadu>0) THEN
  ---znalazlem zlecenie do wymiany prorytetami, robie zamiane
   UPDATE tr_kkwhead SET kwh_prorytet=kkw2.kwh_prorytet WHERE kwh_idheadu=kkw.kwh_idheadu;
   UPDATE tr_kkwhead SET kwh_prorytet=kkw.kwh_prorytet WHERE kwh_idheadu=kkw2.kwh_idheadu;

   return kkw2.kwh_idheadu;
  END IF;
  RETURN 0;
END;
$_$;
