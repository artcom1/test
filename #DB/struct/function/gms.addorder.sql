CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (ov>=0) AND (ov<=2) THEN
  INSERT INTO gms.tm_simorder
   (so_id,
    sc_id,
    so_ordertype,
    so_orderno,
    so_ilosci[0],
    so_ilosci[1],
    so_ilosci[2],
    so_ilosc,
	so_qdiv
   )
  VALUES
  (DEFAULT,
   scid,
   oType,
   oNo,
   (CASE WHEN ov=0 THEN gms.narrow(o) ELSE (0,0,0,0)::gms.tm_ilosci END),
   (CASE WHEN ov=1 THEN gms.narrow(o) ELSE (0,0,0,0)::gms.tm_ilosci END),
   (CASE WHEN ov=2 THEN gms.narrow(o) ELSE (0,0,0,0)::gms.tm_ilosci END),
   ilosc,
   qdiv
  );
  RETURN currval('gms.tm_simorder_s');
 END IF;

 RAISE EXCEPTION 'Blad order';
 RETURN NULL;
END
$$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (ov>=0) AND (ov<=2) THEN
  INSERT INTO gms.tm_simorder
   (so_id,
    sc_id,
    so_ordertype,
    so_orderno,
    so_ilosci[0],
    so_ilosci[1],
    so_ilosci[2],
    so_ilosc,
	so_qdiv
   )
  VALUES
  (DEFAULT,
   scid,
   oType,
   oNo,
   (CASE WHEN ov=0 THEN gms.narrow(o) ELSE (0,0,0,0)::gms.tm_ilosci END)+
   (CASE WHEN ovo=0 THEN gms.narrow(oo) ELSE (0,0,0,0)::gms.tm_ilosci END),
   (CASE WHEN ov=1 THEN gms.narrow(o) ELSE (0,0,0,0)::gms.tm_ilosci END)+
   (CASE WHEN ovo=1 THEN gms.narrow(oo) ELSE (0,0,0,0)::gms.tm_ilosci END),
   (CASE WHEN ov=2 THEN gms.narrow(o) ELSE (0,0,0,0)::gms.tm_ilosci END)+
   (CASE WHEN ovo=2 THEN gms.narrow(oo) ELSE (0,0,0,0)::gms.tm_ilosci END),
   ilosc,
   qdiv
  );
  RETURN currval('gms.tm_simorder_s');
 END IF;

 RAISE EXCEPTION 'Blad order';
 RETURN NULL;
END
$$;
