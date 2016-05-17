CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
 DECLARE
    efekt    INT;
    kwota    numeric;
   
 BEGIN

  NEW.pl_wartosczl=NEW.pl_wartosc;
 RETURN NEW;
 END;
$$;
