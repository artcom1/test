CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN getMinusPlatFifo($1,$2,$3,$4,$5,NULL,NULL,FALSE);
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _flag ALIAS FOR $6;
BEGIN

 RAISE NOTICE 'Get for %',$1;

 --Brak kantoru walut - wyczysc
 IF (((_flag>>19)&3)=0) OR (_flag&64=64) THEN
  PERFORM clearPlatFifo($1);
  RETURN NULL;
 END IF;

 --Platnosc nie jest zamknieta (a powinna byc)
 IF (((_flag>>19)&3)=2) AND (((_flag>>11)&3)<>0) THEN
  PERFORM clearPlatFifo($1);
  RETURN NULL;
 END IF;

 --Moze byc w buforze a nie jest
 IF (((_flag>>19)&3)=2) AND (((_flag>>11)&3) NOT IN (0,1)) THEN
  PERFORM clearPlatFifo($1);
  RETURN NULL;
 END IF;

 RETURN getMinusPlatFifo($1,$2,$3,$4,$5,NULL,NULL,(COALESCE(_flag,0)&(1<<30))!=0);
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 rest          NUMERIC;
 wynik         NUMERIC:=0;
 tmp           NUMERIC;
 tmppln        NUMERIC;
 r             RECORD;
 q             TEXT;
BEGIN
 rest=_kwota;

 IF (_idwaluty=1) THEN
  ---Skasuj wszystkie
  DELETE FROM kh_platfifo WHERE (_idrl IS NULL AND pl_idplatnosc=_idplatnosc) OR (_idrl IS NOT NULL AND rl_idrozliczenia=_idrl AND rr_idrozrachunku=_idrr);
  RETURN _kwota;
 END IF;

 ---Skasuj te ktore nie pasuja
 DELETE FROM kh_platfifo WHERE (_idrl IS NULL AND pl_idplatnosc=_idplatnosc AND (bk_idbanku<>_idbanku OR wl_idwaluty<>_idwaluty OR po_wplyw<>-1 OR po_datakursu<_data)) OR
                               (_idrl IS NOT NULL AND rl_idrozliczenia=_idrl AND rr_idrozrachunku=_idrr AND (wl_idwaluty<>_idwaluty OR po_wplyw<>-1));

 IF (rest=0) THEN RETURN wynik; END IF;

 ---Szukaj po istniejacych
 FOR r IN SELECT * FROM kh_platfifo WHERE (_idrl IS NULL AND pl_idplatnosc=_idplatnosc) OR (_idrl IS NOT NULL AND rl_idrozliczenia=_idrl AND rr_idrozrachunku=_idrr)
 LOOP
  tmp=min(rest,r.po_kwotawal);

  IF (tmp=r.po_kwotawal) THEN
   wynik=wynik+r.po_kwotapln;
  ELSE
   tmppln=floorRoundMax(tmp*round(r.po_kwotapln/r.po_kwotawal,4),r.po_kwotapln);
   wynik=wynik+tmppln;

   IF (tmp=0) THEN
    DELETE FROM kr_platfifo WHERE po_idfifo=r.po_idfifo;
   ELSE
    UPDATE kr_platfifo SET po_kwotawal=tmp,po_kwotapln=tmppln WHERE po_idfifo=r.po_idfifo;
   END IF;

  END IF;

  rest=rest-tmp;
 END LOOP;

 IF (rest=0) THEN RETURN wynik; END IF;

 IF (_uselifo=TRUE) THEN
  q=$$SELECT * 
     FROM kh_platfifo 
	 WHERE po_wplyw=1 AND wl_idwaluty= $$ || _idwaluty || $$ AND po_pozostalowal>0 AND 
           (
 		    ($$ || gm.toString(_idrl) || $$ IS NULL AND bk_idbanku=$$ || gm.toString(_idbanku) || $$ AND po_datakursu<='$$ ||COALESCE(_data,'1970-01-01'::date) || $$ ') OR
		    ($$ || gm.toString(_idrl) || $$ IS NOT NULL AND rr_idrozrachunku=$$ || gm.toString(_idrr) || $$)
           )
     ORDER BY po_datakursu DESC,po_dataop DESC,po_idfifo$$;
 ELSE 
  q=$$SELECT * 
     FROM kh_platfifo 
	 WHERE po_wplyw=1 AND wl_idwaluty= $$ || _idwaluty || $$ AND po_pozostalowal>0 AND 
           (
 		    ($$ || gm.toString(_idrl) || $$ IS NULL AND bk_idbanku=$$ || gm.toString(_idbanku) || $$ AND po_datakursu<='$$ || COALESCE(_data,'1970-01-01'::date) || $$ ') OR
		    ($$ || gm.toString(_idrl) || $$ IS NOT NULL AND rr_idrozrachunku=$$ || gm.toString(_idrr) || $$)
           )
     ORDER BY po_datakursu,po_dataop,po_idfifo$$;
 END IF;	 
 
 ---Szukaj nowych
 FOR r IN EXECUTE q
 LOOP
  tmp=min(rest,r.po_pozostalowal);

  IF (tmp<>0) THEN

   IF (tmp=r.po_pozostalowal) THEN
    tmppln=r.po_pozostalopln;
   ELSE
    tmppln=floorRoundMax(tmp*round(r.po_kwotapln/r.po_kwotawal,4),r.po_pozostalopln);
   END IF;

   INSERT INTO kh_platfifo
    (pl_idplatnosc,bk_idbanku,wl_idwaluty,po_wplyw,po_kwotawal,po_kwotapln,po_ref,rr_idrozrachunku,rl_idrozliczenia)
   VALUES
    (_idplatnosc,_idbanku,_idwaluty,-1,tmp,tmppln,r.po_idfifo,_idrr,_idrl);

   rest=rest-tmp;
   wynik=wynik+tmppln;
  END IF;

  IF (rest=0) THEN 
   RETURN wynik; 
  END IF;
 END LOOP;

 IF (rest<>0) THEN
  RAISE EXCEPTION '24|%:%:%:%:%|Brak waluty w kantorze ',_idplatnosc,_idbanku,rest,_idwaluty,_idrr;
 END IF;

 RETURN wynik;
END;
$_$;
