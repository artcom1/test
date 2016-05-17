CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 ile INT;
BEGIN

 IF (TG_OP<>'DELETE') THEN
  IF ((abs(NEW.hs_dozaplaty)<abs(NEW.hs_zaplacono)) OR ((NEW.hs_zaplacono<>0) AND (NEW.hs_zaplacono*NEW.hs_dozaplaty<0))) THEN
   RAISE EXCEPTION 'Kwota wplaty % przekracza wielkosc raty %',NEW.hs_zaplacono,NEW.hs_dozaplaty;
  END IF;
  IF (NEW.hs_dozaplaty=0) THEN
   RAISE EXCEPTIOn 'Rata nie mo??e by?? zerowa!';
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN

  IF (NEW.tr_idtrans<>OLD.tr_idtrans) THEN
   RAISE EXCEPTION 'Nie mozna zmieniac dokumentu do ktorego jest harmonogram splaty ';
  END IF;

  IF ((NEW.hs_flaga&1)<>0) THEN
   NEW.hs_flaga=NEW.hs_flaga&(~1);
  END IF;

 END IF;

 IF (TG_OP='INSERT') THEN
  ile=(SELECT nullZero(count(*)) FROM kh_platelem WHERE hs_idelementu IS NULL AND tr_idtrans=NEW.tr_idtrans);
  IF (ile<>0) THEN
   RAISE EXCEPTION 'Dokument posiada rozliczenia p??atno??ci poza harmonogramem sp??aty';
  END IF;
  UPDATE tg_transakcje SET tr_flaga=tr_flaga|(1<<26),tr_formaplat=flipFormaPlatnosci(tr_formaplat,TRUE) WHERE tr_idtrans=NEW.tr_idtrans AND ( (tr_flaga&(1<<26))=0 OR flipFormaPlatnosci(tr_formaplat,TRUE)<>tr_formaplat) ;
 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
