CREATE FUNCTION rebuildwspolczynnikitechnologii(integer, integer, numeric, integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 _idtechnologii ALIAS FOR $1;
 _parent ALIAS FOR $2;
 _wspo ALIAS FOR $3;
 _idwariant ALIAS FOR $4;
 idwariant INT;
 r RECORD;
 ileelementow NUMERIC;
 query TEXT;
 optymalnapartia NUMERIC;
 wspolczynnik NUMERIC;
BEGIN

 idwariant=_idwariant;
 IF (_parent IS NULL) THEN 
 ----jak nie ma podanego elementu dla ktorego mamy to przeliczyc kasujemy wszystkie wpisy odnosnie tych wspolczynnikow
  DELETE FROM tr_technoelemwsp  WHERE th_idtechnologii=_idtechnologii;

  ---pobieramy wielkosci z technologii odnosnie optymalnej partii oraz przelicznika wyrobu ostatnich operacji
  SELECT th_optpartia,th_mnoznikwyrobu_l,th_mnoznikwyrobu_m INTO r FROM tr_technologie WHERE th_idtechnologii=_idtechnologii;

  ---pobieramy domyslny wariant dla tej technologii
  idwariant=(SELECT vmp_idwariantu FROM tr_warianthead WHERE th_idtechnologii=_idtechnologii AND vmp_flaga&1=1);

  ---ustawiamy zapytanie w zaleznosci czy mamy domyslny wariant czy nie
  IF (idwariant IS NULL) THEN
    ---pobieramy elementy technologii ktore sa przeniesieniem wyrobu na magazyn
   ileelementow=(SELECT count(*) FROM tr_technoelem WHERE th_idtechnologii=_idtechnologii AND the_flaga&1=1);
   query='SELECT the_idelem FROM tr_technoelem WHERE th_idtechnologii='||_idtechnologii||' AND the_flaga&1=1 AND the_flaga&2048=0 ORDER BY the_lp';
  ELSE 
   ileelementow=(SELECT count(*) FROM tr_technoelem WHERE th_idtechnologii=_idtechnologii AND the_flaga&1=1 AND the_idelem NOT IN (SELECT the_idelem FROM tr_wariantelem where vmp_idwariantu=idwariant));
   query='SELECT the_idelem FROM tr_technoelem WHERE th_idtechnologii='||_idtechnologii||' AND the_flaga&1=1 AND the_flaga&2048=0 AND the_idelem NOT IN (SELECT the_idelem FROM tr_wariantelem where vmp_idwariantu='||idwariant||') ORDER BY the_lp';
  END IF;

  IF (ileelementow=0) THEN
   ileelementow=1;
  END IF;

  ----licze ile ostatnich operacji ma wynikac
  wspolczynnik=((r.th_optpartia*r.th_mnoznikwyrobu_l)/r.th_mnoznikwyrobu_m)/ileelementow;
  
  FOR r IN EXECUTE query
  LOOP
   PERFORM rebuildwspolczynnikitechnologii(_idtechnologii,r.the_idelem,wspolczynnik,idwariant);   
  END LOOP;

 ELSE --- mam podany element dla ktorego przeliczamy
  ---dodajemy jego wspoczynnik do tabelki
  PERFORM settechnoelemwsp(_idtechnologii,_parent,_wspo);

  ----pobieramy poprzednikow i dla nich przeliczamy wspolczynniki
  IF (_idwariant IS NULL) THEN
   query='SELECT thpn_x_licznik,thpn_x_mianownik,thpn_x_wspc,thpn_flaga&7 AS rodzaj, the_idprev FROM tr_technoprevnext WHERE the_idnext='||_parent||' ORDER BY thpn_idelem';
  ELSE 
   query='SELECT thpn_x_licznik,thpn_x_mianownik,thpn_x_wspc,thpn_flaga&7 AS rodzaj, the_idprev FROM tr_technoprevnext WHERE the_idnext='||_parent||'  AND the_idprev NOT IN (SELECT the_idelem FROM tr_wariantelem where vmp_idwariantu='||idwariant||') ORDER BY thpn_idelem';
  END IF;

  FOR r IN EXECUTE query
  LOOP
   IF (r.thpn_x_mianownik=0) THEN
    r.thpn_x_mianownik=1;
   END IF;

   IF (r.rodzaj=0) THEN ------liczenie wedlug nastepnika
    wspolczynnik=(_wspo*r.thpn_x_licznik)/r.thpn_x_mianownik+r.thpn_x_wspc;
   END IF;
   IF (r.rodzaj=1) THEN -------liczenie wedlug ilosci operacji
    optymalnapartia=(SELECT th_optpartia FROM tr_technologie WHERE th_idtechnologii=_idtechnologii);
    wspolczynnik=(optymalnapartia*r.thpn_x_licznik)/r.thpn_x_mianownik+r.thpn_x_wspc;
   END IF;

   PERFORM rebuildwspolczynnikitechnologii(_idtechnologii,r.the_idprev,wspolczynnik,idwariant);   
  END LOOP;
 END IF;

 RETURN TRUE;
END
$_$;
