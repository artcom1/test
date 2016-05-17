CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 iter INT;
 wartoscold NUMERIC:=0;
 wartoscnew NUMERIC:=0;
 rec        RECORD;
 tmp        TEXT;
 pobraniedanychzojca BOOL:=FALSE;
 struktura RECORD;
 iloscmat   NUMERIC:=0;
 przeliczenie   BOOL:=FALSE;
 rekordprodukcyjny    BOOL:=FALSE;
BEGIN
 -----------------------------------------------------------------------------------------------------
 ----Ustawienie flagi automatycznego wykonania planu
 -----------------------------------------------------------------------------------------------------
 IF (TG_OP <> 'DELETE') THEN
  IF (NEW.pz_ilosczreal>=NEW.pz_ilosc) THEN
   NEW.pz_flaga=NEW.pz_flaga|(1<<1);
  ELSE
   NEW.pz_flaga=NEW.pz_flaga&(~(1<<1));
  END IF;
 END IF;
 -----------------------------------------------------------------------------------------------------
 ----Koniec flag automatycznego wykonania planu
 -----------------------------------------------------------------------------------------------------

 IF (TG_OP = 'INSERT') THEN
  IF (NEW.pz_idrewizja IS NOT NULL) THEN
   NEW.pz_lp=(SELECT pz_lp FROM tg_planzlecenia WHERE pz_idplanu=NEW.pz_idrewizja);
  ELSE  
   IF ((NEW.pz_flaga&(1<<9))=(1<<9) AND NEW.pz_idref>0) THEN
    iter=(SELECT pz_lp FROM tg_planzlecenia WHERE pz_idplanu=NEW.pz_idref);
   ELSE
    iter=(SELECT 1+NullZero(max(pz_lp)) FROM tg_planzlecenia WHERE zl_idzlecenia=NEW.zl_idzlecenia AND pz_flaga&((1<<11)|(1<<14))=NEW.pz_flaga&((1<<11)|(1<<14)));
   END IF;

   NEW.pz_lp=iter;
   IF (NEW.pz_idref>0) THEN
    wartoscnew=round(NEW.pz_ilosc*NEW.pz_cena,2);
    PERFORM zwiekszPowiazaniePlanu(NEW.pz_idref);
   END IF;
  END IF;
  --------------------------------------------------------------------------------------------------
  ---ustalamy informacje czy to plan produkcyjny oraz czy wymaga on oznaczenia z planu backorderow
  --------------------------------------------------------------------------------------------------
  SELECT zl_typ, zl_status INTO rec FROM tg_zlecenia WHERE zl_idzlecenia=NEW.zl_idzlecenia;
  IF (rec.zl_typ=1) THEN ---produkcja
   ----sprawdzamy czy gdy mamy ojca to ojciec to komplet, jak tak to oznaczamy ten plan ze ma ojca jako komplet (w takich przypadkach nie robimy zapotrzebowania z tych planow)
   IF (NEW.pz_idref>0) THEN
    tmp=(SELECT ttw_flaga&262144 FROM tg_planzlecenia JOIN tg_towary USING (ttw_idtowaru) WHERE pz_idplanu=NEW.pz_idref);
    IF (tmp='262144') THEN
     NEW.pz_flaga=NEW.pz_flaga|(1<<29);
    END IF;
   END IF;

   NEW.pz_flaga=NEW.pz_flaga|(1<<18);
   ----sprawdzamy czy sa ustawienia pod oczekiwane pod planem zlecenia w konfiguracji vendo
   tmp=(SELECT cf_defvalue FROM tc_config WHERE cf_tabela='planzlec_oczekiwane');
   IF (tmp='1') THEN
    NEW.pz_flaga=NEW.pz_flaga|(1<<17);
   END IF;
   ---sprawdzamy czy sa ustawienia pod zapotrzebowanie wynikajace z planu zlecenia w konfiguracji vendo
   tmp=(SELECT cf_defvalue FROM tc_config WHERE cf_tabela='planzlec_zapotrzebowanie');
   IF (tmp='1') THEN
    NEW.pz_flaga=NEW.pz_flaga|(1<<20); ---zapotrzebowanie wedlug ilosci niewykonanej z ojca planu
   ELSE
    IF (tmp='2') THEN
     NEW.pz_flaga=NEW.pz_flaga|(1<<21); ---zapotrzebowanie wedlug ilosci niezaplanowanej z ojca planu
    END IF;
   END IF;
   ---sprawdzamy czy sa ustawienia pod zapotrzebowanie materialu wynikajacego z planu
   tmp=(SELECT cf_defvalue FROM tc_config WHERE cf_tabela='planzlec_zapotrzebmat');
   IF (tmp='1') THEN
    NEW.pz_flaga=NEW.pz_flaga|(1<<23); ---zapotrzebowanie na material
   END IF;
  END IF;
  IF (rec.zl_status&14=(2<<1) OR rec.zl_status&14=(3<<1) ) THEN ---zlecenie wykonane lub anulowane
   NEW.pz_flaga=NEW.pz_flaga|(1<<16);
  END IF;
  --------------------------------------------------------------------------------------------------
  ---koniec przenoszenia danych na plan ze zlecenia oraz konfiguracji programu
  --------------------------------------------------------------------------------------------------

 IF (NEW.pz_flaga&(1<<18)=(1<<18) AND NEW.pz_flaga&(1<<28)=0 ) THEN
   ---plan produkcyjny i nie bylo zmieniane dane elementu przez uzytkownika, auktualniamy pola zwiazane ze struktura konstrukcyjna
   SELECT sk_idstruktury, sk_wymiar_x, sk_wymiar_y, sk_wymiar_z, sk_naddatek_x, sk_naddatek_y, sk_naddatek_z, sk_narzut_procent, sk_operacja1, sk_operacja2, sk_operacja3, sk_operacja4, ttw_idmaterialu INTO struktura FROM tr_strukturakonstrukcyjna WHERE ttw_idtowaru=NEW.ttw_idtowaru AND sk_flaga&((1<<0)|(1<<5)|(1<<6))=((1<<0)|(1<<5));
   IF FOUND THEN
    ---mam strukture wiec przepisujemy pola ze struktury do planu zlecenia
    NEW.sk_idstruktury=struktura.sk_idstruktury;
    NEW.pz_wymiar_x=struktura.sk_wymiar_x;
    NEW.pz_wymiar_y=struktura.sk_wymiar_y;
    NEW.pz_wymiar_z=struktura.sk_wymiar_z;
    NEW.pz_naddatek_x=struktura.sk_naddatek_x;
    NEW.pz_naddatek_y=struktura.sk_naddatek_y;
    NEW.pz_naddatek_z=struktura.sk_naddatek_z;
    NEW.pz_narzut_procent=struktura.sk_narzut_procent;
    NEW.pz_operacja1=struktura.sk_operacja1;
    NEW.pz_operacja2=struktura.sk_operacja2;
    NEW.pz_operacja3=struktura.sk_operacja3;
    NEW.pz_operacja4=struktura.sk_operacja4;
    NEW.ttw_idmaterialu=struktura.ttw_idmaterialu;
   END IF;   
  END IF;
  
  IF (NEW.pz_flaga&(1<<18)=(1<<18)) THEN
   NEW.pz_iloscmat=getiloscmatplanuzlecenia(NEW.ttw_idmaterialu,NEW.pz_ilosc,NEW.pz_wymiar_x,NEW.pz_wymiar_y,NEW.pz_wymiar_z,NEW.pz_naddatek_x,NEW.pz_naddatek_y,NEW.pz_naddatek_z, NEW.pz_narzut_procent);
  END IF;
  
 ---koniec dla INSERT
 END IF;

 ----------////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-----------Czesc dla update odnosnie powiazan do planu oraz przenoszenia wartosci
 ----------////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 IF (TG_OP = 'UPDATE') THEN

  IF ((NEW.pz_newflaga&(1<<0))=0 AND (OLD.pz_newflaga&(1<<0))=(1<<0)) THEN -- wlasnie przepialem plan z zamowienia otwartego, ustawie LP
   iter=(SELECT 1+NullZero(max(pz_lp)) FROM tg_planzlecenia WHERE zl_idzlecenia=NEW.zl_idzlecenia);
   NEW.pz_lp=iter;
  END IF;
   
  ---ustawiamy flage czy ojciec jest kompletem przy zmianie ojca
  IF (NEW.pz_idref!=OLD.pz_idref) THEN
   tmp=0;
   IF (NEW.pz_idref>0) THEN
    tmp=(SELECT ttw_flaga&262144 FROM tg_planzlecenia JOIN tg_towary USING (ttw_idtowaru) WHERE pz_idplanu=NEW.pz_idref);
   END IF;
   IF (tmp='262144') THEN
    NEW.pz_flaga=NEW.pz_flaga|(1<<29);
   ELSE 
    NEW.pz_flaga=NEW.pz_flaga&(~(1<<29));
   END IF;
  END IF;


  IF (NEW.pz_flaga&(1<<18)=(1<<18)) THEN
   NEW.pz_iloscmat=getiloscmatplanuzlecenia(NEW.ttw_idmaterialu,NEW.pz_ilosc,NEW.pz_wymiar_x,NEW.pz_wymiar_y,NEW.pz_wymiar_z,NEW.pz_naddatek_x,NEW.pz_naddatek_y,NEW.pz_naddatek_z, NEW.pz_narzut_procent);
  END IF; 
 
  IF (NEW.pz_idref>0) THEN
   wartoscnew=round(NEW.pz_ilosc*NEW.pz_cena,2);
  END IF;

  IF (OLD.pz_idref>0) THEN
   wartoscold=round(OLD.pz_ilosc*OLD.pz_cena,2);
  END IF;

  IF (OLD.pz_idref=NEW.pz_idref) THEN
   wartoscnew=wartoscnew-wartoscold;
   wartoscold=0;
  END IF;

  IF (NullZero(OLD.pz_idref)<>NullZero(NEW.pz_idref)) THEN
   PERFORM zwiekszPowiazaniePlanu(NEW.pz_idref);
   PERFORM zmniejszPowiazaniePlanu(OLD.pz_idref);
  END IF;
 END IF;

 ---uaktualniam wartosc z przeniesienia
 IF (wartoscnew<>0) THEN
  UPDATE tg_planzlecenia SET pz_wartoscprzenies=pz_wartoscprzenies+wartoscnew WHERE pz_idplanu=NEW.pz_idref ;
 END IF;

 IF (wartoscold<>0) THEN
  UPDATE tg_planzlecenia SET pz_wartoscprzenies=pz_wartoscprzenies-wartoscold WHERE pz_idplanu=OLD.pz_idref ;
 END IF;

 --------------------------------------------------------------------------------------
 ---synchronizacja danych ojciec - dziecko
 --------------------------------------------------------------------------------------
 IF (TG_OP = 'INSERT') THEN
  IF (NEW.pz_idref>0) THEN
   ---mamy ojca wiec pobieramy od niego interesujace dane
   pobraniedanychzojca=TRUE;
  END IF;
 END IF;

 IF (TG_OP = 'UPDATE') THEN
  IF (NEW.ttw_idtowaru!=OLD.ttw_idtowaru AND NEW.pz_flaga&(1<<18)=(1<<18)) THEN   
   IF (NEW.pz_flaga&(1<<28)=0) THEN
    ---dane elementu nie zmienione przez uzytkownika, pobieramy dane z aktualnej struktury ;
    --zmienil sie towar wiec pobieramy dla niego aktualna strukture i przeliczamy dane pochodzace z rodzicow
    SELECT sk_idstruktury, sk_wymiar_x, sk_wymiar_y, sk_wymiar_z, sk_naddatek_x, sk_naddatek_y, sk_naddatek_z, sk_narzut_procent, sk_operacja1, sk_operacja2, sk_operacja3, sk_operacja4, ttw_idmaterialu INTO struktura FROM tr_strukturakonstrukcyjna WHERE ttw_idtowaru=NEW.ttw_idtowaru AND sk_flaga&((1<<0)|(1<<5)|(1<<6))=((1<<0)|(1<<5));
    IF FOUND THEN
     ---mam strukture wiec przepisujemy pola ze struktury do planu zlecenia
     NEW.sk_idstruktury=struktura.sk_idstruktury;
     NEW.pz_wymiar_x=struktura.sk_wymiar_x;
     NEW.pz_wymiar_y=struktura.sk_wymiar_y;
     NEW.pz_wymiar_z=struktura.sk_wymiar_z;
     NEW.pz_naddatek_x=struktura.sk_naddatek_x;
     NEW.pz_naddatek_y=struktura.sk_naddatek_y;
     NEW.pz_naddatek_z=struktura.sk_naddatek_z;
     NEW.pz_narzut_procent=struktura.sk_narzut_procent;
     NEW.pz_operacja1=struktura.sk_operacja1;
     NEW.pz_operacja2=struktura.sk_operacja2;
     NEW.pz_operacja3=struktura.sk_operacja3;
     NEW.pz_operacja4=struktura.sk_operacja4;
     NEW.ttw_idmaterialu=struktura.ttw_idmaterialu;
    END IF;
   END IF;

   IF (NEW.pz_idref>0) THEN
    pobraniedanychzojca=TRUE;
   ELSE
    NEW.pz_przeldoojca=0;
   END IF;
  END IF;
  IF (NEW.pz_idref!=OLD.pz_idref AND NEW.pz_flaga&(1<<18)=(1<<18)) THEN
   ----zmienil mi sie ojciec musze pobrac aktualne dane od niego dla zlecen produkcyjnych
   pobraniedanychzojca=TRUE;
  END IF;   
 END IF;

 IF (pobraniedanychzojca) THEN
  SELECT pz_ilosc, pz_ilosczreal, pz_iloscroz, pz_termin, pz_flaga, sk_idstruktury, COALESCE(pz_idroot,pz_idplanu) AS pz_idroot INTO rec FROM tg_planzlecenia WHERE pz_idplanu=NEW.pz_idref;

  NEW.pz_idroot=rec.pz_idroot;
  
  IF (NEW.sk_idstruktury>0 AND rec.sk_idstruktury>0) THEN
  --- mamy struktury wiec szukamy aktualnego przelicznika miedzy nimi
   NEW.pz_przeldoojca=(SELECT skr_ilosc FROM tr_strukturakonstrukcyjnarel WHERE sk_idstrukturyp=rec.sk_idstruktury AND sk_idstrukturyc=NEW.sk_idstruktury);
  ELSE
