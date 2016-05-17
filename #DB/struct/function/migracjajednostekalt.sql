CREATE FUNCTION migracjajednostekalt(tg_jednostkialt, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 ja ALIAS FOR $1;
 tjn_idjedn ALIAS FOR $2;
 ja_idjednostki_znaleziona INT;
 jedn_alt_od_usuniecia BOOL:=FALSE;
BEGIN 
 --- 1. Sprawdzma, czy mam klienta, jesli nie to nie mam co robic
 IF (COALESCE(ja.k_idklientfor,0)=0) THEN
  RETURN 0; -- Wlasciciwe ze wzgledu na warunki wykonania funkcji nigdy nie powinienem tu wejsc, ale lepiej sie zabezpieczyc
 END IF;
 
 --- 1.5 Sprzwdzam jeszcze czy jednostka alt nie jest domyslna o przeliczniku 1/1
 IF (ja.tjn_idjednostkialt=tjn_idjedn AND ja.ja_licznik=1 AND ja.ja_mianownik=1) THEN 
  PERFORM trySetCharakterystykaDlaKlienta(NULL, ja);
  
  UPDATE tg_towary SET ttw_idopakowania=NULL WHERE ttw_idopakowania=ja.ja_idjednostki;
  UPDATE tg_towary SET ttw_idopakowania2=NULL WHERE ttw_idopakowania2=ja.ja_idjednostki;	 
  UPDATE tg_inwdupusty SET iu_idjednostki=NULL WHERE iu_idjednostki=ja.ja_idjednostki;
  UPDATE tg_inwdupusty SET iu_idopakowania=NULL WHERE iu_idopakowania=ja.ja_idjednostki;
   
  DELETE FROM tg_jednostkialt WHERE ja_idjednostki=ja.ja_idjednostki;
  RETURN 2;
 END IF;
 
 --- 2. Szukam w jednostkach alternatywnych tego towaru podobnych pod wzgledem: 
 ---  Jednostki podstawowej, Licznika, Mianownika
 ---  I klient jest pusty
 ja_idjednostki_znaleziona = 
 (SELECT ja_idjednostki FROM tg_jednostkialt
 WHERE 
 ttw_idtowaru=ja.ttw_idtowaru AND 
 tjn_idjednostkialt=ja.tjn_idjednostkialt AND 
 ja_licznik=ja.ja_licznik AND 
 ja_mianownik=ja.ja_mianownik AND
 ja_idjednostki<>ja.ja_idjednostki AND
 k_idklientfor IS NULL
 ORDER BY ja_idjednostki ASC
 LIMIT 1);
 
 IF (ja_idjednostki_znaleziona IS NOT NULL) THEN
 --- 3. Jesli mam juz taka podpinam sie do niej a stara jedn alt usuwam
  ---IF ((ja.ja_flaga&(1<<0))=(1<<0)) THEN -- 3.1. Jesli byla globalnie uzywana zmieniam przypisanie w miejscach gdzie mogla wystapic
   UPDATE tg_towary SET ttw_idopakowania=ja_idjednostki_znaleziona WHERE ttw_idopakowania=ja.ja_idjednostki;
   UPDATE tg_towary SET ttw_idopakowania2=ja_idjednostki_znaleziona WHERE ttw_idopakowania2=ja.ja_idjednostki;	 
   UPDATE tg_inwdupusty SET iu_idjednostki=ja_idjednostki_znaleziona WHERE iu_idjednostki=ja.ja_idjednostki;
   UPDATE tg_inwdupusty SET iu_idopakowania=ja_idjednostki_znaleziona WHERE iu_idopakowania=ja.ja_idjednostki;
  ---END IF;
  jedn_alt_od_usuniecia=TRUE;
 ELSE
 --- 4. Jesli nie mam podpinam sie do niej i ustawiam dopowiednie flagi i nulluje klienta
  ja_idjednostki_znaleziona=ja.ja_idjednostki;
  jedn_alt_od_usuniecia=FALSE;
 END IF;
   
 PERFORM trySetCharakterystykaDlaKlienta(ja_idjednostki_znaleziona, ja);
   
 IF (jedn_alt_od_usuniecia) THEN
  DELETE FROM tg_jednostkialt WHERE ja_idjednostki=ja.ja_idjednostki; 
 END IF;
 
 RETURN 1;
END
$_$;
