CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
  _idplatfifo ALIAS FOR $1;
  _newvaluepln ALIAS FOR $2;
  _newwaluta ALIAS FOR $3;
  tmp NUMERIC;
  r RECORD;
  kurs MPQ;
  refto INT;
BEGIN

 --Sprawdz zaksiegowanie platnosci do ktorej odnosi sie zmiana
 SELECT kr_rozrachunki.pl_idplatnosc INTO r FROM kr_rozrachunki JOIN kh_platfifo USING (rr_idrozrachunku) WHERE po_idfifo=_idplatfifo;
 PERFORM checkZaksiegowaniePlat(r.pl_idplatnosc);

 tmp=(SELECT po_wplyw FROM kh_platfifo WHERE po_idfifo=_idplatfifo);
 IF (tmp<0) THEN
  UPDATE kh_platfifo SET po_kwotapln=_newvaluepln WHERE po_idfifo=_idplatfifo;
  RETURN TRUE;
 END IF;

 --Zezwol na przekraczanie granicy
 UPDATE kh_platfifo SET po_flaga=po_flaga|8192 WHERE po_wplyw>0 AND po_idfifo=_idplatfifo;

 -- Zrob update wartosci
 UPDATE kh_platfifo SET po_kwotapln=_newvaluepln,wl_idwaluty=COALESCE(_newwaluta,wl_idwaluty) WHERE po_idfifo=_idplatfifo;

 refto=(SELECT po_refrr FROM kh_platfifo WHERE po_idfifo=_idplatfifo);

 kurs=(SELECT calcKursWaluty(po_kwotapln,po_kwotawal,wl_idwaluty) FROM kh_platfifo WHERE po_idfifo=_idplatfifo);

--- RAISE EXCEPTION 'Nowy kurs % % %',_idplatfifo,kurs,_newvaluepln;

 FOR r IN SELECT kh_platfifo.*,kr_rozrachunki.pl_idplatnosc,rl_idrozliczenia
          FROM kh_platfifo 
	  JOIN kr_rozrachunki USING (rr_idrozrachunku) 
	  WHERE po_ref=_idplatfifo
 LOOP
  UPDATE kh_platfifo SET po_kwotapln=round(po_kwotawal*kurs,2) WHERE po_idfifo=r.po_idfifo;
  UPDATE kr_rozliczenia SET rl_flaga=rl_flaga|256 WHERE rl_idrozliczenia=r.rl_idrozliczenia;
  PERFORM checkZaksiegowaniePlat(r.pl_idplatnosc);
  RAISE NOTICE ':INV: 19,%',r.pl_idplatnosc;
 END LOOP;

 tmp=(SELECT po_pozostalopln FROM kh_platfifo WHERE po_idfifo=_idplatfifo AND po_pozostalowal=0);
 IF (tmp IS NOT NULL) THEN
  UPDATE kh_platfifo SET po_kwotapln=po_kwotapln+tmp 
  WHERE po_idfifo=(SELECT po_idfifo FROM kh_platfifo AS a 
                   WHERE a.po_ref=_idplatfifo AND
		         po_kwotapln>=-tmp
		   ORDER BY po_dataop DESC,po_idfifo DESC LIMIT 1
		  );
 END IF;

 --- Odzwol na przekraczanie granicy
 UPDATE kh_platfifo SET po_flaga=po_flaga&(~8192) WHERE po_wplyw>0 AND po_idfifo=_idplatfifo;


 RETURN TRUE; 
END;
$_$;
