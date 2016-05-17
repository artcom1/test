CREATE FUNCTION setkursplatnosci(integer, mpq, integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
  _idplatnosc ALIAS FOR $1;
  _newkurs ALIAS FOR $2;
  _newwaluta ALIAS FOR $3;
  tmp NUMERIC;
  r RECORD;
BEGIN

 PERFORM checkZaksiegowaniePlat(_idplatnosc);

 tmp=(SELECT pl_wplyw FROM kh_platnosci WHERE pl_idplatnosc=_idplatnosc);
 --- Dla wyplat nie bawimy sie z FIFO - robimy po prostu UPDATE
 IF (tmp<0) THEN
  UPDATE kh_platnosci SET wl_przelicznik=_newkurs,wl_idwaluty=COALESCE(_newwaluta,wl_idwaluty) WHERE pl_idplatnosc=_idplatnosc;

  FOR r IN SELECT s.po_idfifo,s.po_kwotawal,s.wl_idwaluty,rr.rr_wartoscpln
           FROM kh_platfifo AS s 
 	   JOIN kr_rozrachunki AS rr USING (rr_idrozrachunku)
 	   WHERE rr.pl_idplatnosc=_idplatnosc
	         AND s.po_ref IS NULL
		 AND s.po_refrr IS NULL
  LOOP
   PERFORM setkursplatfiforr(r.po_idfifo,abs(r.rr_wartoscpln),_newwaluta);
  END LOOP;

  RETURN TRUE;
 END IF;
 
 --- Zezwol na przekraczanie granicy
 UPDATE kh_platfifo SET po_flaga=po_flaga|8192 WHERE po_wplyw>0 AND pl_idplatnosc=_idplatnosc;

 --- Zmien walute i kurs
 UPDATE kh_platnosci SET wl_przelicznik=_newkurs,wl_idwaluty=COALESCE(_newwaluta,wl_idwaluty) WHERE pl_idplatnosc=_idplatnosc;

 FOR r IN SELECT * FROM kh_platfifo WHERE po_ref=(SELECT po_idfifo FROM kh_platfifo WHERE pl_idplatnosc=_idplatnosc) AND po_ref IS NOT NULL
 LOOP
  UPDATE kh_platfifo SET po_kwotapln=round(po_kwotawal*_newkurs,2) WHERE po_idfifo=r.po_idfifo;
  PERFORM checkZaksiegowaniePlat(r.pl_idplatnosc);
  RAISE NOTICE ':INV: 19,%',r.pl_idplatnosc;
 END LOOP;

 tmp=(SELECT po_pozostalopln FROM kh_platfifo WHERE pl_idplatnosc=_idplatnosc AND po_pozostalowal=0);
 IF (tmp IS NOT NULL) THEN
  UPDATE kh_platfifo SET po_kwotapln=po_kwotapln+tmp 
  WHERE po_idfifo=(SELECT po_idfifo FROM kh_platfifo AS a 
                   WHERE a.po_ref=(SELECT po_idfifo FROM kh_platfifo WHERE pl_idplatnosc=_idplatnosc) AND
		         po_kwotapln>=-tmp
		   ORDER BY po_dataop DESC,po_idfifo DESC LIMIT 1
		  );
 END IF;

 --- Odzwol na przekraczanie granicy
 UPDATE kh_platfifo SET po_flaga=po_flaga&(~8192) WHERE po_wplyw>0 AND pl_idplatnosc=_idplatnosc;


 FOR r IN SELECT rr.po_idfifo,s.po_kwotapln,s.wl_idwaluty
          FROM kh_platfifo AS s 
	  JOIN kh_platfifo AS rr ON (s.po_idfifo=rr.po_refrr)
	  WHERE s.po_ref=(SELECT po_idfifo FROM kh_platfifo WHERE pl_idplatnosc=_idplatnosc) AND s.po_ref IS NOT NULL
 LOOP
  PERFORM setkursplatfiforr(r.po_idfifo,r.po_kwotapln,r.wl_idwaluty);       
 END LOOP;

 FOR r IN SELECT s.po_idfifo,s.po_kwotawal,s.wl_idwaluty,rr.rr_wartoscpln
          FROM kh_platfifo AS s 
	  JOIN kr_rozrachunki AS rr USING (rr_idrozrachunku)
	  WHERE rr.pl_idplatnosc=_idplatnosc
	         AND s.po_ref IS NULL
		 AND s.po_refrr IS NULL
 LOOP
  PERFORM setkursplatfiforr(r.po_idfifo,abs(r.rr_wartoscpln),_newwaluta);
 END LOOP;

 --- Porusz platnosci
 UPDATE kh_platnosci SET pl_idplatnosc=pl_idplatnosc WHERE pl_idplatnosc IN (SELECT pl_idplatnosc FROM kh_platfifo WHERE po_ref=(SELECT po_idfifo FROM kh_platfifo WHERE pl_idplatnosc=_idplatnosc));



 RETURN TRUE; 
END;$_$;
