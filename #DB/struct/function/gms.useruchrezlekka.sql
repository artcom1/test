CREATE FUNCTION useruchrezlekka(simid integer, idtowmag integer, idpartiipz integer, idpartiil integer, ilosc numeric, tonullpartia boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
 iloscrest NUMERIC:=ilosc;
 ilosclocal NUMERIC;
 r RECORD;
BEGIN
 
 FOR r IN 
  SELECT * FROM gms.tm_simcoll
  WHERE sc_sid=vendo.tv_mysessionpid() AND sc_simid=simid AND
        sc_idtowmag=idtowmag AND
	sc_idpartiipz=idpartiipz AND
	(sc_ilosc[2]).pnull+(sc_ilosc[2]).p>0
 LOOP
  EXIT WHEN iloscrest<=0;

---  RAISE NOTICE 'Mam cos % NULL % nie NULL %',iloscrest,r.sc_ilosc[2]_pnull,r.sc_ilosc[2]_p;

  IF (tonullpartia=TRUE) THEN
   ilosclocal=min(iloscrest,(r.sc_ilosc[2]).pnull);
  ELSE
   ilosclocal=min(iloscrest,(r.sc_ilosc[2]).p);
  END IF;

 INSERT INTO gms.tm_touse
 VALUES
  (DEFAULT,
   DEFAULT,
   simid,
   idtowmag,
   NULL,
   idpartiipz,
   r.rc_idruchupz,
   NULL,
   0,
   0,
   NULL,
   0,
   0,
   idpartiil,
   (CASE WHEN tonullpartia=TRUE THEN ilosclocal ELSE 0 END),
   (CASE WHEN tonullpartia=FALSE THEN ilosclocal ELSE 0 END)
  );  

  iloscrest=iloscrest-ilosclocal;
 END LOOP;

 IF (iloscrest>0) THEN
  RAISE EXCEPTION 'Blad symulacji (zostalo % dla partii PZ % %) symulacja %',iloscrest,idpartiipz,tonullpartia,simid;
 END IF;


 RETURN TRUE;
END;
$$;
