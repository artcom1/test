CREATE FUNCTION getidklientaforkonto(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idkonta ALIAS FOR $1;
 r RECORD;
 ret INT;
BEGIN
 
 FOR r IN SELECT DISTINCT k_idklienta FROM kh_zapisyelem join tg_transakcje USING (tr_idtrans) WHERE kt_idkontawn=_idkonta AND zp_kwota=tr_dozaplaty
 LOOP
 
  IF (ret IS NOT NULL) THEN
   IF (ret<>r.k_idklienta) THEN
    RAISE EXCEPTION 'Nie mozna wyznaczyc jednoznacznie klienta dla konta % jest % i % ',_idkonta,ret,r.k_idklienta;
   END IF;
  END IF;
 
  ret=r.k_idklienta;
 END LOOP;

 FOR r IN SELECT DISTINCT k_idklienta FROM kh_zapisyelem join tg_transakcje USING (tr_idtrans) WHERE kt_idkontama=_idkonta AND zp_kwota=tr_dozaplaty
 LOOP
 
  IF (ret IS NOT NULL) THEN
   IF (ret<>r.k_idklienta) THEN
    RAISE EXCEPTION 'Nie mozna wyznaczyc jednoznacznie klienta dla konta % jest % i % ',_idkonta,ret,r.k_idklienta;
   END IF;
  END IF;
 
  ret=r.k_idklienta;
 END LOOP;

 FOR r IN SELECT DISTINCT k_idklienta FROM kh_zapisyelem join kh_platnosci USING (pl_idplatnosc) WHERE kt_idkontawn=_idkonta
 LOOP
 
  IF (ret IS NOT NULL) THEN
   IF (ret<>r.k_idklienta) THEN
    RAISE EXCEPTION 'Nie mozna wyznaczyc jednoznacznie klienta dla konta % jest % i % ',_idkonta,ret,r.k_idklienta;
   END IF;
  END IF;
 
  ret=r.k_idklienta;
 END LOOP;

 FOR r IN SELECT DISTINCT k_idklienta FROM kh_zapisyelem join kh_platnosci USING (pl_idplatnosc) WHERE kt_idkontama=_idkonta
 LOOP
 
  IF (ret IS NOT NULL) THEN
   IF (ret<>r.k_idklienta) THEN
    RAISE EXCEPTION 'Nie mozna wyznaczyc jednoznacznie klienta dla konta % jest % i % ',_idkonta,ret,r.k_idklienta;
   END IF;
  END IF;
 
  ret=r.k_idklienta;
 END LOOP;

 IF (ret IS NULL) THEN
  ret=(SELECT ro_idroku-1 FROM kh_konta WHERE kt_idkonta=_idkonta);
  ret=(SELECT ro_idroku FROM kh_lata WHERE ro_idroku=ret);
  ret=(SELECT kt_idkonta FROM kh_konta WHERE ro_idroku=ret AND numerKonta(kt_prefix,kt_numer,kt_zerosto)=(SELECT numerKonta(kt_prefix,kt_numer,kt_zerosto) FROM kh_konta WHERE kt_idkonta=_idkonta));
  IF (ret IS NOT NULL) THEN
   RAISE NOTICE 'Szukam w poprzednim roku %',ret;
   ret=getIDKlientaForKonto(ret);
  END IF;
 END IF;

 RETURN ret;
END;
$_$;