---   NEW.pz_przeldoojca=0; //zostawiamy tak jak zesmy ustawili na dt
  END IF;
 
  NEW.pz_iloscojciec=rec.pz_ilosc;
  NEW.pz_iloscojciecwyk=rec.pz_ilosczreal;
  NEW.pz_iloscojciecplan=rec.pz_iloscroz;
  NEW.pz_dataojca=rec.pz_termin;
 
  IF (rec.pz_flaga&(1+1024)!=0 ) THEN
   NEW.pz_flaga=NEW.pz_flaga|(1<<22);
  ELSE
   NEW.pz_flaga=NEW.pz_flaga&(~(1<<22));
  END IF;

  IF ( (rec.pz_flaga&(3<<24))=0 OR rec.pz_flaga&(1<<26)=(1<<26) ) THEN
   NEW.pz_flaga=NEW.pz_flaga|(1<<26);                -----------Ojciec jest zakupowy lub jest w galezi zakupowej wiec i dziecko musi byc zakupowe
  ELSE 
   NEW.pz_flaga=NEW.pz_flaga&(~(1<<26));  ----nie jestesmy w galezi zakupowej
  END IF;

  IF ( (rec.pz_flaga&(3<<24))=(3<<24) OR (rec.pz_flaga&(1<<30)=(1<<30) AND rec.pz_flaga&(3<<24)<>(1<<24)) ) THEN
   NEW.pz_flaga=NEW.pz_flaga|(1<<30);                -----------Ojciec jest kooperacja lub jest w galezi kooperacji i nie jest produkcyjny wiec i dziecko musi byc kooperowane
  ELSE 
   NEW.pz_flaga=NEW.pz_flaga&(~(1<<30));  ----nie jestesmy w galezi kooperacji
  END IF;  
 END IF;  
 --------------------------------------------------------------------------------------
 ---Koniec synchronizacji danych ojciec - dziecko
 --------------------------------------------------------------------------------------
 
 -----wyliczamy nowe ilosci rozplanowania i wykonania
 IF (TG_OP='UPDATE') THEN
  IF (NEW.pz_iloscojciecplan<>OLD.pz_iloscojciecplan AND NEW.pz_flaga&(3<<24)=(2<<24)) THEN -- Zmienilo sie pz_iloscojciecplan na produkcji kooperanta
   NEW.pz_iloscroz=(NEW.pz_iloscojciecplan*NEW.pz_przeldoojca);
  END IF;
    
  -- Zmieniam rodzaj:  PK -> Dowolny - Zeruje pz_iloscroz
  IF (OLD.pz_flaga&(3<<24)=(2<<24) AND NEW.pz_flaga&(3<<24)<>(2<<24)) THEN
   NEW.pz_iloscroz=0;
  END IF;
  
  -- Zmieniam rodzaj:  Dowolny -> PK - Obliczam pz_iloscroz
  IF (OLD.pz_flaga&(3<<24)<>(2<<24) AND NEW.pz_flaga&(3<<24)=(2<<24)) THEN
   NEW.pz_iloscroz=(NEW.pz_iloscojciecplan*NEW.pz_przeldoojca);
  END IF;

  IF (NEW.pz_iloscojciecwyk<>OLD.pz_iloscojciecwyk AND NEW.pz_flaga&(3<<24)=(2<<24)) THEN -- Zmienilo sie pz_iloscojciecplan na produkcji kooperanta
   NEW.pz_ilosczreal=(NEW.pz_iloscojciecwyk*NEW.pz_przeldoojca);
   IF (NEW.pz_ilosczreal>=NEW.pz_ilosc) THEN
    NEW.pz_flaga=NEW.pz_flaga|(1<<1);
   ELSE
    NEW.pz_flaga=NEW.pz_flaga&(~(1<<1));
   END IF; 
  END IF;
 END IF;
  
 -----wyliczamy nowa ilosc zapotrzebowana z ojca
 IF (TG_OP != 'DELETE') THEN
  NEW.pz_zapotrzebowanieojciec=0;
  IF (NEW.pz_flaga&(1<<20)!=0) THEN
   ---z ilosci niewykonanej
   NEW.pz_zapotrzebowanieojciec=Round(NEW.pz_przeldoojca*(NEW.pz_iloscojciec-NEW.pz_iloscojciecwyk),4);
  END IF;
  IF (NEW.pz_flaga&(1<<21)!=0) THEN
   ---z ilosci nierozplanowanej
   NEW.pz_zapotrzebowanieojciec=Round(NEW.pz_przeldoojca*(NEW.pz_iloscojciec-NEW.pz_iloscojciecplan),4);
  END IF;
 END IF;

 IF (TG_OP = 'DELETE') THEN
  
  IF (OLD.pz_idref>0) THEN
   PERFORM zmniejszPowiazaniePlanu(OLD.pz_idref);
   UPDATE tg_planzlecenia SET pz_wartoscprzenies=pz_wartoscprzenies-round(OLD.pz_ilosc*OLD.pz_cena,2) WHERE pz_idplanu=OLD.pz_idref ;
  END IF;
  
  IF (((OLD.pz_flaga&512)!=512 OR OLD.pz_idref=NULL) AND OLD.pz_idrewizja=NULL) THEN
   UPDATE tg_planzlecenia SET pz_lp=pz_lp-1 WHERE zl_idzlecenia=OLD.zl_idzlecenia AND pz_lp>OLD.pz_lp AND pz_flaga&(2048+16384)=OLD.pz_flaga&(2048+16384);
  END IF;

  ---kwestie ukatualnienia ilosc na tr_nodrec
  IF (OLD.pz_flaga&(1<<19)<>0) THEN
   UPDATE tr_powiazanieplanprzychod SET ppp_flaga=ppp_flaga|1 WHERE pz_idplanu=OLD.pz_idplanu;
  END IF;

  RETURN OLD;
 END IF;

 RETURN NEW;
END;
$$;
