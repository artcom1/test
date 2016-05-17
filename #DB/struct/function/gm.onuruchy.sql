CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
---WSPOK
DECLARE
 delta_stan  v.delta;
 delta_wart  v.delta;
 delta_wartm v.delta;
 delta_tk    v.delta;
 delta_kwm   v.delta;
 delta_kwmm  v.delta;
 
 delta_poz   NUMERIC:=0;
 delta_wrt   NUMERIC:=0;
 delta_fvbuf NUMERIC:=0;
 delta_rez   NUMERIC:=0;
 delta_wrez  NUMERIC:=0;
 delta_lrez  NUMERIC:=0;
 delta_rezl  NUMERIC:=0;
 nadmiar     NUMERIC;
 t_ile       NUMERIC;
 ruch_data   RECORD;
 delta_odn   INT:=0;
 tmp         INT;
 wasblock    BOOL:=FALSE;
BEGIN

 IF (TG_OP = 'INSERT') THEN
  NEW.rc_flaga=NEW.rc_flaga&(~(1<<28));
  IF ((SELECT tr_zamknieta&1 FROM tg_transakcje WHERE tr_idtrans=NEW.tr_idtrans) IS NOT DISTINCT FROM 0) THEN
   NEW.rc_flaga=NEW.rc_flaga|(1<<28);  
  END IF;
 END IF;

 IF (TG_OP = 'UPDATE') THEN
 
  IF (isFV(OLD.rc_flaga) AND (OLD.rc_flaga&(1<<28))!=0) THEN
   delta_fvbuf=round((OLD.rc_iloscpoz-OLD.rc_iloscrezzr)*OLD.rc_kierunek,4);
  END IF;
  IF (isFV(NEW.rc_flaga) AND (NEW.rc_flaga&(1<<28))!=0) THEN
   delta_fvbuf=delta_fvbuf-round((NEW.rc_iloscpoz-NEW.rc_iloscrezzr)*NEW.rc_kierunek,4);
  END IF;
  
 
  IF ((NEW.rc_flaga&16384)<>0) THEN
   NEW.rc_flaga=NEW.rc_flaga&(~16384);

   IF (OLD.rc_ruch IS NOT DISTINCT FROM NEW.rc_ruch) THEN      
   
    IF (delta_fvbuf!=0) THEN
     UPDATE tg_ruchy SET rc_iloscwzbuf=round(rc_iloscwzbuf+delta_fvbuf,4)
	                 WHERE rc_idruchu=OLD.rc_ruch;
     delta_fvbuf=0;					 
    END IF;					 
     
    RETURN NEW;
   END IF;
  END IF;
  
 END IF;

 /* ---- Operacja typu update lub delete posiada OLD */
 IF (TG_OP = 'UPDATE') OR (TG_OP = 'DELETE') THEN
  /*---------------------------------------*/
  IF isPZet(OLD.rc_flaga) THEN
   IF (TG_OP = 'DELETE') AND ((round(OLD.rc_iloscpoz,4)<>round(OLD.rc_ilosc,4)) OR (round(OLD.rc_wartoscpoz,6)<>round(OLD.rc_wartoscpoz,6))) THEN
    RAISE EXCEPTION 'Nie mozna usunac tego ruchu gdyz juz z niego zdjeto';
   END IF;
   ---D--delta_stan=delta_stan-OLD.rc_iloscpoz;
   delta_stan.value_old=OLD.rc_iloscpoz;
   delta_stan.id_old=OLD.ttm_idtowmag;      
   IF (OLD.rc_wspwartosci>0) THEN
    ---D--delta_wart=delta_wart-OLD.rc_wartoscpoz;
    delta_wart.value_old=OLD.rc_wartoscpoz;
	delta_wart.id_old=OLD.ttm_idtowmag;
   ELSE
    ---D--delta_wartm=delta_wartm-OLD.rc_wartoscpoz;
    delta_wartm.value_old=OLD.rc_wartoscpoz;
	delta_wartm.id_old=OLD.ttm_idtowmag;
   END IF;
  END IF;
  /*---------------------------------------*/
  IF isKWM(OLD.rc_flaga) THEN
   IF (OLD.rc_wspwartosci>0) THEN
    ---D--delta_kwm=delta_kwm-OLD.rc_wartoscpoz;
	delta_kwm.value_old=OLD.rc_wartoscpoz;
	delta_kwm.id_old=OLD.ttm_idtowmag;
   ELSE
    ---D--delta_kwmm=delta_kwmm-OLD.rc_wartoscpoz;
	delta_kwmm.value_old=OLD.rc_wartoscpoz;
	delta_kwmm.id_old=OLD.ttm_idtowmag;
   END IF;
  END IF;
  /*---------------------------------------*/
  IF (isNTK(OLD.rc_flaga)) THEN
   IF (isPZet(OLD.rc_flaga)) THEN
    --- PZetka
    ---D--delta_tk=delta_tk-OLD.rc_ilosc;
	delta_tk.value_old=OLD.rc_ilosc;
	delta_tk.id_old=OLD.ttm_idtowmag;
   END IF;
   IF (isFV(OLD.rc_flaga)) THEN
    --- FVka
    ---D--delta_tk=delta_tk+OLD.rc_ilosc;
	delta_tk.value_old=-OLD.rc_ilosc;
	delta_tk.id_old=OLD.ttm_idtowmag;
   END IF;
  END IF;
  /*---------------------------------------*/
  IF isRezerwacja(OLD.rc_flaga) THEN
   delta_rez=round(-OLD.rc_iloscrez,4); --- Ilosc dostepna do zrealizowania poprzez FV
   delta_wrez=round(-(OLD.rc_ilosc-OLD.rc_iloscrezzr-OLD.rc_iloscrez),4); --- Ilosc dostepna do zrealizowania poprzez FV
   IF (isRezerwacjaLekka(OLD.rc_flaga)=TRUE) THEN
    delta_lrez=-OLD.rc_iloscrez;
   END IF;
   IF ((delta_rez<>0) OR (delta_lrez<>0) OR (delta_wrez!=0)) THEN --- Czy bula skojarzona z jakims PZetem
    IF (TG_OP = 'DELETE') THEN
     --- Zdejmij z towmaga ilosc zarezerwowana z ilosci dostepnej
     UPDATE tg_towmag SET ttm_rezerwacja=round(ttm_rezerwacja+delta_rez,4),ttm_rezlekka=ttm_rezlekka+delta_lrez WHERE ((delta_rez<>0) OR (delta_lrez<>0)) AND ttm_idtowmag=OLD.ttm_idtowmag;
     tmp=(SELECT tel_idelem FROM tg_transelem JOIN tg_transakcje USING (tr_idtrans) WHERE tel_idelem=OLD.tel_idelem);
     IF (tmp IS NOT NULL) THEN
      UPDATE tg_zamilosci 
	  SET zmi_if_reserved=round(zmi_if_reserved+delta_rez,4),
	      zmi_if_waitingtoreserve=round(zmi_if_waitingtoreserve+delta_wrez,4)
	  WHERE ((delta_rez<>0) OR (delta_wrez!=0)) AND tel_idelem=OLD.tel_idelem;
     END IF;
     delta_poz=0; --- Wyzeruj delty bo juz sciagnieto
     delta_rez=0;
	 delta_wrez=0;
     delta_lrez=0;
    ELSE
     IF (COALESCE(OLD.rc_ruch,0)<>COALESCE(NEW.rc_ruch,0)) OR 
        (nullZero(OLD.tel_idelem)<>nullZero(NEW.tel_idelem)) 
     THEN --- Zmienil sie PZet do ktorego podpieto rezerwacje
      --- Odejmij ilosc od ruchu PZ
      ----RAISE NOTICE 'Zmieniam ilosc na rezerwacji o %',delta_poz;
      UPDATE tg_ruchy SET rc_iloscrez=round(rc_iloscrez+delta_poz,4) WHERE rc_idruchu=OLD.rc_ruch; 
      --- Odejmij ilosc z towmaga, pozniej moze trzeba bedzie to znow updateowac, ale nie mamy pewnosci ze w NEW
      --- znajdziemy wolny PZet
      UPDATE tg_towmag SET ttm_rezerwacja=round(ttm_rezerwacja+delta_rez,4),ttm_rezlekka=ttm_rezlekka+delta_lrez WHERE ttm_idtowmag=NEW.ttm_idtowmag AND ((delta_rez!=0) OR (delta_lrez!=0));
      tmp=(SELECT tel_idelem FROM tg_transelem JOIN tg_transakcje USING (tr_idtrans) WHERE tel_idelem=OLD.tel_idelem);
      IF (tmp IS NOT NULL) THEN
       UPDATE tg_zamilosci 
	   SET zmi_if_reserved=round(zmi_if_reserved+delta_rez,4),
	       zmi_if_waitingtoreserve=round(zmi_if_waitingtoreserve+delta_wrez,4)
	   WHERE ((delta_rez<>0) OR (delta_wrez!=0)) AND tel_idelem=OLD.tel_idelem;
      END IF;
      --- Wyzeruj delty
      delta_rez=0;
      delta_lrez=0;
      delta_poz=0;
	  delta_wrez=0;
     END IF;
    END IF;
   END IF;
  END IF;
  /*---------------------------------------*/
  IF isKPZ(OLD.rc_flaga) OR isKPZP(OLD.rc_flaga)  THEN
   delta_poz=-round(OLD.rc_iloscpoz*OLD.rc_kierunek,4);    --- Z minusem bo delty beda ujemne
   delta_wrt=-round(OLD.rc_wartoscpoz*OLD.rc_kierunek,6);
   IF (TG_OP = 'DELETE') THEN --- Kasowanie wiec dodaj natychmiast delte
    UPDATE tg_ruchy SET rc_iloscpoz=round(rc_iloscpoz+delta_poz,4),
                        rc_wartoscpoz=round(rc_wartoscpoz+delta_wrt,6) 
		    WHERE rc_idruchu=OLD.rc_ruch;
     delta_poz=0;
     delta_wrt=0;
    ELSE
     IF (NEW.rc_ruch<>OLD.rc_ruch) THEN --- Zmieniony ruch, dodaj natychmiast delte
      UPDATE tg_ruchy SET rc_iloscpoz=round(rc_iloscpoz+delta_poz,4),
                          rc_wartoscpoz=round(rc_wartoscpoz+delta_wrt,6) 
		      WHERE rc_idruchu=OLD.rc_ruch;
      delta_poz=0;
      delta_wrt=0;
     END IF;
    END IF;
  END IF;
  /*---------------------------------------*/
  IF isFV(OLD.rc_flaga) OR iskFV(OLD.rc_flaga) OR isKFVP(OLD.rc_flaga) THEN
   delta_poz=-round(OLD.rc_iloscpoz*OLD.rc_kierunek,4); --- Wartosc dodatnia
   delta_wrt=-round(OLD.rc_wartoscpoz*OLD.rc_kierunek,6); -- Wartosc dodatnia
   IF (OLD.rc_flaga&(1<<25))=0 THEN
    delta_rez=-round(OLD.rc_iloscrez*OLD.rc_kierunekrez,4); --- Wartosc dodatnia
   END IF;
   IF (OLD.rc_flaga&(1<<28))!=0 THEN
    delta_fvbuf=round((OLD.rc_iloscpoz-OLD.rc_iloscrezzr)*OLD.rc_kierunek,4);
   END IF;
   delta_rezl=-round(OLD.rc_iloscrez*OLD.rc_kierunek,4); --- Wartosc dodatnia
   IF (NOT (OLD.rc_ruch=NULL)) THEN --- (ORCR)

    --UWAGA: Bylo tu

    IF (TG_OP = 'DELETE') THEN --- (IFDE)
     IF (isFV(OLD.rc_flaga)) THEN 
      delta_odn=1; 
     ELSE 
      delta_odn=0; 
     END IF;
 
     ---Uwaga: Jest tutaj
     IF (delta_rezl>0) THEN
      --- Odejmujemy delte gdyz ruch FV podwyzsza te ilosc na rezerwacji a nie obniza
      PERFORM gm.blockPZet(NULL,true);
	  PERFORM gm.blockTriggerFunction('CHECKRLP',1);
      UPDATE tg_ruchy SET rc_iloscrezzr=round(rc_iloscrezzr-delta_rezl,4) WHERE rc_idruchu=OLD.rc_rezerwacja;
	  PERFORM gm.blockTriggerFunction('CHECKRLP',-1);
      PERFORM gm.blockPZet(NULL,false);
      delta_rezl=0;
     END IF;

     UPDATE tg_ruchy SET rc_odn=rc_odn-delta_odn,
                         rc_iloscpoz=round(rc_iloscpoz+delta_poz,4),
			             rc_wartoscpoz=round(rc_wartoscpoz+delta_wrt,6),
			             rc_iloscrezzr=round(rc_iloscrezzr-delta_rez,4), 
						 rc_iloscwzbuf=round(rc_iloscwzbuf+delta_fvbuf,4)
	                 WHERE rc_idruchu=OLD.rc_ruch;
     delta_poz=0;
     delta_wrt=0;
     delta_rez=0;
	 delta_fvbuf=0;
    ELSE --- (IFDE)
     IF (NEW.rc_ruch<>OLD.rc_ruch) THEN
      IF (isFV(OLD.rc_flaga)) THEN
       delta_odn=1; 
      ELSE 
       delta_odn=0; 
      END IF;
      UPDATE tg_ruchy SET rc_odn=rc_odn-delta_odn,
                          rc_iloscpoz=round(rc_iloscpoz+delta_poz,4),
			              rc_wartoscpoz=round(rc_wartoscpoz+delta_wrt,6),
			              rc_iloscrezzr=round(rc_iloscrezzr-delta_rez,4),
    				   	  rc_iloscwzbuf=round(rc_iloscwzbuf+delta_fvbuf,4)
		              WHERE rc_idruchu=OLD.rc_ruch;
      delta_poz=0;
      delta_wrt=0;
      delta_rez=0;
	  delta_fvbuf=0;
     END IF;
    END IF; --- (OF IFDE)
 
    --UWAGA: Przeniesione tu
    IF (TG_OP = 'UPDATE') THEN
     IF (COALESCE(NEW.rc_rezerwacja,0)<>COALESCE(OLD.rc_rezerwacja,0)) THEN
      UPDATE tg_ruchy SET rc_iloscrezzr=round(rc_iloscrezzr-delta_rezl,4) WHERE rc_idruchu=OLD.rc_rezerwacja;
      delta_rezl=0;
     END IF;
    END IF;

   END IF; --- (OF ORCR)
  END IF; -- (OF FV,KFV)

  /*---------------------------------------*/
 
 END IF; --- (OF UD)

 /* ---- Operacja typu update lub insert - posiada NEW */

 IF (TG_OP = 'UPDATE') OR (TG_OP = 'INSERT') THEN

  /*---------------------------------------*/  
  IF isPZet(NEW.rc_flaga) THEN
   IF (NEW.prt_idpartiipz IS NULL) THEN
    NEW.prt_idpartiipz=gm.getIDNULLPartii(NEW.ttw_idtowaru,TRUE,1);
   END IF;
   IF (NEW.rc_iloscpoz>0) THEN
    IF ((NEW.rc_flaga&131072)<>0) THEN
     NEW.rc_flaga=NEW.rc_flaga&(~131072);
    ELSE
     IF (round(NEW.rc_iloscpoz*NEW.rc_cenajedn,2)<>NEW.rc_wartoscpoz*NEW.rc_wspwartosci) THEN
      NEW.rc_cenajedn=round(NEW.rc_wartoscpoz*NEW.rc_wspwartosci/NEW.rc_iloscpoz,4);
     END IF;
    END IF;
   END IF;
   IF (NEW.rc_iloscpoz<0) THEN
    RAISE EXCEPTION '50|%:%:%:%|Nie mozna zmniejszyc az o tyle ilosci na PZ % (dla PZ %)',NEW.tr_idtrans,NEW.tel_idelem,NEW.rc_idruchu,NEW.rc_iloscpoz,NEW.rc_iloscpoz,NEW.rc_idruchu;
   END IF;
   ---D--delta_stan=delta_stan+NEW.rc_iloscpoz;
   delta_stan.value_new=NEW.rc_iloscpoz;
   delta_stan.id_new=NEW.ttm_idtowmag;
   IF (NEW.rc_wspwartosci>0) THEN
    ---D--delta_wart=delta_wart+NEW.rc_wartoscpoz;
	delta_wart.value_new=NEW.rc_wartoscpoz;
	delta_wart.id_new=NEW.ttm_idtowmag;
   ELSE
    ---D--delta_wartm=delta_wartm+NEW.rc_wartoscpoz;
	delta_wartm.value_new=NEW.rc_wartoscpoz;
	delta_wartm.id_new=NEW.ttm_idtowmag;
   END IF;
   IF (TG_OP='INSERT') THEN
    NEW.rc_flaga=NEW.rc_flaga|8192;
   END IF;
  END IF;
  /*---------------------------------------*/  
  IF isKWM(NEW.rc_flaga) THEN
   IF (NEW.rc_wspwartosci>0) THEN
    ---D--delta_kwm=delta_kwm+NEW.rc_wartoscpoz;
	delta_kwm.value_new=NEW.rc_wartoscpoz;
	delta_kwm.id_new=NEW.ttm_idtowmag;
   ELSE
    ---D--delta_kwmm=delta_kwmm+NEW.rc_wartoscpoz;
	delta_kwmm.value_new=NEW.rc_wartoscpoz;
	delta_kwmm.id_new=NEW.ttm_idtowmag;
   END IF;
  END IF;
  /*---------------------------------------*/
  IF (isNTK(NEW.rc_flaga)) THEN
   IF (isPZet(NEW.rc_flaga)) THEN
    --- PZetka
    ---D--delta_tk=delta_tk+NEW.rc_ilosc;
	delta_tk.value_new=NEW.rc_ilosc;
	delta_tk.id_new=NEW.ttm_idtowmag;
   END IF;
   IF (isFV(NEW.rc_flaga)) THEN
    --- FVka
    ---D--delta_tk=delta_tk-NEW.rc_ilosc;
	delta_tk.value_new=-NEW.rc_ilosc;
	delta_tk.id_new=NEW.ttm_idtowmag;
   END IF;
  END IF;
  /*---------------------------------------*/
  IF isKPZ(NEW.rc_flaga) OR isKPZP(NEW.rc_flaga) THEN
   delta_poz=round(delta_poz+NEW.rc_iloscpoz*NEW.rc_kierunek,4);
   delta_wrt=round(delta_wrt+NEW.rc_wartoscpoz*NEW.rc_kierunek,6);
   IF (delta_poz<>0) OR (delta_wrt<>0) THEN
    UPDATE tg_ruchy SET rc_iloscpoz=round(rc_iloscpoz+delta_poz,4),rc_wartoscpoz=round(rc_wartoscpoz+delta_wrt,6) WHERE rc_idruchu=NEW.rc_ruch;
   END IF;
  END IF;
  /*---------------------------------------*/
  IF isFV(NEW.rc_flaga) OR iskFV(NEW.rc_flaga) OR isKFVP(NEW.rc_flaga) THEN
   IF (NEW.rc_seqid IS NULL) THEN NEW.rc_seqid=nextval('tg_ruchy_seqid'); END IF;
   IF (NEW.rc_rezerwacja=NULL) THEN NEW.rc_iloscrez=0; END IF;
   IF (NEW.rc_iloscrez>NEW.rc_ilosc) THEN --- Wiecej wykorzystano z rezerwacji niz jest na fakturze, zmniejsz wiec ilosc z rezerwacji
    NEW.rc_iloscrez=round(NEW.rc_ilosc,4); 
   END IF;
   IF isFV(NEW.rc_flaga) AND (TG_OP='INSERT') THEN --- Zwieksz ilosc odnosnikow
    delta_odn=1; 
   END IF;
   IF (TG_OP='INSERT') AND (NEW.rc_rezerwacja IS NOT NULL) THEN
    tmp=(SELECT (rc_flaga&(1<<24))<<1 FROM tg_ruchy WHERE rc_idruchu=NEW.rc_rezerwacja);    
    NEW.rc_flaga=(NEW.rc_flaga&(~(1<<25)))|tmp;
   END IF;
   IF (TG_OP='UPDATE') THEN
    IF (NEW.rc_rezerwacja IS DISTINCT FROM OLD.rc_rezerwacja) THEN
     tmp=COALESCE((SELECT (rc_flaga&(1<<24))<<1 FROM tg_ruchy WHERE rc_idruchu=NEW.rc_rezerwacja),0);    
     NEW.rc_flaga=(NEW.rc_flaga&(~(1<<25)))|tmp;
    END IF;
   END IF;

   delta_poz=round(delta_poz+NEW.rc_iloscpoz*NEW.rc_kierunek,4); -- Wartosc ujemna
   delta_wrt=round(delta_wrt+NEW.rc_wartoscpoz*NEW.rc_kierunek,6); --- Wartosc ujemna
   IF (NEW.rc_flaga&(1<<25))=0 THEN
    delta_rez=round(delta_rez+NEW.rc_iloscrez*NEW.rc_kierunekrez,4); --- Wartosc ujemna
   END IF;
   IF (NEW.rc_flaga&(1<<28))!=0 THEN
    ---RAISE NOTICE 'Delta przed % ',delta_fvbuf;
    delta_fvbuf=delta_fvbuf-round((NEW.rc_iloscpoz-NEW.rc_iloscrezzr)*NEW.rc_kierunek,4);
   END IF;
   delta_rezl=round(delta_rezl+NEW.rc_iloscrez*NEW.rc_kierunekrez,4); --- Wartosc ujemna
   
   ---RAISE NOTICE 'Delta % ',delta_fvbuf;

   ---RAISE NOTICE 'Dla % delta % ',NEW.rc_rezerwacja,delta_rezl;

   ---UWAGA: Bylo tutaj
   IF (delta_rezl<0) THEN
    --- Odejmujemy delte gdyz ruch FV podwyzsza te ilosc na rezerwacji a nie obniza
    PERFORM gm.blockPZet(NULL,true);
    PERFORM gm.blockTriggerFunction('CHECKRLP',1);
    UPDATE tg_ruchy SET rc_iloscrezzr=round(rc_iloscrezzr-delta_rezl,4) WHERE rc_idruchu=NEW.rc_rezerwacja;
    PERFORM gm.blockTriggerFunction('CHECKRLP',-1);
    PERFORM gm.blockPZet(NULL,false);
    delta_rezl=0;
   END IF;

   ---Uwaga: Jest tutaj
   IF (delta_rezl>0) THEN
    --- Odejmujemy delte gdyz ruch FV podwyzsza te ilosc na rezerwacji a nie obniza
    PERFORM gm.blockPZet(NULL,true);
    PERFORM gm.blockTriggerFunction('CHECKRLP',1);
    UPDATE tg_ruchy SET rc_iloscrezzr=round(rc_iloscrezzr-delta_rezl,4) WHERE rc_idruchu=NEW.rc_rezerwacja;
    PERFORM gm.blockTriggerFunction('CHECKRLP',-1);
    PERFORM gm.blockPZet(NULL,false);
    delta_rezl=0;
   END IF;


   IF (delta_poz<>0) OR (delta_wrt<>0) OR (delta_rez<>0) OR (delta_fvbuf<>0) THEN
    ---Cos sie zmienilo, zrob update na skojarzonym PZecie (lub skojarzonej korekcie :)
    ----RAISE NOTICE 'Robie % % % %',delta_poz,delta_wrt,delta_rez,delta_rezl;
    UPDATE tg_ruchy SET rc_odn=rc_odn+delta_odn,
                        rc_iloscpoz=round(rc_iloscpoz+delta_poz,4),
			            rc_wartoscpoz=round(rc_wartoscpoz+delta_wrt,6),
			            rc_iloscrezzr=round(rc_iloscrezzr-delta_rez,4),
  	                    rc_iloscwzbuf=round(rc_iloscwzbuf+delta_fvbuf,4)
		            WHERE rc_idruchu=NEW.rc_ruch;
   END IF;


   IF (NEW.rc_iloscrez=0) THEN NEW.rc_rezerwacja=NULL; END IF;   
  END IF;
  /*---------------------------------------*/
  IF isRezerwacja(NEW.rc_flaga) THEN
   IF (NEW.rc_iloscpoz>NEW.rc_ilosc) THEN ---Znaleziono wiecej PZetow niz potrzeba, ustal ilosc znaleziona na PZetach na rc_ilosc
    NEW.rc_iloscpoz=round(NEW.rc_ilosc,4); 
    ----RAISE NOTICE 'R - korekta ilosci ';
   END IF;
   IF (NEW.rc_ruch=NULL) AND ((NEW.rc_flaga&(1<<24))=0) THEN ---Nie podczepione do PZeta wiec ustaw ilosc znaleziona na PZetach na 0
    NEW.rc_iloscpoz=0; 
    ---RAISE NOTICE 'R - nic nie podczepione ';
   END IF;

   IF (TG_OP='UPDATE') THEN
    IF (NEW.prt_idpartiiwz IS DISTINCT FROM OLD.prt_idpartiiwz) THEN
     IF (NEW.prt_idpartiiwz IS NOT DISTINCT FROM gm.getIDNULLPartii(NEW.ttw_idtowaru,FALSE,-1)) THEN
      NEW.rc_flaga=NEW.rc_flaga|(1<<26);
     END IF;
    END IF;
   ELSE
    IF (NEW.prt_idpartiiwz IS NOT DISTINCT FROM gm.getIDNULLPartii(NEW.ttw_idtowaru,FALSE,-1)) THEN
     NEW.rc_flaga=NEW.rc_flaga|(1<<26);
    END IF;
   END IF;
  
   --- Ilosc dostepna do sciagniecia przez FV=Ilosc dla ktorej znaleziono PZety-Ilosc zrealizowana przez FV
   NEW.rc_iloscrez=(NEW.rc_iloscpoz-NEW.rc_iloscrezzr);
   delta_rez=round(delta_rez+NEW.rc_iloscrez,4); --- Zmiana ilosci zarezerwowanej i nie zrealizowanej
   delta_wrez=round(delta_wrez+(NEW.rc_ilosc-NEW.rc_iloscrezzr-NEW.rc_iloscrez),4);
   ---RAISE NOTICE 'Ilosci % % % (%)',NEW.rc_ilosc,NEW.rc_iloscrezzr,NEW.rc_iloscrez,delta_wrez;

   IF (isRezerwacjaLekka(NEW.rc_flaga)=TRUE) THEN
    delta_lrez=delta_lrez+NEW.rc_iloscrez;
   END IF;

   IF (delta_rez<>0) OR (delta_lrez<>0) OR (delta_wrez!=0) THEN
    UPDATE tg_towmag SET ttm_rezerwacja=round(ttm_rezerwacja+delta_rez,4),ttm_rezlekka=ttm_rezlekka+delta_lrez WHERE ttm_idtowmag=NEW.ttm_idtowmag AND ((delta_rez!=0) OR (delta_lrez!=0));
    UPDATE tg_zamilosci 
	SET zmi_if_reserved=round(zmi_if_reserved+delta_rez,4),
	    zmi_if_waitingtoreserve=round(zmi_if_waitingtoreserve+delta_wrez,4)
	WHERE ((delta_rez<>0) OR (delta_wrez!=0)) AND tel_idelem=NEW.tel_idelem;
   END IF;
   
   ---Nic nie jest zarezerwowane poprzez PZet wiec nie utrzymuj skojarzenia
   IF (NEW.rc_iloscpoz=0) THEN 
    ----RAISE NOTICE 'Nullowanie ruchu';
    NEW.rc_ruch=NULL; 
   END IF;

   IF (NEW.rc_ilosc=0) THEN
    NEW.tr_idtrans=NULL;
    NEW.tel_idelem=NULL;
   END IF;

   IF (NEW.rc_ilosc<0) THEN
    RAISE EXCEPTION 'Blad przy rezerwacjach ID Ruchu: % i % , ID TransElemu % Ilosc %',NEW.rc_idruchu,NEW.rc_ruch,NEW.tel_idelem,NEW.rc_ilosc;
   END IF;

   IF ((NEW.rc_flaga&524288=0)) THEN
    PERFORM DodajBackorderRuchy(NEW.rc_idruchu,NEW.ttm_idtowmag,NEW.rc_ilosc-NEW.rc_iloscpoz,1,NEW.rc_data,(SELECT zl_idzlecenia FROM tg_transakcje WHERE tr_idtrans=NEW.tr_idtrans));
   ELSE
    PERFORM DodajBackorderRuchy(NEW.rc_idruchu,NEW.ttm_idtowmag,0,1,NEW.rc_data,(SELECT zl_idzlecenia FROM tg_transakcje WHERE tr_idtrans=NEW.tr_idtrans));
   END IF;

