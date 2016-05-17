CREATE FUNCTION onaiuruchyt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN    

 IF (TG_OP='INSERT') THEN
  IF (isFV(NEW.rc_flaga)=TRUE) THEN
   ---RAISE NOTICE 'Powstal nowy ruch WZ %',NEW.rc_idruchu;
   PERFORM gms.onAddRuchWZ(NEW.rc_idruchu);
  END IF;
  IF (isRezerwacja(NEW.rc_flaga)=TRUE) AND (NOT isRezerwacjaLekka(NEW.rc_flaga)) THEN
   ----RAISE NOTICE 'Powstal nowy ruch rezerwacji %',NEW.rc_idruchu;
   PERFORM gms.onAddRuchRezC(NEW.rc_idruchu);
  END IF;
 END IF;
  
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 RETURN NEW;
END;
$$;
