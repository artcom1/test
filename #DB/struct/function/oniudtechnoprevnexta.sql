CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 th RECORD;
 operacja RECORD;
 _thpn_idelem INT;
BEGIN
 IF (TG_OP='INSERT') THEN
  PERFORM  rebuildwspolczynnikitechnologii(NEW.th_idtechnologii,NULL,1,NULL);
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF ((NEW.thpn_x_licznik)!=(OLD.thpn_x_licznik) OR (NEW.thpn_x_mianownik)!=(OLD.thpn_x_mianownik) OR (NEW.thpn_flaga&7)!=(OLD.thpn_flaga&7) ) THEN
   PERFORM  rebuildwspolczynnikitechnologii(NEW.th_idtechnologii,NULL,1,NULL);
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  IF (OLD.thpn_flaga&8=8) THEN
   ---usuwana relacja miala przenoszone ilosci z operacji, musimy ustawic dla te ilosci na innej relacji
   ----szukamy relacji do aktualizacji
   _thpn_idelem=(SELECT thpn_idelem FROM tr_technoprevnext AS rpn JOIN tr_technoelem AS te ON (te.the_idelem=rpn.the_idnext) WHERE the_idprev=OLD.the_idprev AND thpn_idelem!=OLD.thpn_idelem ORDER BY the_lp ASC LIMIT 1);
    IF (_thpn_idelem>0) THEN
     ---jest jeszcze inna relacjia, ja ustawiamy jaka ta z przenoszeniem ilosci
     UPDATE tr_technoprevnext SET thpn_flaga=(thpn_flaga&(~7))|1|8 ,thpn_x_licznik=OLD.thpn_x_licznik, thpn_x_mianownik=OLD.thpn_x_mianownik,thpn_x_wspc=OLD.thpn_x_wspc WHERE thpn_idelem=_thpn_idelem;
    END IF;
  END IF;

  PERFORM  rebuildwspolczynnikitechnologii(OLD.th_idtechnologii,NULL,1,NULL);
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
