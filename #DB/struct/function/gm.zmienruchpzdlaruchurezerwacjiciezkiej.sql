CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 r1    TG_RUCHY;
 idret INT;
BEGIN    
 SELECT * INTO r1 FROM tg_ruchy WHERE rc_idruchu=idruchurezc;

 IF (isRezerwacja(r1.rc_flaga)=FALSE) OR (isRezerwacjaLekka(r1.rc_flaga)=TRUE) THEN
  RAISE EXCEPTION 'Zadanie operacji na ruchu rezerwacji ciezkiej ktora nie jest rezerwacja ciezka!';
 END IF;
 
 ---Sztuczka: Ustawimy zmienna globalna
 PERFORM vendo.settParamI('NEWWZTRAPREZC',simid);
 PERFORM vendo.settParamI('NEWWZTRAPREZC_ID',idruchurezc);

 ---Sztuczka: Zmienimy partie na ruchu
 PERFORM gm.zmienPartie(idruchurezc,idruchupznew,ilosc);

 ---Sztuczka: Skasujemy wskaznik
 PERFORM vendo.settParamI('NEWWZTRAPREZC',0);

 RETURN TRUE;
END;
$$;
