CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 th RECORD;
BEGIN
 IF (TG_OP='INSERT') THEN
  SELECT th_flaga INTO th FROM tr_technologie AS t WHERE t.th_idtechnologii=NEW.th_idtechnologii;
  IF (th.th_flaga&128=128) THEN
   ---mamy automatycznie dodawac relacje nastepnik poprzednik wedlug lp
   PERFORM  MRPdodajRelacjeNastepnikPoprednik(NEW.th_idtechnologii, NEW.the_idelem, NEW.the_lp, th.th_flaga);
  END IF;
  IF (th.th_flaga&64=64 AND NEW.the_flaga&1=0) THEN
   ---mamy ustawione ze ilosci operacji ustawiamy na nodzie wiec przenosimy je do relacji nastepnik poprzednik
   ---dla operacji ktore maja przekazanie na magazyn nie mamy wpisywania ilosci operacji na nodzie
   PERFORM MRPPrzeniesIlosciNaRelacjeNAstepnikPoprzednik(NEW.th_idtechnologii,NEW.the_idelem,NEW.the_x_licznik,NEW.the_x_mianownik,NEW.the_x_wspc);
  END IF;

  IF (NEW.the_flaga&1=1 ) THEN
   PERFORM  rebuildwspolczynnikitechnologii(NEW.th_idtechnologii,NULL,1,NULL);
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
  SELECT th_flaga INTO th FROM tr_technologie AS t WHERE t.th_idtechnologii=NEW.th_idtechnologii;
  IF (th.th_flaga&64=64 AND NEW.the_flaga&1=0) THEN
    ---mamy ustawione ze ilosci operacji ustawiamy na nodzie wiec przenosimy je do relacji nastepnik poprzednik
    PERFORM MRPPrzeniesIlosciNaRelacjeNAstepnikPoprzednik(NEW.th_idtechnologii,NEW.the_idelem,NEW.the_x_licznik,NEW.the_x_mianownik,NEW.the_x_wspc);
  END IF;
  IF (th.th_flaga&64=64 AND NEW.the_flaga&1=1 AND OLD.the_flaga&1=0) THEN
    ---mielismy normalna operacja a teraz bedzie ona konczacym KKW, zerujemy ilosci na relacji nastepstwa
    PERFORM MRPPrzeniesIlosciNaRelacjeNAstepnikPoprzednik(NEW.th_idtechnologii,NEW.the_idelem,0,1,0);
  END IF;

  IF ((NEW.the_flaga&1)!=(OLD.the_flaga&1)) THEN
   PERFORM  rebuildwspolczynnikitechnologii(NEW.th_idtechnologii,NULL,1,NULL);
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  IF (OLD.the_flaga&1=1) THEN
   PERFORM  rebuildwspolczynnikitechnologii(OLD.th_idtechnologii,NULL,1,NULL);
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
