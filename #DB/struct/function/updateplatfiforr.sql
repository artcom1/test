CREATE FUNCTION updateplatfiforr(integer, integer, numeric, numeric, integer, boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idrozrachunku ALIAS FOR $1;
 _idplatnosci   ALIAS FOR $2;
 _kwotawal      ALIAS FOR $3;
 _kwotapln      ALIAS FOR $4;
 _idwaluty      ALIAS FOR $5;
 _useit         ALIAS FOR $6;
 r RECORD;
 pozostalowal   NUMERIC;
 wasAnyFIFO     BOOL:=FALSE;
BEGIN

 IF (_useit=FALSE) THEN
  DELETE FROM kh_platfifo WHERE rr_idrozrachunku=_idrozrachunku;
  RETURN TRUE;
 END IF;

 ---Gdy nie ma platnosci
 IF (_idplatnosci IS NULL) THEN

  SELECT * INTO r FROM kh_platfifo WHERE rr_idrozrachunku=_idrozrachunku;

  IF (r.po_idfifo IS NOT NULL) THEN
   UPDATE kh_platfifo SET po_kwotawal=_kwotawal,po_kwotapln=_kwotapln WHERE rr_idrozrachunku=_idrozrachunku;
   RETURN TRUE;
  END IF;

  INSERT INTO kh_platfifo
   (wl_idwaluty,po_wplyw,po_kwotawal,po_kwotapln,rr_idrozrachunku)
  VALUES
   (_idwaluty,1,_kwotawal,_kwotapln,_idrozrachunku);

  RETURN TRUE;
 END IF;
    
 pozostalowal=_kwotawal;

 ----Gdy jest platnosc - przekopiuj z 
 FOR r IN SELECT src.po_idfifo AS idsrc,dst.po_idfifo AS iddst,
                 src.po_kwotawal AS kwotawalsrc,dst.po_kwotawal AS kwotawaldst,
                 src.po_kwotapln AS kwotaplnsrc,dst.po_kwotapln AS kwotaplndst,
		 src.wl_idwaluty AS idwalutysrc,dst.wl_idwaluty AS idwalutydst
          FROM (SELECT * FROM kh_platfifo WHERE kh_platfifo.pl_idplatnosc=_idplatnosci AND kh_platfifo.po_wplyw<0) AS src
	  FULL JOIN (SELECT * FROM kh_platfifo WHERE kh_platfifo.rr_idrozrachunku=_idrozrachunku AND po_wplyw>0) AS dst 
	  ON (src.po_idfifo=dst.po_refrr)
	  ORDER BY src.po_idfifo ASC NULLS LAST
 LOOP

  IF (r.idsrc IS NOT NULL) THEN
   wasAnyFIFO=TRUE;
  END IF;

  IF (r.iddst IS NULL) THEN
   INSERT INTO kh_platfifo
    (wl_idwaluty,po_wplyw,po_kwotawal,po_kwotapln,po_refrr,rr_idrozrachunku)
   VALUES
    (r.idwalutysrc,1,r.kwotawalsrc,r.kwotaplnsrc,r.idsrc,_idrozrachunku);
   pozostalowal=pozostalowal-r.kwotawalsrc;
   CONTINUE;
  END IF;

  IF (r.idsrc IS NULL) AND (wasAnyFIFO=TRUE) THEN
   ---Utworz pomocnicza tabele
   CREATE TEMP TABLE kh_platfifo_saved AS SELECT * FROM kh_platfifo WHERE po_ref=r.iddst AND rl_idrozliczenia IS NOT NULL;
   ---Skasuj zalezne rekordy
   DELETE FROM kh_platfifo WHERE po_ref=r.iddst AND rl_idrozliczenia IS NOT NULL;
   ---Skasuj wlasciwy rekord
   DELETE FROM kh_platfifo WHERE po_idfifo=r.iddst;
   ---Porusz rozliczenia
   UPDATE kr_rozliczenia SET rl_flaga=rl_flaga|256 WHERE rl_idrozliczenia IN (SELECT rl_idrozliczenia FROM kh_platfifo_saved);
   ---Skasuj pomocnicza tabele
   DROP TABLE kh_platfifo_saved;
   CONTINUE;
  END IF;

  IF (r.kwotawalsrc<>r.kwotawaldst) OR (r.kwotaplnsrc<>r.kwotaplndst) THEN
   UPDATE kh_platfifo SET
    po_kwotawal=r.kwotawalsrc,po_kwotapln=r.kwotaplnsrc
   WHERE po_idfifo=r.idsrc;
   pozostalowal=pozostalowal-r.kwotawalsrc;
   CONTINUE;
  END IF;

  pozostalowal=pozostalowal-r.kwotawalsrc;
 END LOOP;

 IF (pozostalowal<>0) THEN
  IF (wasAnyFIFO=FALSE) THEN
   RETURN updatePlatFIFORR(_idrozrachunku,NULL,_kwotawal,_kwotapln,_idwaluty,_useit);
  END IF;
  RAISE EXCEPTION 'Nie mozna utworzyc rekordu FIFO walut % % %',pozostalowal,_idplatnosci,_idrozrachunku;
 END IF;

 RETURN TRUE;
END;
$_$;
