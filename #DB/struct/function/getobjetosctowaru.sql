CREATE FUNCTION getobjetosctowaru(numeric, numeric, integer, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 ilosc ALIAS FOR $1;
 objetosc ALIAS FOR $2;
 opak1 ALIAS FOR $3;
 opak2 ALIAS FOR $4;
 wynik NUMERIC:=0;
 opakowanie RECORD;
 opakowanie2 RECORD;
 ilosc_op INT:=0;
 ilosc_niewop NUMERIC:=0;
 ilosc_op2 INT:=0;
 ilosc_opakneop2 NUMERIC:=0;
 
BEGIN
 IF (opak1=NULL) THEN
 ---nie ma podanych opakowac objetosc jest prostym ilorazem
  RETURN ilosc*objetosc;
 END IF;

 ---pobieramy rekord opakowania
 SELECT * INTO opakowanie FROM tg_jednostkialt WHERE ja_idjednostki=opak1;
 ilosc_op=Round(((ilosc*opakowanie.ja_mianownik)/opakowanie.ja_licznik)-0.5,0);

 ilosc_niewop=ilosc-(ilosc_op*opakowanie.ja_licznik)/opakowanie.ja_mianownik;

 ---liczymy objetosc wolnego asortymentu bez opakowania zbiorczego
 wynik=ilosc_niewop*objetosc;

 ---sprawdzamy czy mamy opakowanie2
 IF (opak2=NULL) THEN
  wynik=wynik+(ilosc_op*opakowanie.ja_objetosc);
  RETURN wynik;
 END IF;

 ---pobieramy opakowanie2
 SELECT * INTO opakowanie2 FROM tg_jednostkialt WHERE ja_idjednostki=opak2;

 ---liczymy ilosc opakowan2
 ilosc_op2=Round(((ilosc*opakowanie2.ja_mianownik)/opakowanie2.ja_licznik)-0.5,0);

 ---licze ilosc op ktore niezmieszcza sie w opak2
 ilosc_opakneop2=ilosc_op-((ilosc_op2*opakowanie2.ja_licznik*opakowanie.ja_mianownik)/(opakowanie2.ja_mianownik*opakowanie.ja_licznik));

 ---do objetosci dodaje objetosc opakowan2 i opakowan ktore sie niezmiescily w opakowaniach2
 wynik=wynik+(ilosc_opakneop2*opakowanie.ja_objetosc)+ilosc_op2*opakowanie2.ja_objetosc;

 RETURN wynik;
END;
$_$;