/*
   IF (TG_OP='UPDATE') AND RCisRezerwacjaR(NEW.rc_flaga) THEN
    IF (NEW.k_idklienta<>OLD.k_idklienta) AND NOT (NEW.tel_idelem=NULL) THEN
     NEW.rc_flaga=NEW.rc_flaga|512;
     PERFORM dodaj_rezerwacje(NEW.rc_ilosc,NULL,NULL,NEW.ttw_idtowaru,NEW.ttm_idtowmag,NEW.tmg_idmagazynu,-OLD.k_idklienta,OLD.rc_data);
    END IF;
   END IF;
*/
  END IF;
  IF (NEW.rc_iloscrez=4) AND isRezerwacja(NEW.rc_flaga) THEN
  ---- RAISE EXCEPTION 'Dotarlem';
  END IF;
END IF;

 ---Operacje tylko i wylacznie w momencie update - sprawdzenia warunkow
 IF (TG_OP = 'UPDATE') THEN
  /*---------------------------------------*/
  IF isPZet(NEW.rc_flaga) THEN
  
   IF ((NEW.rc_flaga&(1<<21))=0) AND  (((NEW.rc_iloscpoz=0) AND (NEW.rc_wartoscpoz<>0)) OR (NEW.rc_wartoscpoz*NEW.rc_wspwartosci<0)) THEN
    IF (gm.istriggerfunctionactive('CHECKPZWARTOSCZEROILOSC',NEW.rc_idruchu)=TRUE) THEN
     RAISE EXCEPTION 'PZet z wartoscia przy zerowej ilosci! TEID: %,Wartosc: %, Ruch %, Wspolczynnik %',NEW.tel_idelem,NEW.rc_wartoscpoz,NEW.rc_idruchu,NEW.rc_wspwartosci;
	END IF;
   END IF;

   IF (NEW.rc_iloscpoz>OLD.rc_iloscpoz) OR 
      (NEW.rc_iloscrez<OLD.rc_iloscrez) OR 
      (isBlockedPZ(OLD.rc_flaga) AND NOT isBlockedPZ(NEW.rc_flaga)) OR
      (isAPZet(OLD.rc_flaga)<>isAPZet(NEW.rc_flaga))
   THEN   --- Zwiekszenie ilosci na PZecie, sproboj doczepic do tego wolne rezerwacje
    NEW.rc_flaga=NEW.rc_flaga|8192;
   ELSE
    NEW.rc_flaga=NEW.rc_flaga&(~8192);
   END IF; 

  END IF;
  /*---------------------------------------*/
  IF isKWM(NEW.rc_flaga) THEN
  END IF;
  /*---------------------------------------*/
  IF isNTK(NEW.rc_flaga) THEN
   IF (NEW.ttm_idtowmag<>OLD.ttm_idtowmag) THEN
    RAISE EXCEPTION 'Nie mozna zmienic towmaga na BTK';
   END IF;
  END IF;

 END IF;
 

 IF (TG_OP = 'INSERT') THEN
 
  IF isAPZet(NEW.rc_flaga) OR isPZet(NEW.rc_flaga) THEN
   IF ((NEW.rc_flaga&(1<<30))=0) THEN
    RAISE EXCEPTION 'Dodanie PZ (lub APZ) bez uwzglednienia jednostek logistycznych!';
   END IF;
   NEW.rc_flaga=NEW.rc_flaga&(~(1<<30));
   PERFORM gm.mrpp_guardOnRuch(NEW.mrpp_idpalety,NEW.tmg_idmagazynu,NEW.mm_idmiejsca);
  END IF;

  IF isAPZet(NEW.rc_flaga) THEN
   IF (NEW.rc_dostawa=NULL) THEN
    NEW.rc_dostawa=NEW.rc_idruchu;
   END IF;
   NEW.rc_ruchpz=NEW.rc_idruchu;
  END IF;

  IF isPZet(NEW.rc_flaga) THEN
   NEW.rc_ruchpz=NEW.rc_idruchu;
   NEW.rc_flaga=NEW.rc_flaga|8192;
   NEW.rc_wspmag=NEW.rc_kierunek;
   IF (NEW.rc_dostawa=NULL) THEN
    NEW.rc_dostawa=NEW.rc_idruchu;
   END IF;
  ELSE
   IF NOT (NEW.rc_ruch=NULL) THEN
    SELECT rc_wspmag,rc_dostawa,rc_ruchpz INTO ruch_data FROM tg_ruchy WHERE rc_idruchu=NEW.rc_ruch;
    NEW.rc_dostawa=ruch_data.rc_dostawa;
    NEW.rc_wspmag=NEW.rc_kierunek*ruch_data.rc_wspmag;
	IF (NEW.rc_wspmag!=0) THEN
  	 NEW.rc_ruchpz=ruch_data.rc_ruchpz;
	END IF;
   END IF;
  END IF;

 END IF;

 -----------------------------------------------------------------------------------------------------------------------------------------------------------
 IF ((v.deltavalueold(delta_stan)<>0) OR (v.deltavalueold(delta_wart)<>0) OR (v.deltavalueold(delta_kwm)<>0) OR (v.deltavalueold(delta_tk)<>0)) THEN
  IF (isPZet(OLD.rc_flaga) OR isKWM(OLD.rc_flaga)) THEN
   UPDATE tg_towmag SET ttm_stan=ttm_stan-v.deltavalueold(delta_stan),
                        ttm_wartosc=ttm_wartosc-v.deltavalueold(delta_wart),
			            ttm_sumkwm=ttm_sumkwm-v.deltavalueold(delta_kwm),
			            ttm_bilanstk=ttm_bilanstk-v.deltavalueold(delta_tk) 
		            WHERE ttm_idtowmag=OLD.ttm_idtowmag;
  END IF; 
 END IF;

 IF ((v.deltavaluenew(delta_stan)<>0) OR (v.deltavaluenew(delta_wart)<>0) OR (v.deltavaluenew(delta_kwm)<>0) OR (v.deltavaluenew(delta_tk)<>0)) THEN
  IF (isPZet(NEW.rc_flaga) OR isKWM(NEW.rc_flaga)) THEN
   UPDATE tg_towmag SET ttm_stan=ttm_stan+v.deltavaluenew(delta_stan),
                        ttm_wartosc=ttm_wartosc+v.deltavaluenew(delta_wart),
			            ttm_sumkwm=ttm_sumkwm+v.deltavaluenew(delta_kwm),
			            ttm_bilanstk=ttm_bilanstk+v.deltavaluenew(delta_tk) 
		            WHERE ttm_idtowmag=NEW.ttm_idtowmag;
  END IF; 
 END IF;
 
 -----------------------------------------------------------------------------------------------------------------------------------------------------------

 IF (TG_OP = 'DELETE') THEN
  RETURN OLD;
 END IF;
 
 NEW.rc_wartoscpoz=round(NEW.rc_wartoscpoz,6);
 RETURN NEW;
END;
$$;
