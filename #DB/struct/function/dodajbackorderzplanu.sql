CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN dodajBackorderZPlanu($1,$2,$3,$4,$5,$6,5);
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN dodajBackorderZPlanu($1,$2,$3,$4,$5,$6,$7,NULL,0);
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idplanu       ALIAS FOR $1;
 _idtowaru      ALIAS FOR $2;
 _ilosc         ALIAS FOR $3;
 _isprzychod    ALIAS FOR $4;
 _data          ALIAS FOR $5;
 _zlecenie      ALIAS FOR $6;
 _powod         ALIAS FOR $7;
 _tmg_idmagazyn ALIAS FOR $8;
 _flaga_rozm    ALIAS FOR $9; 
 -- 0 - Do sprawdzenia czy nie jest nadindexem 
 -- 1 - Nie trzeba sprawdzac, robimy BO (jestem podindexem)
 -- 2 - Zostalem sprawdzony, nie jestem z rozmiarowki
  
 id             INT:=NULL;
 flag           INT:=0;
 _idtowmag      INT:=0;
 rec            RECORD; 
BEGIN
 
 IF (_ilosc IS NULL) THEN    
  return NULL;
 END IF;

 IF (_idtowaru IS NULL OR _idtowaru<=0) THEN
  return NULL;
 END IF;

 IF (_isprzychod) THEN flag=1; END IF;
 
 IF (_tmg_idmagazyn IS NULL) THEN
  -----szukamy odpowiedniego towmaga do backordera
  SELECT tmg_magazynprod INTO rec FROM tg_towary WHERE ttw_idtowaru=_idtowaru;
  IF (rec.tmg_magazynprod IS NOT NULL) THEN
  ---mam ustawiony magazyn na karcie wiec szukamy towmaga
   _tmg_idmagazyn=rec.tmg_magazynprod;
  ELSE
  ---nie ma magazynu na karcie wiec pobieramy z glownych ustawien programu na ktory magazyn ma byc domyslna produkcja
   SELECT fm_idcentrali INTO rec FROM tg_zlecenia WHERE zl_idzlecenia=_zlecenie;
   _tmg_idmagazyn=(SELECT cf_defvalue FROM tc_config WHERE cf_tabela='MRPKKWMagazyn'||rec.fm_idcentrali)::int;
  END IF;  
 END IF;

 IF (_tmg_idmagazyn IS NULL OR _tmg_idmagazyn<=0) THEN
  return 0; ------nie znalezlismy magazynu pod ustawienie backordera wiec nic nie robimy
 END IF;

 IF (_flaga_rozm=0) THEN -- Sprawdzam czy nie jestem nadindexem i czy nie musze robic BO na podindexy  
  _flaga_rozm=2;
  FOR rec IN 
  SELECT
  ttw_idtowaru_pdx,
  pzw_iloscop*pzw_mnoznikop AS _il_oczek,
  max(pzw_ilosczreal,pzw_ilosczrealclosed) AS _il_wmag
  FROM gmr.tg_planzleceniarozmelems
  WHERE pz_idplanu=_idplanu
  LOOP
   _flaga_rozm=0;
   IF (_ilosc=0) THEN
    PERFORM dodajBackorderZPlanu(_idplanu,rec.ttw_idtowaru_pdx,0,_isprzychod,_data,_zlecenie,_powod,_tmg_idmagazyn,1); 
   ELSE
    PERFORM dodajBackorderZPlanu(_idplanu,rec.ttw_idtowaru_pdx,max(0,(rec._il_oczek-rec._il_wmag)),_isprzychod,_data,_zlecenie,_powod,_tmg_idmagazyn,1);  
   END IF;
  END LOOP;
 END IF;

 IF (_flaga_rozm=0) THEN -- Jesli dalej mam 0 po spradzeniu to znaczy, ze jestem nadindexem i zrobilem BO na podindexy
  RETURN 1;
 END IF;
 
 _idtowmag = gettowmag(_idtowaru,_tmg_idmagazyn,TRUE);

 ---szukajac planu nie patrzymy na magazyn bo on w czasie sie moze zmienic (by program skasowal jak potrzeba zapotrzebowanie jak ktos bedzie machal magazynem na karcie towaru)
 id=(SELECT bo_idbackord FROM tg_backorder WHERE (pz_idplanusrc=_idplanu) AND (ttm_idtowmag=_idtowmag) AND (bo_powod=_powod) AND (bo_flaga&1=flag));
 IF (id IS NULL) THEN
  IF (_ilosc<=0) THEN RETURN NULL; END IF;  
  ----dla pewnosci chcemy skasowac wszystkie backordery doczepione do danego planu (moze sie tu zmieniac towmag
  IF (_flaga_rozm=2) THEN -- Ale tylko jesli nie mam doczynienia z podindexami
   DELETE FROM tg_backorder WHERE (pz_idplanusrc=_idplanu) AND (bo_powod=_powod) AND (bo_flaga&1=flag);
  END IF;
  
  INSERT INTO tg_backorder
    (ttm_idtowmag,bo_iloscf,bo_powod,pz_idplanusrc,bo_flaga, bo_data,zl_idzlecenia)
  VALUES
    (_idtowmag,_ilosc,_powod,_idplanu,flag,_data,_zlecenie);
  id=(SELECT currval('tg_backorder_s'));
 ELSE
  IF (_ilosc<=0) THEN
   DELETE FROM tg_backorder WHERE bo_idbackord=id;
  ELSE
   UPDATE tg_backorder SET bo_iloscf=_ilosc, bo_data=_data,zl_idzlecenia=_zlecenie WHERE (bo_idbackord=id) AND (bo_iloscf<>_ilosc OR bo_data<>_data OR zl_idzlecenia<>_zlecenie);
  END IF;
 END IF;

 RETURN id;
END;
$_$;
