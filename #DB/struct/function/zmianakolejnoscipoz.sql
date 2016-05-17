CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 trans RECORD;
 lp INT;
 tr_idtrans INT;
BEGIN
  tr_idtrans=-2;
  lp=1;
  FOR trans IN EXECUTE $1 
  LOOP
    IF (trans.tr_idtrans!=tr_idtrans) THEN
     tr_idtrans=trans.tr_idtrans::INT;
     lp=1;
    END IF;
    
    UPDATE tg_transelem SET tel_lp=lp, tel_flaga=tel_flaga|16384 WHERE tel_idelem=trans.tel_idelem;
    lp=lp+1;
  END LOOP;

  RETURN 1;
END;$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 _tabelki ALIAS FOR $1;
 _warunki ALIAS FOR $2;
 _sortowanie ALIAS FOR $3;
BEGIN
  RETURN zmianakolejnoscipoz(_tabelki,_warunki,_sortowanie,NULL,''::text);
END;$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 trans RECORD;
 transzestaw RECORD;
 lp INT;
 lpz INT:=1;
 lpzestaw INT;
 tr_idtrans INT;
 _tabelki ALIAS FOR $1;
 _warunki ALIAS FOR $2;
 _sortowanie ALIAS FOR $3;
 _tel_skojzestaw ALIAS FOR $4;
 _tel_lpojca ALIAS FOR $5;
 query TEXT;
 qselect TEXT;
 warunkiq TEXT;
BEGIN
  tr_idtrans=-2;
  lp=1;
  qselect='SELECT tr_idtrans, tel_idelem, tel_newflaga  ';
  IF (_tel_skojzestaw is NULL) THEN
   warunkiq=_warunki||' AND tel_skojzestaw is null '::text; --bez elementow zwiazanych z zestawami      
   warunkiq=warunkiq||' AND tel_flaga&1024=0 '::text ; ---tylko elementy nie ukryte
  ELSE
   warunkiq=_warunki||' AND tel_skojzestaw= '||_tel_skojzestaw; --mamy podany dla ktorego zestawu trzeba przeprowadzic sortowanie
  END IF;

  query=qselect||_tabelki||warunkiq||_sortowanie;

  FOR trans IN EXECUTE query
  LOOP
    IF (trans.tr_idtrans!=tr_idtrans) THEN 
     tr_idtrans=trans.tr_idtrans::INT;
     lp=1;
    END IF;
    
    UPDATE tg_transelem SET tel_lp=lp, tel_lpprefix=_tel_lpojca, tel_flaga=tel_flaga|16384 WHERE tel_idelem=trans.tel_idelem;
    IF ((trans.tel_newflaga&(256))=(256)) THEN
    ---pozycja ma elementy powiazane, wiec sortujemy te elementy osobno
     PERFORM zmianakolejnoscipoz(_tabelki,_warunki,_sortowanie,trans.tel_idelem,numerkonta(_tel_lpojca,lp));
    END IF;

    lp=lp+1;
  END LOOP;

  RETURN 1;
END;$_$;
