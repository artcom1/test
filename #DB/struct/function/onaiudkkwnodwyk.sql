CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 tmp INT:=0;
 flaga_kkwnod INT:=0;
 liczymykubelkiold BOOL:=FALSE;
 liczymykubelkinew BOOL:=FALSE;
 
 jestprzezbrojenie       BOOL:=FALSE;
 przeliczenieprzezbrojen BOOL:=FALSE;
BEGIN
 -------------------------------------------------------------------------------------------------------------
 -----czesc odnosnie przezbrojenie  
 IF (TG_OP='INSERT') THEN
  IF (NEW.knw_flaga&((1<<0)|(1<<4))=((1<<0)|(1<<4))) THEN
   jestprzezbrojenie=TRUE;
  END IF;
 END IF;
 
 IF (TG_OP='UPDATE') THEN  
  IF((OLD.knw_flaga&(1<<4))<>(NEW.knw_flaga&(1<<4))) THEN
   IF ((NEW.knw_flaga&(1<<4))=(1<<4)) THEN -- Stalem sie przezbrojeniem
    UPDATE tr_kkwnodwykdet SET kwd_flaga=kwd_flaga|(1<<2) WHERE knw_idelemu=NEW.knw_idelemu;
    IF (NEW.knw_flaga&(1<<0)=(1<<0)) THEN
     jestprzezbrojenie=TRUE;
    END IF;
   ELSE -- Stalem sie zwyklym wykonaniem
    UPDATE tr_kkwnodwykdet SET kwd_flaga=kwd_flaga&(~(1<<2)) WHERE knw_idelemu=NEW.knw_idelemu;	
    IF (OLD.knw_flaga&(1<<0)=(1<<0)) THEN
     przeliczenieprzezbrojen=TRUE;
    END IF;
   END IF;    
  END IF;
  IF((OLD.knw_flaga&(1<<4))=(1<<4) AND (NEW.knw_flaga&(1<<4))=(1<<4)) THEN -- Bylo i jest przezbrojenie
   IF (OLD.knw_flaga&(1<<0)=(1<<0) AND NEW.knw_flaga&(1<<0)=0) THEN -- Bylo wykonanie a teraz nie ma
    przeliczenieprzezbrojen=TRUE;
   END IF;
   IF (OLD.knw_flaga&(1<<0)=0 AND NEW.knw_flaga&(1<<0)=(1<<0)) THEN -- Nie bylo wykonania a teraz jest
    jestprzezbrojenie=TRUE;
   END IF;
  END IF;
 END IF; 
    
 IF (TG_OP='DELETE') THEN
  IF (OLD.knw_flaga&((1<<0)|(1<<4))=((1<<0)|(1<<4))) THEN
   przeliczenieprzezbrojen=TRUE;
  END IF;
 END IF;
 
 -------------------------------------------------------------------------------------------------------------
 -----czesc odnosnie planow kubelkowych
 IF (TG_OP='UPDATE') THEN
  ---dla planow kubelkowych, uaktualnienie czy sa plany do danego kubelka
  IF (OLD.knw_flaga&4=0 AND NEW.knw_flaga&4=4) THEN
   liczymykubelkinew=TRUE;
  END IF;
  IF (OLD.knw_flaga&4=4 AND NEW.knw_flaga&4=0) THEN
   liczymykubelkiold=TRUE;
  END IF;
  IF (OLD.knw_flaga&4=4 AND NEW.knw_flaga&4=4 AND OLD.kb_idkubelka<>NEW.kb_idkubelka) THEN
   liczymykubelkiold=TRUE;
   liczymykubelkinew=TRUE;
  END IF;
 END IF;

 IF (TG_OP='INSERT') THEN
  IF (NEW.knw_flaga&4=4) THEN
   liczymykubelkinew=TRUE;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  IF (OLD.knw_flaga&4=4) THEN
   liczymykubelkiold=TRUE;
  END IF;
 END IF;

 IF (liczymykubelkinew) THEN
 ---zaznaczamy ze kubelek po NEW ma plan
  UPDATE tr_kubelki SET kb_flaga=kb_flaga|(2) WHERE kb_idkubelka=NEW.kb_idkubelka;
 END IF;

 IF (liczymykubelkiold) THEN
 ---liczymy kubelki po OLD czy maja jakies inne plany  
  tmp=(SELECT count(*) FROM tr_kkwnodwyk WHERE kb_idkubelka=OLD.kb_idkubelka AND knw_idelemu<>OLD.knw_idelemu);
  
  IF (tmp=0) THEN
   UPDATE tr_kubelki SET kb_flaga=kb_flaga&(~2) WHERE kb_idkubelka=OLD.kb_idkubelka;
  END IF;
 END IF;
 -----koniec czesc odnosnie planow kubelkowych
 -------------------------------------------------------------------------------------------------------------

 ----odnosnie rejestracji prac do zbiorczej tabeli i wykonan przezbrojen (dodane tutaj, zeby nie wykonywac kilka razy update kkwnoda)
 IF (TG_OP='UPDATE') THEN
   PERFORM uaktualnieniePracZMRP(NEW.knw_idelemu,(NEW.knw_flaga&(1<<4)));
 END IF;

 IF (TG_OP='DELETE') THEN
  -----Sprawdzamy czy sa jakies wykonania pod noda operacji
  tmp=(SELECT count(*) FROM tr_kkwnodwyk WHERE kwe_idelemu=OLD.kwe_idelemu AND knw_idelemu<>OLD.knw_idelemu);
  IF (tmp=0) THEN ---zdejmujemy informacje o rozpoczeciu wykonania na nodzie
   flaga_kkwnod=flaga_kkwnod|(1<<4);
  END IF;
  
  RAISE LOG 'DEBUG: przeliczenieprzezbrojen=%', przeliczenieprzezbrojen;
  IF (przeliczenieprzezbrojen) THEN ---przeliczam przezbrojenia
   tmp=(SELECT count(*) FROM tr_kkwnodwyk WHERE knw_flaga&((1<<0)|(1<<4))=((1<<0)|(1<<4)) AND kwe_idelemu=OLD.kwe_idelemu AND knw_idelemu<>OLD.knw_idelemu);
   RAISE LOG 'DEBUG: tmp=%', tmp;
   IF (tmp=0) THEN ---zdejmujemy informacje o rozpoczeciu wykonania na nodzie
    flaga_kkwnod=flaga_kkwnod|(1<<15);
   END IF;  
  END IF;
  
  RAISE LOG 'DEBUG: flaga_kkwnod=%', flaga_kkwnod;
  IF (flaga_kkwnod<>0) THEN
   UPDATE tr_kkwnod SET kwe_flaga=kwe_flaga&(~(flaga_kkwnod)) WHERE kwe_idelemu=OLD.kwe_idelemu;
  END IF;
 ELSE
 
  RAISE LOG 'DEBUG: jestprzezbrojenie=%', jestprzezbrojenie;
  IF (jestprzezbrojenie) THEN
   UPDATE tr_kkwnod SET kwe_flaga=kwe_flaga|(1<<15) WHERE kwe_idelemu=NEW.kwe_idelemu;  
  END IF;
  RAISE LOG 'DEBUG: przeliczenieprzezbrojen=%', przeliczenieprzezbrojen;
  IF (przeliczenieprzezbrojen) THEN ---przeliczam przezbrojenia
   tmp=(SELECT count(*) FROM tr_kkwnodwyk WHERE knw_flaga&((1<<0)|(1<<4))=((1<<0)|(1<<4)) AND kwe_idelemu=NEW.kwe_idelemu AND knw_idelemu<>NEW.knw_idelemu);
   RAISE LOG 'DEBUG: tmp=%', tmp;
   IF (tmp=0) THEN ---zdejmujemy informacje o rozpoczeciu wykonania na nodzie
    UPDATE tr_kkwnod SET kwe_flaga=kwe_flaga&(~(1<<15)) WHERE kwe_idelemu=NEW.kwe_idelemu;
   END IF;  
  END IF;
 END IF;
 
 -------------------------------------------------------------------------------------------------------------
 -- SYNCHRONIZACJA WYK DET
 IF (TG_OP='UPDATE') THEN
  IF ((NEW.knw_datawyk <> OLD.knw_datawyk) OR (NEW.knw_datastart <> OLD.knw_datastart) OR ((NEW.knw_flaga&(1<<0)) <> (OLD.knw_flaga&(1<<0)))) THEN
   tmp=(SELECT COALESCE(cf_defvalue::int,0) FROM tc_config WHERE cf_tabela='mrp_wyk_synchro_wykdet');
   IF (tmp=1) THEN
    IF ((NEW.knw_flaga&(1<<0))=0) THEN-- Nie zakonczono pracy
     UPDATE tr_kkwnodwykdet SET kwd_flaga=kwd_flaga&(~(1<<0)), kwd_datastart=NEW.knw_datastart, kwd_dataend=NEW.knw_datawyk WHERE knw_idelemu=NEW.knw_idelemu;
    ELSE -- wlasnie zakonczono
     UPDATE tr_kkwnodwykdet SET kwd_flaga=kwd_flaga|(1<<0), kwd_datastart=NEW.knw_datastart, kwd_dataend=NEW.knw_datawyk WHERE knw_idelemu=NEW.knw_idelemu;
    END IF;
   END IF;
  END IF;
 END IF;
 -------------------------------------------------------------------------------------------------------------
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
