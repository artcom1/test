CREATE FUNCTION oniudtechnologie() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  towar_dom_tech_prod_jest bool:=FALSE;
  towar_dom_tech_prod_brak bool:=FALSE;
  
  towar_dom_tech_serw_jest bool:=FALSE;
  towar_dom_tech_serw_brak bool:=FALSE;
  
  towar_dom_tech_badania_jest bool:=FALSE;
  towar_dom_tech_badania_brak bool:=FALSE;
  
  _fm_indextab INT;
  _fm_idcentrali INT;
BEGIN

 IF (TG_OP='INSERT') THEN
  IF (NEW.th_numer IS NULL) THEN
   NEW.th_numer=(SELECT NullZero(max(th_numer))+1 AS numer FROM tr_technologie WHERE th_sufix=NEW.th_sufix AND th_rodzaj=NEW.th_rodzaj);
  END IF;
  
  IF (NEW.th_flaga&1=0 AND NEW.ttw_idtowaru>0) THEN  
   ---dodajemy flage na wyrobie ze jest technologia
   PERFORM oznaczTowarTechnologia(NEW.ttw_idtowaru,1,NEW.th_rodzaj);
   IF (NEW.th_flaga&4=4) THEN
    --technologia domyslna
IF (NEW.th_rodzaj=1) THEN towar_dom_tech_prod_jest=TRUE; END IF;
IF (NEW.th_rodzaj=2) THEN towar_dom_tech_serw_jest=TRUE; END IF;
IF (NEW.th_rodzaj=3) THEN towar_dom_tech_badania_jest=TRUE;END IF;    
   END IF;
  END IF;
  _fm_idcentrali=NEW.fm_idcentrali;
 END IF;

 IF (TG_OP='UPDATE') THEN
  _fm_idcentrali=NEW.fm_idcentrali;
  IF (((NEW.th_flaga&1)!=(OLD.th_flaga&1)) OR (NEW.ttw_idtowaru!=OLD.ttw_idtowaru)) THEN  
  ---zmiana wyrobu lub aktywnosci
  PERFORM oznaczTowarTechnologia(NEW.ttw_idtowaru,1,NEW.th_rodzaj);
  PERFORM oznaczTowarTechnologia(OLD.ttw_idtowaru,(SELECT count(*)::int FROM tr_technologie WHERE th_idtechnologii!=OLD.th_idtechnologii AND  ttw_idtowaru=OLD.ttw_idtowaru AND th_flaga&1=0),OLD.th_rodzaj);
  END IF;

  IF ((OLD.th_flaga&5=4 AND NEW.th_flaga&5<>4) OR (NEW.ttw_idtowaru!=OLD.ttw_idtowaru AND OLD.th_flaga&5=4 )) THEN
   ---kasujemy z karty towaru domyslna technologie
   IF (NEW.th_rodzaj=1) THEN towar_dom_tech_prod_brak=TRUE; END IF;
   IF (NEW.th_rodzaj=2) THEN towar_dom_tech_serw_brak=TRUE; END IF;
   IF (NEW.th_rodzaj=3) THEN towar_dom_tech_badania_brak=TRUE; END IF;  
  END IF;

  IF ((OLD.th_flaga&5<>4 AND NEW.th_flaga&5=4) OR (NEW.ttw_idtowaru!=OLD.ttw_idtowaru AND NEW.th_flaga&5=4)) THEN
   ---nadajemy karcie towaru domyslna technologie
   IF (NEW.th_rodzaj=1) THEN towar_dom_tech_prod_jest=TRUE; END IF;
   IF (NEW.th_rodzaj=2) THEN towar_dom_tech_serw_jest=TRUE; END IF;
   IF (NEW.th_rodzaj=3) THEN towar_dom_tech_badania_jest=TRUE; END IF;  
  END IF;

  IF (((NEW.th_flaga&8)=8 AND (OLD.th_flaga&8)=0) OR (NEW.th_optpartia!=OLD.th_optpartia) OR (NEW.th_mnoznikwyrobu_l!=OLD.th_mnoznikwyrobu_l) OR (NEW.th_mnoznikwyrobu_m!=OLD.th_mnoznikwyrobu_m)) THEN
  ---przeliczanie wspolczynnikow technolemow wg optymalnej partii
   PERFORM  rebuildwspolczynnikitechnologii(NEW.th_idtechnologii,NULL,1,NULL);
  END IF;
 END IF;


 IF (TG_OP='DELETE') THEN
  _fm_idcentrali=OLD.fm_idcentrali;
  PERFORM oznaczTowarTechnologia(OLD.ttw_idtowaru,(SELECT count(*)::int FROM tr_technologie WHERE th_idtechnologii!=OLD.th_idtechnologii AND ttw_idtowaru=OLD.ttw_idtowaru AND th_flaga&1=0),OLD.th_rodzaj);
  ---kasujemy z karty towaru domyslna technologie
  IF (OLD.th_flaga&5=4) THEN
   IF (OLD.th_rodzaj=1) THEN towar_dom_tech_prod_brak=TRUE; END IF;
   IF (OLD.th_rodzaj=2) THEN towar_dom_tech_serw_brak=TRUE; END IF;
   IF (OLD.th_rodzaj=3) THEN towar_dom_tech_badania_brak=TRUE; END IF;  
  END IF;
 END IF;

 ----aktualizujemy karte towaru odnosnie domyslnej technologii  
 IF (towar_dom_tech_prod_jest OR towar_dom_tech_prod_brak OR towar_dom_tech_serw_jest OR towar_dom_tech_serw_brak OR towar_dom_tech_badania_jest OR towar_dom_tech_badania_brak) THEN
  _fm_indextab=(SELECT fm_idindextab FROM tb_firma WHERE fm_index=_fm_idcentrali);
 END IF;

 --- PRODUKCJA
 IF (towar_dom_tech_prod_jest AND TG_OP<>'DELETE') THEN
  UPDATE tg_towary SET ttw_domyslnatechnologia[_fm_indextab]=NEW.th_idtechnologii WHERE ttw_idtowaru=NEW.ttw_idtowaru;
 END IF;
 IF (towar_dom_tech_prod_brak AND TG_OP<>'INSERT') THEN
  UPDATE tg_towary SET ttw_domyslnatechnologia[_fm_indextab]=NULL WHERE ttw_idtowaru=OLD.ttw_idtowaru;
 END IF;
 
 --- SERWIS
 IF (towar_dom_tech_serw_jest AND TG_OP<>'DELETE') THEN
  UPDATE tg_towary SET ttw_domyslnatechnoserwis[_fm_indextab]=NEW.th_idtechnologii WHERE ttw_idtowaru=NEW.ttw_idtowaru;
 END IF;
 IF (towar_dom_tech_serw_brak AND TG_OP<>'INSERT') THEN
  UPDATE tg_towary SET ttw_domyslnatechnoserwis[_fm_indextab]=NULL WHERE ttw_idtowaru=OLD.ttw_idtowaru;
 END IF;
 
 --- BADANIA 
 IF (towar_dom_tech_badania_jest AND TG_OP<>'DELETE') THEN
  UPDATE tg_towary SET ttw_domyslnatechnobadania[_fm_indextab]=NEW.th_idtechnologii WHERE ttw_idtowaru=NEW.ttw_idtowaru;
 END IF;
 IF (towar_dom_tech_badania_brak AND TG_OP<>'INSERT') THEN
  UPDATE tg_towary SET ttw_domyslnatechnobadania[_fm_indextab]=NULL WHERE ttw_idtowaru=OLD.ttw_idtowaru;
 END IF;
 
 IF (TG_OP='UPDATE') THEN
  IF (NEW.th_optpartia <> OLD.th_optpartia AND NEW.th_rodzaj=4) THEN
   PERFORM mrpkalkulacjaupdateilosci_mat(NEW.th_idtechnologii,NEW.th_optpartia);
   PERFORM update_mrpkalkulacjaobliczkoszty(NEW.th_idtechnologii); 
  END IF; 
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
