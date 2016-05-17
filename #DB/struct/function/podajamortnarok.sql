CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 data_startam ALIAS FOR $1;
 data_startrok ALIAS FOR $2;
 data_endrok ALIAS FOR $3;
 wart_poczatkowa ALIAS FOR $4;
 wart_zdarzen ALIAS FOR $5;
 wart_przen ALIAS FOR $6;
 stawka_am ALIAS FOR $7;
 rodzaj_am ALIAS FOR $8;
 wynik NUMERIC;
 ilemies INT;
 ilemies_przen NUMERIC;
 start DATE;
 stop DATE;
BEGIN

 wynik=0;
 
 start=data_startam+('1 month'::interval);
 start=DATE_TRUNC('month', start);

 IF (rodzaj_am=0) THEN
  IF (start>=data_startrok AND start<=data_endrok) THEN
   wynik=(wart_poczatkowa+wart_zdarzen);
   return wynik;
  ELSE
   return 0;
  END IF;
 END IF;

 IF (stawka_am=0) THEN
  return 0;
 END IF;

 IF((1200/stawka_am)%1=0) THEN
  ilemies=(1200/stawka_am)::int;
 ELSE
  ilemies=(TRUNC(1200/stawka_am)+1)::int;
 END IF;

 stop=data_startam+('1 month'::interval)*(ilemies+1);

 IF (wart_przen>0) THEN
  ilemies_przen=wart_przen/(((wart_poczatkowa+wart_zdarzen)*stawka_am)/1200);
  ilemies_przen=ilemies-(TRUNC(ilemies_przen)); 
  stop=data_startam+('1 month'::interval)*(ilemies_przen+1);
 END IF;

 stop=DATE_TRUNC('month', stop);
 stop=stop-('1 day'::interval);

 IF ( stop<data_startrok OR start>data_endrok ) THEN
  return 0;
 END IF; 

 IF ( stop>=data_startrok AND stop<=data_endrok ) THEN
  stop=data_startrok-'1 day'::interval;
  ilemies=(DATE_PART('month', AGE(stop,start))+1);
  wynik=((wart_poczatkowa+wart_zdarzen)*stawka_am*ilemies)/1200;
  wynik=(wart_poczatkowa+wart_zdarzen)-wynik;
  
  IF (wart_przen>0) THEN
   return wynik-wart_przen;
  END IF;
  
  return wynik;
  
 ELSE
  IF ( start<data_startrok ) THEN
   start=data_startrok;
  END IF;
 
  stop=data_endrok;
  ilemies=(DATE_PART('month', AGE(stop,start))+1);
  wynik=((wart_poczatkowa+wart_zdarzen)*stawka_am*ilemies)/1200;
  return wynik;
 END IF;

 return wynik;

END;
$_$;
