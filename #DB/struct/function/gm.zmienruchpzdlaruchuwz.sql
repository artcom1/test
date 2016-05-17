CREATE FUNCTION zmienruchpzdlaruchuwz(simid integer, idruchuwz integer, idruchupznew integer, ilosc numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
 r1    TG_RUCHY;
 idret INT;
BEGIN    
 SELECT * INTO r1 FROM tg_ruchy WHERE rc_idruchu=idruchuwz;

 IF (isFV(r1.rc_flaga)=FALSE) THEN
  RAISE EXCEPTION 'Zadanie operacji na ruchu WZ ktory nie jest ruchem WZ!';
 END IF;
 
 ---Sztuczka: Ustawimy zmienna globalna
 PERFORM vendo.settParamI('NEWWZTRAP',simid);
 PERFORM vendo.settParamI('NEWWZTRAP_ID',idruchuwz);

 PERFORM gm.blockpzet(NULL,true);

 ---Sztuczka: Zmienimy partie na WZ
 PERFORM gm.zmienPartie(idruchuwz,idruchupznew,ilosc);

 PERFORM gm.blockpzet(NULL,false);

 ---Sztuczka: Skasujemy wskaznik
 PERFORM vendo.settParamI('NEWWZTRAP',0);

 RETURN TRUE;
END;
$$;
