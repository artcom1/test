CREATE FUNCTION insertupdatewynagrodzenieczastkowe(integer, integer, integer, integer, numeric, numeric, numeric, numeric, numeric, text, date, boolean, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN insertUpdateWynagrodzenieCzastkowe($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,FALSE);
END;
$_$;


--
--

CREATE FUNCTION insertupdatewynagrodzenieczastkowe(integer, integer, integer, integer, numeric, numeric, numeric, numeric, numeric, text, date, boolean, integer, boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _iddokumentu   ALIAS FOR $1;
 _idkkw         ALIAS FOR $2;
 _idpracownika  ALIAS FOR $3;
 _hashcode      ALIAS FOR $4;
 _value1        ALIAS FOR $5;
 _value2        ALIAS FOR $6;
 _value3        ALIAS FOR $7;
 _value4        ALIAS FOR $8;
 _value5        ALIAS FOR $9;
 _valuetxt      ALIAS FOR $10;
 _date1         ALIAS FOR $11;
 _bduplicate    ALIAS FOR $12;    --- Blokada duplikatow - true - z blokada
 _fm_idcentrali ALIAS FOR $13;
 _istmp         ALIAS FOR $14;
 id INT;
 flaga INT:=0;
BEGIN
  
  id=(SELECT wnd_idwynagrodzenia FROM tg_wynagrodzeniadok WHERE kwh_idheadu=_idkkw AND tr_idtrans=_iddokumentu AND p_idpracownika=_idpracownika AND wnd_hashcode=_hashcode AND wnd_bduplicate IS NOT NULL AND fm_idcentrali=_fm_idcentrali ORDER BY wnd_flaga&2 ASC LIMIT 1);
  
  IF (_bduplicate=FALSE) THEN
   flaga=flaga|2;
  END IF;

  IF (id IS NULL) THEN

   INSERT INTO tg_wynagrodzeniadok
    (kwh_idheadu,tr_idtrans,p_idpracownika,wnd_hashcode,wnd_flaga,wnd_value1,wnd_value2,wnd_value3,wnd_value4,wnd_value5,wnd_valuetxt,wnd_date1, fm_idcentrali, wnd_istmp)
   VALUES
    (_idkkw,_iddokumentu,_idpracownika,_hashcode,flaga,_value1,_value2,_value3,_value4,_value5,_valuetxt,_date1,_fm_idcentrali,_istmp);
   
   RETURN currval('tg_wynagrodzenia_s');
  ELSE   
   flaga=flaga|1;   ---Informacja o zmianie

   UPDATE tg_wynagrodzeniadok SET
    wnd_value1=_value1,
    wnd_value2=_value2,
    wnd_value3=_value3,
    wnd_value4=_value4,
    wnd_value5=_value5,
    wnd_valuetxt=_valuetxt,
    wnd_date1=_date1,
    wnd_datawyliczenia=now(),
    wnd_flaga=(wnd_flaga&(~2))|flaga,
    wnd_istmp=_istmp
   WHERE
    wnd_idwynagrodzenia=id;

   RETURN id;
  END IF;
       
 RETURN NULL;
END
$_$;
