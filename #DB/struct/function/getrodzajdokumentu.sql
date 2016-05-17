CREATE FUNCTION getrodzajdokumentu(integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE 
  rodzaj TEXT;
BEGIN
  IF ($1=0) THEN
    rodzaj='Przyjecie zewnetrzne';
  ELSE 
   IF ($1=1) THEN
    rodzaj='Faktura VAT';
   ELSE 
    IF ($1=2) THEN
     rodzaj='Wydanie zewnetrzne';
    ELSE 
     IF ($1=3) THEN
      rodzaj='Faktura ProForma';
     ELSE 
      IF ($1=4) THEN
       rodzaj='Rozchod wewnetrzny';
      ELSE 
       IF ($1=5) THEN
        rodzaj='Przychod wewnetrzny';
       ELSE
        IF ($1=6) THEN
         rodzaj='Przesuniecie miedzymagazynowe -';
        ELSE
 IF ($1=7) THEN
          rodzaj='Paragon fiskalny';
         ELSE 
  IF ($1=8) THEN
           rodzaj='Przesyniecie miedzymagazynowe +';
          ELSE 
   IF ($1=10) THEN
            rodzaj='Przyjecie zewnetrzne korekta';
           ELSE
    IF ($1=11) THEN
             rodzaj='Faktura VAT korekta';
            ELSE
     IF ($1=12) THEN
              rodzaj='Wydanie zewnetrzne korekta';
             ELSE 
      IF ($1=13) THEN
               rodzaj='Faktura ProForma korekta';
              ELSE 
       IF ( $1=14) THEN
                rodzaj='Rozchod wewnetrzny korekta';
               ELSE 
        IF ($1=15) THEN
                 rodzaj='Przychod wewnetrzny korekta';
                ELSE
 IF ($1=16) THEN
                   rodzaj='Przesuniecie miedzymagazynowe - korekta';
                 ELSE 
  IF ($1=17) THEN
                   rodzaj='Paragon fiskalny korekta';
                  ELSE 
   IF ($1=18) THEN
                    rodzaj='Przesuniecie miedzymagazynowe + korekta';
                   END IF;
  END IF;
 END IF;
END IF;
       END IF;
              END IF;
     END IF;
    END IF;
   END IF;
  END IF; 
 END IF;
END IF;
       END IF;
      END IF;
     END IF;
    END IF;
   END IF;
  END IF;
  RETURN rodzaj;
END;$_$;
