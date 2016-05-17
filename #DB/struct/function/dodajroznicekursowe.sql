CREATE FUNCTION dodajroznicekursowe(integer, integer, numeric) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idrozliczenia ALIAS FOR $1;
 _idrozrachunku ALIAS FOR $2;
 _wartoscpln    ALIAS FOR $3;
 rl RECORD;
 rr RECORD;
 rk RECORD;
 id INT;
BEGIN
 --- Usun rozliczenie roznic kursowych
 IF (_wartoscpln=0) THEN
  DELETE FROM kr_rozliczenia WHERE rl_idrozliczenia_rk=_idrozliczenia;
  RETURN NULL;
 END IF;

 SELECT * INTO rl FROM kr_rozliczenia WHERE rl_idrozliczenia=_idrozliczenia;
 SELECT * INTO rr FROM kr_rozrachunki WHERE rr_idrozrachunku=_idrozrachunku;
 SELECT * INTO rk FROM kr_rozliczenia JOIN kr_rozrachunki ON (rr_idrozrachunku=rr_idrozrachunkul) WHERE rl_idrozliczenia_rk=_idrozliczenia;

 IF (rk.rr_idrozrachunku IS NULL) THEN
  id=(nextval('kr_rozrachunki_s'));
  INSERT INTO kr_rozrachunki
   (rr_idrozrachunku,k_idklienta,rr_idwaluty,
    rr_kwotawal,rr_wartoscpln,
    rr_wartoscpozwal,rr_wartoscpozpln,
    rr_iswn,rr_isbufor,rr_isnormal,
    rr_datadokumentu,rr_dataplatnosci,
    rr_flaga, fm_idcentrali)
  VALUES
   (id,rr.k_idklienta,1,
    -_wartoscpln,-_wartoscpln,
    -_wartoscpln,-_wartoscpln,
    (CASE WHEN -_wartoscpln>0 THEN TRUE ELSE FALSE END),false,true,
    rl.rl_datamax,rl.rl_datarozliczenia,
    3|64|(1<<13),rr.fm_idcentrali);
  INSERT INTO kr_rozliczenia
   (rr_idrozrachunkul,rr_idrozrachunkur,
    rl_wartoscwall,rl_wartoscwalr,
    rl_wartoscplnl,rl_wartoscplnr,
    rl_datamax,rl_datarozliczenia,p_idpracownika,
    rl_rozliczenieserial,rl_idrozliczenia_rk)
  VALUES
   (id,_idrozrachunku,
    -_wartoscpln,0,
    -_wartoscpln,_wartoscpln,
    rl.rl_datamax,rl.rl_datarozliczenia,rl.p_idpracownika,
    rl.rl_rozliczenieserial,_idrozliczenia);

  RETURN id;
 END IF;

 IF (abs(rk.rr_kwotawal)>abs(_wartoscpln)) THEN
  UPDATE kr_rozliczenia SET
   rl_wartoscwall=-_wartoscpln,
   rl_wartoscplnl=-_wartoscpln,
   rl_wartoscplnr=_wartoscpln,
   rl_datarozliczenia=rl.rl_datarozliczenia,
   rl_datamax=rl.rl_datamax,
   rr_idrozrachunkur=_idrozrachunku
  WHERE rl_idrozliczenia=rk.rl_idrozliczenia AND 
   (rl_wartoscwall<>-_wartoscpln OR
   rl_wartoscplnl<>-_wartoscpln OR
   rl_wartoscplnr<>_wartoscpln OR
   rl_datarozliczenia<>rl.rl_datarozliczenia OR
   rl_datamax<>rl.rl_datamax OR
   rr_idrozrachunkur<>_idrozrachunku);
 END IF;

 UPDATE kr_rozrachunki SET 
  k_idklienta=rr.k_idklienta,
  rr_kwotawal=-_wartoscpln,
  rr_wartoscpln=-_wartoscpln,
  rr_wartoscpozwal=rr_wartoscpozwal+(-_wartoscpln-rr_kwotawal),
  rr_wartoscpozpln=rr_wartoscpozwal+(-_wartoscpln-rr_wartoscpln),
  rr_iswn=(CASE WHEN -_wartoscpln>0 THEN TRUE ELSE FALSE END),
  rr_datadokumentu=rl.rl_datamax,
  rr_dataplatnosci=rl.rl_datarozliczenia
 WHERE rr_idrozrachunku=rk.rr_idrozrachunku AND 
  (k_idklienta<>rr.k_idklienta OR
   rr_kwotawal<>-_wartoscpln OR
   rr_wartoscpln<>-_wartoscpln OR
   rr_wartoscpozwal<>rr_wartoscpozwal+(-_wartoscpln-rr_kwotawal) OR
   rr_wartoscpozpln<>rr_wartoscpozwal+(-_wartoscpln-rr_wartoscpln) OR
   rr_iswn<>(CASE WHEN -_wartoscpln>0 THEN TRUE ELSE FALSE END) OR
   rr_datadokumentu<>rl.rl_datamax OR
   rr_dataplatnosci<>rl.rl_datarozliczenia);
  

 IF (abs(rk.rr_kwotawal)<=abs(_wartoscpln)) THEN
  UPDATE kr_rozliczenia SET
   rl_wartoscwall=-_wartoscpln,
   rl_wartoscplnl=-_wartoscpln,
   rl_wartoscplnr=_wartoscpln,
   rl_datamax=rl.rl_datamax,
   rl_datarozliczenia=rl.rl_datarozliczenia,
   rr_idrozrachunkur=_idrozrachunku
  WHERE rl_idrozliczenia=rk.rl_idrozliczenia AND 
   (rl_wartoscwall<>-_wartoscpln OR
   rl_wartoscplnl<>-_wartoscpln OR
   rl_wartoscplnr<>_wartoscpln OR
   rl_datarozliczenia<>rl.rl_datarozliczenia OR
   rl_datamax<>rl.rl_datamax OR
   rr_idrozrachunkur<>_idrozrachunku);
 END IF;
 
 RETURN rl.rl_idrozliczenia;
END;
$_$;
