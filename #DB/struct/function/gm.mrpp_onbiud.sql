CREATE FUNCTION mrpp_onbiud() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP!='DELETE') THEN
  NEW.mrpp_flaga=NEW.mrpp_flaga&(~(1<<5));
  IF ((NEW.mrpp_flaga&(1<<3))!=0) AND ((NEW.mrpp_flaga&(1<<7))=0) AND ((NEW.mrpp_flaga&(1<<6))=0) THEN
   ---Ma ruchy PZetowe i APZetowe
   ---Nie ma ruchow niewydanych
   ---Nie ma APZetow
   NEW.mrpp_flaga=NEW.mrpp_flaga|(1<<5);
  END IF;
  -------------------------------------------
  NEW.mrpp_flaga=NEW.mrpp_flaga&(~(3<<1));
  IF ((NEW.mrpp_flaga&(1<<3))!=0) THEN
   NEW.mrpp_flaga=NEW.mrpp_flaga|(1<<1);
  END IF;
  -------------------------------------------
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END;
$$;
