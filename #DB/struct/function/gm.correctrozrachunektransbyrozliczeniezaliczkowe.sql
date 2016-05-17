CREATE FUNCTION correctrozrachunektransbyrozliczeniezaliczkowe(kwotawal numeric, idwaluty integer, idtrans integer, rrno integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
 r RECORD;
 ret NUMERIC:=kwotawal;
BEGIN

 FOR r IN SELECT rr.rr_kwotawal,rr.rr_idwaluty,rr.rr_iswn
          FROM kr_rozrachunki AS rr
		  WHERE rr.tr_idtrans=idtrans AND
		        rr.rr_no=rrno|(1<<8)
 LOOP
  ret=ret-(CASE WHEN r.rr_iswn=TRUE THEN r.rr_kwotawal ELSE -r.rr_kwotawal END);
  IF (r.rr_idwaluty IS DISTINCT FROM idwaluty) THEN
   RAISE EXCEPTION 'Blad walut przy rozliczaniu z faktura zaliczkowa!';
  END IF;
 END LOOP; 
 
 IF (ret=0) THEN
  RETURN 0;
 END IF;
 
 IF (ret*kwotawal<0) THEN
  RAISE EXCEPTION 'Przekroczenie granicy rozrachunku zaliczkowego!';
 END IF;

 RETURN ret;
END;
$$;
