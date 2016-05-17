CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idhead ALIAS FOR $1;
 _dzien ALIAS FOR $2;
 _rbh ALIAS FOR $3;
 _rodzaj ALIAS FOR $4;
 _pracaod ALIAS FOR $5;
 _pracado ALIAS FOR $6;
 _elem INT;
 _roznica INTERVAL;
 _obecnosc NUMERIC;
BEGIN

 _roznica=_pracado-_pracaod;
 _obecnosc=date_part('days',_roznica)*24+date_part('hours',_roznica)+date_part('minute',_roznica)/60;
 _obecnosc=round(_obecnosc,2);

 SELECT kale_idkalendarzaelem INTO _elem FROM tb_kalendarzelem WHERE kalh_idkalendarzahead=_idhead AND kale_dzien=_dzien;
 IF FOUND THEN
  UPDATE tb_kalendarzelem SET kale_pracastart=_pracaod, kale_pracastop=_pracado, kale_rbhpraca=_rbh, kale_rbhobecnosc=_obecnosc WHERE kale_idkalendarzaelem=_elem;
  RETURN 1;
 ELSE
  INSERT INTO tb_kalendarzelem (kalh_idkalendarzahead,kale_dzien,kale_pracastart,kale_pracastop,kale_rbhpraca,kale_rodzaj,kale_rbhobecnosc) VALUES (_idhead,_dzien,_pracaod,_pracado,_rbh,0,_obecnosc);
 END IF; 

 RETURN 0;
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idhead ALIAS FOR $1;
 _dzien ALIAS FOR $2;
 _rbh ALIAS FOR $3;
 _rodzaj ALIAS FOR $4;
 _pracaod ALIAS FOR $5;
 _pracado ALIAS FOR $6;
 _przeliczhead ALIAS FOR $7;
 _found BOOLEAN;
 _elem INT;
 _roznica INTERVAL;
 _obecnosc NUMERIC;
  rechead RECORD;
  recelem RECORD;
  recpraca RECORD;
  pracownik INT;
BEGIN
 IF _przeliczhead THEN
  SELECT p_idpracownika, fm_idcentrali INTO rechead FROM tb_kalendarzhead WHERE kalh_idkalendarzahead=_idhead;
  SELECT SUM(pra_rbh) AS rbh, MIN(wyliczeniestartupracy(pra_datastart,pra_datastop,pra_rbh,pra_flaga)) AS pracaod, MAX(COALESCE(pra_datastop,pra_datastart)) AS pracado INTO recpraca FROM tg_praceall WHERE pra_datastart::DATE=_dzien AND pra_flaga&18=2 AND tg_praceall.p_idpracownika=rechead.p_idpracownika AND tg_praceall.fm_idcentrali=rechead.fm_idcentrali;
  _rbh = COALESCE(recpraca.rbh,0);
  _pracaod = recpraca.pracaod;
  _pracado = recpraca.pracado;
 END IF;

 _roznica=_pracado-_pracaod;
 _obecnosc=date_part('days',_roznica)*24+date_part('hours',_roznica)+date_part('minute',_roznica)/60;
 _obecnosc=COALESCE(round(_obecnosc,2),0);
 
 SELECT kale_idkalendarzaelem INTO _elem FROM tb_kalendarzelem WHERE kalh_idkalendarzahead=_idhead AND kale_dzien=_dzien;
 IF FOUND THEN
  UPDATE tb_kalendarzelem SET kale_pracastart=_pracaod, kale_pracastop=_pracado, kale_rbhpraca=_rbh, kale_rbhobecnosc=_obecnosc WHERE kale_idkalendarzaelem=_elem;
  _found = true;
 ELSE
  INSERT INTO tb_kalendarzelem (kalh_idkalendarzahead,kale_dzien,kale_pracastart,kale_pracastop,kale_rbhpraca,kale_rodzaj,kale_rbhobecnosc) VALUES (_idhead,_dzien,_pracaod,_pracado,_rbh,0,_obecnosc);
  _found = false;
 END IF; 

 IF _przeliczhead THEN
  PERFORM przeliczkalhead(_idhead);
 END IF;
 
 IF _found THEN
  RETURN 1;
 ELSE
  RETURN 0;
 END IF;
END;
$_$;
