CREATE FUNCTION updaterozliczeniarr(integer, numeric, numeric, mpq) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idrozrachunku ALIAS FOR $1;
 _wartoscwal    ALIAS FOR $2;
 _wartoscpln    ALIAS FOR $3;
 _kurswal       ALIAS FOR $4;
 r              RECORD;
 restwal        NUMERIC;
 restpln        NUMERIC;
 tmpwal         NUMERIC;
 tmppln         NUMERIC;
 wsp            INT:=1;
 wspl           INT:=1;
BEGIN
 restwal=_wartoscwal;
 restpln=_wartoscpln;
 
 IF (restwal<0) THEN
  wsp=-1;
  restwal=-restwal;
  restpln=-restpln;
 END IF;

 FOR r IN SELECT rl.*,rr.rr_flaga,rr.rr_idwaluty
          FROM kr_rozliczenia AS rl 
          JOIN kr_rozrachunki AS rr ON (rr_idrozrachunku=rr_idrozrachunkul) 
	  WHERE rr_idrozrachunkul=_idrozrachunku AND rl_idrozliczenia_rk IS NULL 
	  ORDER BY sign(rl_wartoscwall*wsp) ASC,(CASE WHEN rl_wartoscwall*wsp>0 THEN rl_idrozliczenia::numeric ELSE abs(rl_wartoscwall) END) ASC,rl_idrozliczenia
 LOOP
  wspl=wsp;
  tmpwal=r.rl_wartoscwall*wspl;
  IF (r.rr_flaga&(1<<22)<>0) THEN
   IF (tmpwal<0) THEN
    RAISE EXCEPTION 'Bledny rozrachunek o % %',r.rl_wartoscwall,wsp;
   END IF;
   tmppln=getminusplatfifoRL(r.rl_idrozliczenia,_idrozrachunku,tmpwal,r.rr_idwaluty);
  ELSE
   IF (tmpwal<0) THEN
    tmpwal=-tmpwal;
	wspl=-wspl;
    tmppln=round(tmpwal*_kurswal,2);
   ELSE
    tmppln=floorRoundMax(tmpwal*_kurswal,restpln);
   END IF;  
  END IF;


  IF (tmpwal=restwal) THEN
   tmppln=restpln;
  END IF;

  ---IF (tmppln<>(r.rl_wartoscplnl+r.rl_roznicekursowel)*wsp) THEN
  UPDATE kr_rozliczenia SET rl_wartoscplnl=(tmppln-rl_roznicekursowel*wspl)*wspl WHERE rl_idrozliczenia=r.rl_idrozliczenia;
  ---END IF;

  restwal=restwal-tmpwal*wspl*wsp;
  restpln=restpln-tmppln*wspl*wsp;
 END LOOP;

 FOR r IN SELECT rl.*,rr.rr_flaga,rr.rr_idwaluty
       FROM kr_rozliczenia AS rl 
       JOIN kr_rozrachunki AS rr ON (rr_idrozrachunku=rr_idrozrachunkur) 
       WHERE rr_idrozrachunkur=_idrozrachunku AND rl_idrozliczenia_rk IS NULL 
	   ORDER BY sign(rl_wartoscwalr*wsp) ASC,(CASE WHEN rl_wartoscwalr*wsp>0 THEN rl_idrozliczenia::numeric ELSE abs(rl_wartoscwalr) END) ASC,rl_idrozliczenia
 LOOP
  wspl=wsp;
  tmpwal=r.rl_wartoscwalr*wspl;
    
  IF (r.rr_flaga&(1<<22)<>0) THEN  
   IF (tmpwal<0) THEN
    RAISE EXCEPTION 'Bledny rozrachunek p % % %',r.rl_idrozliczenia,r.rl_wartoscwalr,wspl;
   END IF;     
   tmppln=getminusplatfifoRL(r.rl_idrozliczenia,_idrozrachunku,tmpwal,r.rr_idwaluty);   
  ELSE
   IF (tmpwal<0) THEN
    tmpwal=-tmpwal;
	wspl=-wspl;
    tmppln=round(tmpwal*_kurswal,2);
   ELSE
    tmppln=floorRoundMax(tmpwal*_kurswal,restpln);
   END IF;
  END IF;

  RAISE NOTICE 'Mam % % %',tmpwal,tmppln,restpln;

  IF (tmpwal=restwal) THEN
   tmppln=restpln;
  END IF;

  ---IF (tmppln<>(r.rl_wartoscplnr+r.rl_roznicekursower)*wsp) THEN
  UPDATE kr_rozliczenia SET rl_wartoscplnr=(tmppln-rl_roznicekursower*wspl)*wspl WHERE rl_idrozliczenia=r.rl_idrozliczenia;
  ---END IF;

  restwal=restwal-tmpwal*wspl*wsp;
  restpln=restpln-tmppln*wspl*wsp;
 END LOOP;

 IF (restwal<0) THEN
  RAISE NOTICE 'Rozliczono za duzo w stosunku do wartosci dokumentu';
 END IF;
    
 RETURN TRUE;
END;
$_$;
