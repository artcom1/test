CREATE FUNCTION trytofreepartia(scid integer, maxilosc numeric, qdiv text DEFAULT NULL::text) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
 freedIlosc   NUMERIC:=0;
 r            gms.tm_simcoll;
 s            RECORD;
 iloscRest    NUMERIC:=maxIlosc;
 iloscLocal   NUMERIC:=0;
 iloscLocalIn NUMERIC;
 iloscTmp     NUMERIC;
 oneMoreTime  BOOL:=TRUE;
 -------------------------------
 o            gms.tm_ilosci;
 orderno      INT;
 -------------------------------
 siloscwz     gms.tm_ilosci;
 riloscwz     gms.tm_ilosci;
BEGIN

 IF (iloscRest<0) THEN RETURN 0; END IF;

 PERFORM gms.disableUseSC(scid,1);

 LOOP
  oneMoreTime=FALSE;

  -------------------------------------------------------------------------------------
  SELECT * INTO r FROM gms.tm_simcoll WHERE sc_id=scid;
  IF NOT FOUND THEN
   RAISE EXCEPTION 'Blad!';
  END IF;

/*
  iloscLocal=gms.tryToFreePartiaWZ(scid,iloscRest,r);
  IF (iloscLocal>0) THEN
   freedIlosc=freedIlosc+iloscLocal;
   iloscRest=iloscRest-iloscLocal;
   CONTINUE;
  END IF;
  */
  iloscLocal=gms.podmienlokalnenielokalne(scid,iloscRest,r,qdiv);
  IF (iloscLocal>0) THEN
   freedIlosc=freedIlosc+iloscLocal;
   iloscRest=iloscRest-iloscLocal;
   CONTINUE;
  END IF;

  iloscLocal=gms.podmiennotnullnull(scid,iloscRest,r,qdiv);
  IF (iloscLocal>0) THEN
   freedIlosc=freedIlosc+iloscLocal;
   iloscRest=iloscRest-iloscLocal;
   CONTINUE;
  END IF;


  EXIT WHEN TRUE;
 END LOOP;

 PERFORM gms.disableUseSC(scid,-1);

 RETURN freedIlosc;
END;
$$;
