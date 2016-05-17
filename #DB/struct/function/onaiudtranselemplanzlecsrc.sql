CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 zamowienieold NUMERIC:=0;
 zamowienienew NUMERIC:=0;
 
 flaganew INT;
 flagaold INT;
 
 delta NUMERIC:=0; 
 idplanusrc INT;
BEGIN
 
 IF (TG_OP='UPDATE' OR TG_OP='DELETE') THEN    
  zamowienieold=OLD.tel_iloscf;
  flagaold=OLD.tel_flaga;
  idplanusrc=OLD.pz_idplanusrc;
 END IF;
 
 IF (TG_OP='UPDATE' OR TG_OP='INSERT') THEN
  zamowienienew=NEW.tel_iloscf;
  flaganew=NEW.tel_flaga;
  idplanusrc=NEW.pz_idplanusrc;
 END IF;
   
 IF (idplanusrc>0) THEN
  delta=zamowienienew-zamowienieold;
 
  IF (TG_OP='UPDATE' OR TG_OP='INSERT') THEN 
   IF (TG_OP='UPDATE' AND flaganew&(4096+1024+32768)=32768 AND flagaold&(4096+1024+32768)=0) THEN -- pozycja zmienia swoj stan, pokazywala ilosc zamowiona, teraz pokazuje do realizacji
    UPDATE tg_planzlecenia SET pz_ilosczam=pz_ilosczam-zamowienieold, pz_ilosczamdozreal=pz_ilosczamdozreal+delta WHERE pz_idplanu=idplanusrc;
   ELSE 
    IF (flaganew&(4096+1024+32768)=32768 OR flaganew&(4096+1024+32768)=33792) THEN -- Ilosc do realizacji
     UPDATE tg_planzlecenia SET pz_ilosczamdozreal=pz_ilosczamdozreal+delta WHERE pz_idplanu=idplanusrc;
    END IF;
    IF (flaganew&(4096+1024+32768)=5120) THEN -- Ilosc zamowiona
     UPDATE tg_planzlecenia SET pz_ilosczam=pz_ilosczam+delta WHERE pz_idplanu=idplanusrc; 
    END IF;
IF (flaganew&(4096+1024+32768)=0) THEN -- Nie zaczalem jeszcze realizacji
 UPDATE tg_planzlecenia SET pz_ilosczam=pz_ilosczam+delta, pz_ilosczamdozreal=pz_ilosczamdozreal+delta WHERE pz_idplanu=idplanusrc;
END IF;
   END IF;
  END IF;
  
  IF (TG_OP='DELETE') THEN
   IF (flagaold&(4096+1024+32768)=32768 OR flagaold&(4096+1024+32768)=33792) THEN -- Ilosc do realizacji
    UPDATE tg_planzlecenia SET pz_ilosczamdozreal=pz_ilosczamdozreal-zamowienieold WHERE pz_idplanu=idplanusrc;
   END IF;
   IF (flagaold&(4096+1024+32768)=5120) THEN -- Ilosc zamowiona
    UPDATE tg_planzlecenia SET pz_ilosczam=pz_ilosczam-zamowienieold WHERE pz_idplanu=idplanusrc; 
   END IF;
   IF (flagaold&(4096+1024+32768)=0) THEN -- Nie zaczalem jeszcze realizacji
UPDATE tg_planzlecenia SET pz_ilosczam=pz_ilosczam-zamowienieold, pz_ilosczamdozreal=pz_ilosczamdozreal-zamowienieold WHERE pz_idplanu=idplanusrc;
   END IF;
  END IF;
  
 END IF;
  
 IF (TG_OP='DELTE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW; 
END;
$$;
