CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 pz_flaga    ALIAS FOR $1;
 ojciecwyk   ALIAS FOR $2;
 ojciectyp   ALIAS FOR $3;
 ojcieczak   ALIAS FOR $4;
 ojcieckoop  ALIAS FOR $5;
 newflaga  INT:=0;
BEGIN

 newflaga=pz_flaga;
 if (ojciecwyk!=0) THEN
  newflaga=newflaga|(1<<22);
 ELSE
  newflaga=newflaga&(~(1<<22));
 END IF;

 if ( ojcieczak!=0 OR ojciectyp=0 ) THEN
  newflaga=newflaga|(1<<26);
 ELSE
  newflaga=newflaga&(~(1<<26));
 END IF;
 
 if ((ojcieckoop!=0 OR ojciectyp=(3<<24)) AND ojciectyp<>(1<<24)) THEN  
  newflaga=newflaga|(1<<30);
 ELSE
  newflaga=newflaga&(~(1<<30));
 END IF;

 RETURN newflaga;
END;
$_$;
