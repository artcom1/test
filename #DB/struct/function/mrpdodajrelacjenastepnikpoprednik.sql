CREATE FUNCTION mrpdodajrelacjenastepnikpoprednik(integer, integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _th_idtechnologii ALIAS FOR $1;
 _the_idelem ALIAS FOR $2;
 _the_lp ALIAS FOR $3;
 _th_flaga ALIAS FOR $4;
 operacja_poprzednik RECORD;
 _thpn_idelem INT;
 _thpn_flaga INT:=0;
BEGIN
 ---sprawdzamy czy juz przypadkiem nie ma dodanej relacji nastepnik-poprzednik
 _thpn_idelem=(SELECT thpn_idelem FROM tr_technoprevnext WHERE the_idnext=_the_idelem LIMIT 1);
 IF (_thpn_idelem>0) THEN 
  return _thpn_idelem;
 END IF;

 -----szukamy operacji o lp wiekszym o 1 od aktulnego  
 SELECT the_idelem,the_x_licznik,the_x_mianownik,the_x_wspc  INTO operacja_poprzednik FROM tr_technoelem WHERE th_idtechnologii=_th_idtechnologii AND the_lp=(_the_lp-1);
 IF (operacja_poprzednik is NULL) THEN
 ---nie znalazlem operacji do ktorej dodac relacje wiec wychodze bez dodawania
  return NULL;
 END IF;

 ---dodajemy relacje
 _thpn_flaga=1;
 INSERT INTO tr_technoprevnext
  (th_idtechnologii,the_idprev,the_idnext,thpn_x_licznik,thpn_x_mianownik,thpn_flaga,thpn_x_wspc)
 VALUES
  (_th_idtechnologii,operacja_poprzednik.the_idelem,_the_idelem,COALESCE(operacja_poprzednik.the_x_licznik,1),COALESCE(operacja_poprzednik.the_x_mianownik,1),_thpn_flaga,COALESCE(operacja_poprzednik.the_x_wspc,0));
   
  --- Wez ID stworzonego ruchu
 _thpn_flaga=(SELECT currval('tr_technoprevnext_s'));

 return _thpn_flaga;
END;
$_$;
