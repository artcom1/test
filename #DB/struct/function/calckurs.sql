CREATE FUNCTION calckurs(licznik numeric, mianownik numeric, podstawa integer) RETURNS mpq
    LANGUAGE plpgsql
    AS $$
DECLARE
 ret     MPQ;
 adddokl INT:=0;
BEGIN

 IF (podstawa IS NULL) THEN
  RAISE EXCEPTION 'Podstawa kalkulacji kursu nie moze byc NULL';
 END IF;
 
 IF ((mianownik=0) OR (mianownik IS NULL)) THEN
  RETURN NULL;
 END IF;

 LOOP
  EXIT WHEN podstawa<=1;
  adddokl=adddokl+1;
  podstawa=podstawa/10;
 END LOOP;


 RETURN round(licznik/mianownik,4+adddokl)::mpq;
END;
$$;
