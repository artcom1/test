CREATE FUNCTION dodajstatystykezapytan(integer, integer, text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 _ttw_idtowaru ALIAS FOR $1;
 _p_idpracownika ALIAS FOR $2;
 _komentarz ALIAS FOR $3;
 stat RECORD;
 def_stat TEXT;
BEGIN
 def_stat=(SELECT cf_defvalue FROM tc_config WHERE cf_tabela='STAT_ZAP_JED');

 IF (def_stat='1') THEN 
  ---statystyka jedna dla procownika dziennie 
    SELECT * INTO stat FROM tg_statystykazapytan WHERE ttw_idtowaru=_ttw_idtowaru AND p_idpracownika=_p_idpracownika AND sz_data=now()::date AND sz_komentarz=_komentarz ;
    IF (stat.sz_idstatystyki>0) THEN
      return 0;
    END IF;
    INSERT INTO tg_statystykazapytan (ttw_idtowaru, p_idpracownika, sz_komentarz) VALUES (_ttw_idtowaru, _p_idpracownika, _komentarz);
    RETURN 1;
 ELSE 
   IF (def_stat='2') THEN
   --statystyka jedna na firme dziennie
    SELECT * INTO stat FROM tg_statystykazapytan WHERE ttw_idtowaru=_ttw_idtowaru AND sz_data=now()::date AND sz_komentarz=_komentarz ;
    IF (stat.sz_idstatystyki>0) THEN
      return 0;
    END IF;
    INSERT INTO tg_statystykazapytan (ttw_idtowaru, p_idpracownika, sz_komentarz) VALUES (_ttw_idtowaru, _p_idpracownika, _komentarz);
    RETURN 1;
   ELSE
   --kazda statystyke odnotowujemy
    SELECT * INTO stat FROM tg_statystykazapytan WHERE ttw_idtowaru=_ttw_idtowaru AND p_idpracownika=_p_idpracownika AND sz_data=now()::date AND sz_komentarz = _komentarz;
    IF (stat.sz_idstatystyki>0) THEN
      UPDATE tg_statystykazapytan SET sz_ilosc=sz_ilosc+1 WHERE  sz_idstatystyki=stat.sz_idstatystyki;
      RAISE NOTICE 'update';
    ELSE
     INSERT INTO tg_statystykazapytan (ttw_idtowaru, p_idpracownika, sz_komentarz) VALUES (_ttw_idtowaru, _p_idpracownika, _komentarz);
    END IF;
   END IF;
 END IF;

 RETURN 1;
END;$_$;
