CREATE FUNCTION simplyrozlicz(integer, integer, numeric, numeric, integer DEFAULT 0) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _rr1      ALIAS FOR $1;
 _rr2      ALIAS FOR $2;
 _kwotawal ALIAS FOR $3;
 _kwotapln ALIAS FOR $4;
 _flag     ALIAS FOR $5;
 retid     INT;
 kwotal    NUMERIC;
 idprac    INT;
BEGIN
 retid=nextval('kr_rozrachunki_s');

 kwotal=(SELECT rr_wartoscpozwal FROM kr_rozrachunki WHERE rr_idrozrachunku=_rr1);

 idprac=vendo.getTParamI('P_IDPRACOWNIKA');

 IF (idprac IS NULL) THEN
  RAISE EXCEPTION 'Nie ustawiono pracownika';
 END IF;

 INSERT INTO kr_rozliczenia
  (rl_idrozliczenia,
   rr_idrozrachunkul,rr_idrozrachunkur,
   rl_wartoscwall,rl_wartoscwalr,
   rl_wartoscplnl,rl_wartoscplnr,
   rl_flaga,
   p_idpracownika)
  VALUES
   (retid,
    _rr1,_rr2,
    (CASE WHEN kwotal<0 THEN -_kwotawal ELSE _kwotawal END),(CASE WHEN kwotal<0 THEN _kwotawal ELSE -_kwotawal END),
    (CASE WHEN kwotal<0 THEN -_kwotapln ELSE _kwotapln END),(CASE WHEN kwotal<0 THEN _kwotapln ELSE -_kwotapln END),
    _flag,
    idprac
   );
 RETURN retid;
END;
$_$;


SET search_path = vendo, pg_catalog;
