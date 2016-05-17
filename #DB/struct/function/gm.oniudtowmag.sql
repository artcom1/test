CREATE FUNCTION oniudtowmag() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 usluga BOOL;
 fm_idind INT:=0;
 tmp INT:=0;
BEGIN
 
 IF (TG_OP='INSERT') THEN
  ---Jesli nie ma referencji
  IF (NEW.ttm_idxref IS NULL) THEN
   ---Zobacz czy towar ma refernecje do czegos
   tmp=(SELECT ttw_idxref FROM tg_towary WHERE ttw_idtowaru=NEW.ttw_idtowaru);
   ---Jesli ma
   IF (tmp IS NOT NULL) THEN
    --Sproboj wyznaczyc towmaga do ktorego trzeba sie podczepic
    NEW.ttm_idxref=(SELECT ttm_idtowmag FROM tg_towmag WHERE ttw_idtowaru=tmp AND tmg_idmagazynu=NEW.tmg_idmagazynu);
	IF (NEW.ttm_idxref IS NULL) THEN
	 INSERT INTO tg_towmag
	  (ttw_idtowaru,tmg_idmagazynu) 
	 VALUES
	  (tmp,NEW.tmg_idmagazynu);
	 NEW.ttm_idxref=currval('tg_towmag_s');
	END IF;    	
   END IF;
  END IF;
  NEW.ttm_rtowaru=(SELECT ttw_rtowaru FROM tg_towary WHERE ttw_idtowaru=NEW.ttw_idtowaru);
 END IF;
 
 IF (TG_OP<>'DELETE') THEN

  ---pobieramy indentyfikator centrali
  fm_idind=(SELECT fm_idindextab FROM tg_magazyny AS mag JOIN tb_firma AS f ON (mag.fm_idcentrali=f.fm_index) WHERE tmg_idmagazynu=NEW.tmg_idmagazynu);

   --- Sprawdzenie czy to jest usluga
  usluga=COALESCE((SELECT ttw_usluga FROM tg_towary WHERE ttw_idtowaru=NEW.ttw_idtowaru AND ttw_rtowaru NOT IN (128,256)),false);  

  --- Wyzerowanie stanu i wartosci jesli to usluga
  IF (usluga=TRUE) THEN
   NEW.ttm_stan=0;
   NEW.ttm_wartosc=0;
   NEW.ttm_cenasr=0;
  END IF;

  --- Zaokraglenie wartosci i stanu
  NEW.ttm_wartosc=round(NEW.ttm_wartosc,6);
  NEW.ttm_stan=round(NEW.ttm_stan,4);

  --- Obliczenie ceny sredniej
  IF (NEW.ttm_stan<>0) THEN
   NEW.ttm_cenasr=round(NEW.ttm_wartosc/NEW.ttm_stan,2);
  END IF;

   --- Reczne zmiany
  IF ((NEW.ttm_flaga&16384::int2)<>0) THEN
   NEW.ttm_flaga=NEW.ttm_flaga&(~16384::int2);
   RETURN NEW;
  END IF;

  IF (TG_OP='INSERT') THEN
   --- Zrob update stanu magazynowego
   UPDATE tg_towary SET 
          ttw_rezerwacja[fm_idind]=NullZero(ttw_rezerwacja[fm_idind])+NEW.ttm_rezerwacja,
          ttw_rezlekka[fm_idind]=NullZero(ttw_rezlekka[fm_idind])+NEW.ttm_rezlekka,
          ttw_stan[fm_idind]=NullZero(ttw_stan[fm_idind])+NEW.ttm_stan,
          ttw_bilanstk[fm_idind]=NullZero(ttw_bilanstk[fm_idind])+NEW.ttm_bilanstk,
          ttw_wartosc[fm_idind]=NullZero(ttw_wartosc[fm_idind])+NEW.ttm_wartosc,
          ttw_sumkwm=ttw_sumkwm+NEW.ttm_sumkwm,
          ttw_bkorderplus[fm_idind]=NullZero(ttw_bkorderplus[fm_idind])+NEW.ttm_bkorderplus,
          ttw_bkorderminus[fm_idind]=NullZero(ttw_bkorderminus[fm_idind])+NEW.ttm_bkorderminus,
          ttw_mmwdrodze[fm_idind]=NullZero(ttw_mmwdrodze[fm_idind])+NEW.ttm_mmwdrodze
          WHERE ttw_idtowaru=NEW.ttw_idtowaru AND
		  (
           NEW.ttm_rezerwacja!=0 OR NEW.ttm_rezlekka!=0 OR 
           NEW.ttm_stan!=0 OR NEW.ttm_bilanstk!=0 OR 
           NEW.ttm_wartosc!=0 OR NEW.ttm_sumkwm!=0 OR 
           NEW.ttm_bkorderplus!=0 OR NEW.ttm_bkorderminus!=0 OR 
           NEW.ttm_mmwdrodze!=0
		  );
		  
		  
   UPDATE tg_magazyny SET tmg_wartosc=NullZero(tmg_wartosc)+NEW.ttm_wartosc WHERE tmg_idmagazynu=NEW.tmg_idmagazynu AND NEW.ttm_wartosc!=0;
   
   IF (NEW.ttm_idxref IS NOT NULL) THEN
    UPDATE tg_towmag SET 
          ttm_stan=ttm_stan+NEW.ttm_stan,
          ttm_wartosc=ttm_wartosc+NEW.ttm_wartosc,
          ttm_bkorderplus=ttm_bkorderplus+NEW.ttm_bkorderplus,
          ttm_bkorderminus=ttm_bkorderminus+NEW.ttm_bkorderminus
	WHERE ttm_idtowmag=NEW.ttm_idxref AND
	      (
          NEW.ttm_stan!=0 OR
          NEW.ttm_wartosc!=0 OR
          NEW.ttm_bkorderplus!=0 OR
          NEW.ttm_bkorderminus!=0
		  );
   END IF;   
  END IF;


  IF (TG_OP='UPDATE') THEN
   --- Nie pozwol zmienic ID towaru ?
   IF (OLD.ttw_idtowaru IS DISTINCT FROM NEW.ttw_idtowaru) THEN
    RAISE EXCEPTION 'Nie mozna zmienic towaru przy update';
   END IF;
   IF (NEW.ttm_idxref IS DISTINCT FROM OLD.ttm_idxref) THEN
    RAISE EXCEPTION 'Nie mozna zmienic podindeksu przy update';
   END IF;
   --- Zrob update stanu magazynowego
   UPDATE tg_towary SET 
          ttw_rezerwacja[fm_idind]=NullZero(ttw_rezerwacja[fm_idind])+NEW.ttm_rezerwacja-OLD.ttm_rezerwacja,
          ttw_rezlekka[fm_idind]=NullZero(ttw_rezlekka[fm_idind])+NEW.ttm_rezlekka-OLD.ttm_rezlekka,
          ttw_stan[fm_idind]=NullZero(ttw_stan[fm_idind])+NEW.ttm_stan-OLD.ttm_stan,
          ttw_bilanstk[fm_idind]=NullZero(ttw_bilanstk[fm_idind])+NEW.ttm_bilanstk-OLD.ttm_bilanstk,
          ttw_wartosc[fm_idind]=NullZero(ttw_wartosc[fm_idind])+NEW.ttm_wartosc-OLD.ttm_wartosc,
          ttw_sumkwm=ttw_sumkwm+NEW.ttm_sumkwm-OLD.ttm_sumkwm,
          ttw_bkorderplus[fm_idind]=NullZero(ttw_bkorderplus[fm_idind])+NEW.ttm_bkorderplus-OLD.ttm_bkorderplus,
          ttw_bkorderminus[fm_idind]=NullZero(ttw_bkorderminus[fm_idind])+NEW.ttm_bkorderminus-OLD.ttm_bkorderminus,
          ttw_mmwdrodze[fm_idind]=NullZero(ttw_mmwdrodze[fm_idind])+NEW.ttm_mmwdrodze-OLD.ttm_mmwdrodze
          WHERE ttw_idtowaru=NEW.ttw_idtowaru AND
		  (
          NEW.ttm_rezerwacja!=OLD.ttm_rezerwacja OR
          NEW.ttm_rezlekka!=OLD.ttm_rezlekka OR
          NEW.ttm_stan!=OLD.ttm_stan OR
          NEW.ttm_bilanstk!=OLD.ttm_bilanstk OR
          NEW.ttm_wartosc!=OLD.ttm_wartosc OR
          NEW.ttm_sumkwm!=OLD.ttm_sumkwm OR
          NEW.ttm_bkorderplus!=OLD.ttm_bkorderplus OR
          NEW.ttm_bkorderminus!=OLD.ttm_bkorderminus OR
          NEW.ttm_mmwdrodze!=OLD.ttm_mmwdrodze
		  );
		  
   UPDATE tg_magazyny SET tmg_wartosc=NullZero(tmg_wartosc)+NEW.ttm_wartosc-OLD.ttm_wartosc 
   WHERE tmg_idmagazynu=NEW.tmg_idmagazynu AND (NEW.ttm_wartosc-OLD.ttm_wartosc!=0);
   
   IF (NEW.ttm_idxref IS NOT NULL) THEN
    UPDATE tg_towmag SET 
          ttm_stan=ttm_stan+NEW.ttm_stan-OLD.ttm_stan,
          ttm_wartosc=ttm_wartosc+NEW.ttm_wartosc-OLD.ttm_wartosc,
          ttm_bkorderplus=ttm_bkorderplus+NEW.ttm_bkorderplus-OLD.ttm_bkorderplus,
          ttm_bkorderminus=ttm_bkorderminus+NEW.ttm_bkorderminus-OLD.ttm_bkorderminus
	WHERE ttm_idtowmag=NEW.ttm_idxref AND
    	 (
          NEW.ttm_stan!=OLD.ttm_stan OR
          NEW.ttm_wartosc!=OLD.ttm_wartosc OR
          NEW.ttm_bkorderplus!=OLD.ttm_bkorderplus OR
          NEW.ttm_bkorderminus!=OLD.ttm_bkorderminus
		 );
   END IF;   
  END IF;

 END IF;

 IF (TG_OP='DELETE') THEN
  ---pobieramy indentyfikator centrali
  fm_idind=(SELECT fm_idindextab FROM tg_magazyny AS mag JOIN tb_firma AS f ON (mag.fm_idcentrali=f.fm_index) WHERE tmg_idmagazynu=OLD.tmg_idmagazynu);

  --- Zrob update stanu magazynowego
  UPDATE tg_towary SET 
         ttw_rezerwacja[fm_idind]=NullZero(ttw_rezerwacja[fm_idind])-OLD.ttm_rezerwacja,
         ttw_rezlekka[fm_idind]=NullZero(ttw_rezlekka[fm_idind])-OLD.ttm_rezlekka,
         ttw_stan[fm_idind]=NullZero(ttw_stan[fm_idind])-OLD.ttm_stan,
         ttw_bilanstk[fm_idind]=NullZero(ttw_bilanstk[fm_idind])-OLD.ttm_bilanstk,
         ttw_wartosc[fm_idind]=NullZero(ttw_wartosc[fm_idind])-OLD.ttm_wartosc,
         ttw_sumkwm=ttw_sumkwm-OLD.ttm_sumkwm,
         ttw_bkorderplus[fm_idind]=NullZero(ttw_bkorderplus[fm_idind])-OLD.ttm_bkorderplus,
         ttw_bkorderminus[fm_idind]=NullZero(ttw_bkorderminus[fm_idind])-OLD.ttm_bkorderminus,
         ttw_mmwdrodze[fm_idind]=NullZero(ttw_mmwdrodze[fm_idind])-OLD.ttm_mmwdrodze
         WHERE ttw_idtowaru=OLD.ttw_idtowaru AND
		 (
           OLD.ttm_rezerwacja!=0 OR OLD.ttm_rezlekka!=0 OR 
           OLD.ttm_stan!=0 OR OLD.ttm_bilanstk!=0 OR 
           OLD.ttm_wartosc!=0 OR OLD.ttm_sumkwm!=0 OR 
           OLD.ttm_bkorderplus!=0 OR OLD.ttm_bkorderminus!=0 OR 
           OLD.ttm_mmwdrodze!=0
		 );
		 
  UPDATE tg_magazyny SET tmg_wartosc=NullZero(tmg_wartosc)-OLD.ttm_wartosc 
  WHERE tmg_idmagazynu=OLD.tmg_idmagazynu AND OLD.ttm_wartosc!=0;
  
  IF (OLD.ttm_idxref IS NOT NULL) THEN
   UPDATE tg_towmag SET 
         ttm_stan=ttm_stan-OLD.ttm_stan,
         ttm_wartosc=ttm_wartosc-OLD.ttm_wartosc,
         ttm_bkorderplus=ttm_bkorderplus-OLD.ttm_bkorderplus,
         ttm_bkorderminus=ttm_bkorderminus-OLD.ttm_bkorderminus
    WHERE ttm_idtowmag=OLD.ttm_idxref AND
	      (
           OLD.ttm_stan!=0 OR
           OLD.ttm_wartosc!=0 OR
           OLD.ttm_bkorderplus!=0 OR
           OLD.ttm_bkorderminus!=0
		  );
  END IF;   
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (OLD.ttm_stan<>NEW.ttm_stan) OR
     (OLD.ttm_bilanstk<>NEW.ttm_bilanstk) OR
     (OLD.ttm_rezerwacja<>NEW.ttm_rezerwacja) OR
     (OLD.ttm_rezlekka<>NEW.ttm_rezlekka) OR
     (OLD.ttm_bkorderplus<>NEW.ttm_bkorderplus) OR
     (OLD.ttm_bkorderminus<>NEW.ttm_bkorderminus) OR
     (OLD.ttm_mmwdrodze<>NEW.ttm_mmwdrodze)
  THEN
   NEW.ttm_lastchange=now();
  END IF;
 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
