CREATE FUNCTION oniudplanzlecenia_backordery() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
 _isOczekiwanie                   BOOL:=FALSE;
 _isZapotrzebowanie               BOOL:=FALSE;
 _isZapotrzebowanieMat            BOOL:=FALSE;
 _zerowanieOldOczekiwanie         BOOL:=FALSE;
 _zerowanieOldZapotrzebowanie     BOOL:=FALSE;
 _zerowanieOldZapotrzebowanieMat  BOOL:=FALSE;
 iloscmat                         NUMERIC:=0;
BEGIN
 --------------------------------------------------------------------------------------
 ---Odnosnie backorderow
 --------------------------------------------------------------------------------------
 
 IF (TG_OP <> 'DELETE') THEN
  -- Oczekiwanie
  _isOczekiwanie=(-- Warunki Rekordu Produkcyjnego
				  NEW.pz_newflaga&(1<<0)=0 AND     -- 0 - plany zlecen 'nieotwartych'
                  NEW.pz_flaga&(1<< 1)=0 AND       -- 0 - niezrealizowane
	              NEW.pz_flaga&(1<<10)=0 AND       -- plan produkcji niewykonany (nie waznie jaka ilosc jest wykonana)
				  NEW.pz_flaga&(1<<13)=0 AND       -- element nie jest naglowkiem sekcji
	              NEW.pz_flaga&(1<<16)=0 AND       -- zlecenie niewykonane ani nieanulowane
                  NEW.pz_flaga&(1<<18)=(1<<18) AND -- plan do zlecen produkcyjnych
                  NEW.pz_flaga&(1<<26)=0 AND       -- gora drzewa nie jeste oznaczona jako zakupowa
				  NEW.pz_flaga&(1<<27)=0 AND       -- zdarzenie produkcyjne nie zosta3o anulowane
				  -- Warunki dla oczekiwania  
	              NEW.pz_flaga&(1<<17)=(1<<17) AND -- plan produkcyjny do ktorego tworzymy backordery (oczekiwane)
				  (				  
				   NEW.pz_flaga&(3<<24)=(1<<24) OR -- interesuja nas produkowane
				   NEW.pz_flaga&(3<<24)=(3<<24)    -- interesuja nas kooperacje
				  ) 
                 );
 			 
  -- Zapotrzebowanie
  _isZapotrzebowanie=(-- Warunki Rekordu Produkcyjnego
					  NEW.pz_newflaga&(1<<0)=0 AND     -- 0 - plany zlecen 'nieotwartych'
                      NEW.pz_idref>0 AND               -- Plan nie jest korzeniem  
                      NEW.pz_flaga&(1<< 1)=0 AND       -- 0 - niezrealizowane
	                  NEW.pz_flaga&(1<<10)=0 AND       -- plan produkcji niewykonany (nie waznie jaka ilosc jest wykonana)
				      NEW.pz_flaga&(1<<13)=0 AND       -- element nie jest naglowkiem sekcji
	                  NEW.pz_flaga&(1<<16)=0 AND       -- zlecenie niewykonane ani nieanulowane
                      NEW.pz_flaga&(1<<18)=(1<<18) AND -- plan do zlecen produkcyjnych
					  NEW.pz_flaga&(1<<26)=0 AND       -- gora drzewa nie jeste oznaczona jako zakupowa
				      NEW.pz_flaga&(1<<27)=0 AND       -- zdarzenie produkcyjne nie zosta3o anulowane					  
				      -- Warunki dla zapotrzebowania
                      (
					   NEW.pz_flaga&(1<<20)=(1<<20) OR -- plan produkcyjny do ktorego tworzymy zapotrzebowanie z polaczenia ojciec - dziecko
					   NEW.pz_flaga&(1<<21)=(1<<21)    -- plan produkcyjny do ktorego tworzymy zapotrzebowanie z polaczenia ojciec - dziecko
					  ) AND 
                      NEW.pz_flaga&(1<<22)=0 AND       -- ojciec oznaczony jako niewykonany
					  (
					   NEW.pz_flaga&(3<<24)=(0<<24) OR -- interesuja nas zakupowe
				       NEW.pz_flaga&(3<<24)=(1<<24) OR -- interesuja nas produkowane
					   NEW.pz_flaga&(3<<24)=(3<<24)    -- interesuja nas kooperacje
					  ) AND					  					  
                      NEW.pz_flaga&(1<<29)=0           -- rodzic nie jest kartoteka kompletowa
                     );
					 
					 
  -- Zapotrzebowanie na material
  _isZapotrzebowanieMat=(-- Warunki Rekordu Produkcyjnego
						 NEW.pz_newflaga&(1<<0)=0 AND     -- 0 - plany zlecen 'nieotwartych'
                         NEW.pz_flaga&(1<< 1)=0 AND       -- 0 - niezrealizowane
	                     NEW.pz_flaga&(1<<10)=0 AND       -- plan produkcji niewykonany (nie waznie jaka ilosc jest wykonana)
				         NEW.pz_flaga&(1<<13)=0 AND       -- element nie jest naglowkiem sekcji
	                     NEW.pz_flaga&(1<<16)=0 AND       -- zlecenie niewykonane ani nieanulowane
                         NEW.pz_flaga&(1<<18)=(1<<18) AND -- plan do zlecen produkcyjnych
						 NEW.pz_flaga&(1<<26)=0 AND       -- gora drzewa nie jeste oznaczona jako zakupowa
				         NEW.pz_flaga&(1<<27)=0 AND       -- zdarzenie produkcyjne nie zosta3o anulowane
				         -- Warunki dla zapotrzebowania na material                         
                         NEW.pz_flaga&(1<<23)=(1<<23) AND -- plan ma generowac zapotrzebowanie na material 
					     (
				          NEW.pz_flaga&(3<<24)=(1<<24) OR -- interesuja nas produkowane
						  NEW.pz_flaga&(3<<24)=(2<<24) OR -- interesuja nas produkcje kooperanta
					      NEW.pz_flaga&(3<<24)=(3<<24)    -- interesuja nas kooperacje
					     )
                        );			  
  
  
  IF (_isOczekiwanie) THEN
   PERFORM dodajbackorderZPlanu(NEW.pz_idplanu,NEW.ttw_idtowaru,(NEW.pz_ilosc-max(NEW.pz_ilosczreal,NEW.pz_iloscroz)),TRUE,NEW.pz_termin::DATE,NEW.zl_idzlecenia);  
  ELSE
  _zerowanieOldOczekiwanie=TRUE;
  END IF;
  
  IF (_isZapotrzebowanie) THEN
   PERFORM dodajbackorderZPlanu(NEW.pz_idplanu,NEW.ttw_idtowaru,(NEW.pz_zapotrzebowanieojciec),FALSE,NEW.pz_dataojca::DATE,NEW.zl_idzlecenia);  
  ELSE
   _zerowanieOldZapotrzebowanie=TRUE;
  END IF;
  
  IF (_isZapotrzebowanieMat) THEN
   IF (TG_OP = 'UPDATE') THEN
    IF (COALESCE(OLD.ttw_idmaterialu,0)<>COALESCE(NEW.ttw_idmaterialu,0)) THEN -- Jesli materialy sie zmienily najpierw kasuje stary backorder
	 PERFORM wyliczenieZapotrzebowaniaWgMatPlanuZlecenia(OLD.zl_idzlecenia, OLD.pz_idplanu, OLD.ttw_idmaterialu, OLD.pz_termin::DATE,0,OLD.pz_wymiar_x,OLD.pz_wymiar_y,OLD.pz_wymiar_z,OLD.pz_naddatek_x,OLD.pz_naddatek_y,OLD.pz_naddatek_z, OLD.pz_narzut_procent);
	END IF;
   END IF;
   iloscmat=NEW.pz_ilosc-max(NEW.pz_ilosczreal,NEW.pz_iloscroz); ----ilosc planu do wykonania na ktora nic nie zrobione (PW ani KKW)
   PERFORM wyliczenieZapotrzebowaniaWgMatPlanuZlecenia(NEW.zl_idzlecenia, NEW.pz_idplanu, NEW.ttw_idmaterialu, NEW.pz_termin::DATE,iloscmat,NEW.pz_wymiar_x,NEW.pz_wymiar_y,NEW.pz_wymiar_z,NEW.pz_naddatek_x,NEW.pz_naddatek_y,NEW.pz_naddatek_z, NEW.pz_narzut_procent); 
  ELSE
   _zerowanieOldZapotrzebowanieMat=TRUE;
  END IF;
    
 END IF;
  
 IF (TG_OP = 'DELETE') THEN
  _zerowanieOldOczekiwanie=(
                            OLD.pz_flaga&(1<<17)=(1<<17)  -- plan produkcyjny do ktorego tworzymy backordery (oczekiwane)
						   );
  _zerowanieOldZapotrzebowanie=(
                                OLD.pz_flaga&(1<<20)=(1<<20) OR  -- plan produkcyjny do ktorego tworzymy zapotrzebowanie z polaczenia ojciec - dziecko
								OLD.pz_flaga&(1<<21)=(1<<21)     -- plan produkcyjny do ktorego tworzymy zapotrzebowanie z polaczenia ojciec - dziecko
								);
  _zerowanieOldZapotrzebowanieMat=(
                                   OLD.pz_flaga&(1<<23)=(1<<23)  -- plan ma generowac zapotrzebowanie na material 
								  ); 
 END IF;
 
 IF (TG_OP <> 'INSERT') THEN  
  IF (_zerowanieOldOczekiwanie) THEN -- kasujemy backorder oczekiwania
   PERFORM dodajbackorderZPlanu(OLD.pz_idplanu,OLD.ttw_idtowaru,0,TRUE,OLD.pz_termin::DATE,OLD.zl_idzlecenia);
  END IF;
 
  IF (_zerowanieOldZapotrzebowanie) THEN -- kasujemy backorder zapotrzebowania z ojca
   PERFORM dodajbackorderZPlanu(OLD.pz_idplanu,OLD.ttw_idtowaru,0,FALSE,OLD.pz_dataojca::DATE,OLD.zl_idzlecenia);
  END IF;
 
  IF (_zerowanieOldZapotrzebowanieMat) THEN ---kasujem backorder zapotrzebowania na material  
   PERFORM wyliczenieZapotrzebowaniaWgMatPlanuZlecenia(OLD.zl_idzlecenia, OLD.pz_idplanu, OLD.ttw_idmaterialu, OLD.pz_termin::DATE,0,OLD.pz_wymiar_x,OLD.pz_wymiar_y,OLD.pz_wymiar_z,OLD.pz_naddatek_x,OLD.pz_naddatek_y,OLD.pz_naddatek_z, OLD.pz_narzut_procent);
  END IF;
 END IF;
 
 --------------------------------------------------------------------------------------
 ---Koniec backorderow
 --------------------------------------------------------------------------------------

 RAISE NOTICE 'O=%, Z=%, ZM=%, zOO=%, zOZ=%, zOZM=%, iloscmat=%', _isOczekiwanie, _isZapotrzebowanie, _isZapotrzebowanieMat, _zerowanieOldOczekiwanie, _zerowanieOldZapotrzebowanie, _zerowanieOldZapotrzebowanieMat, iloscmat;
 
 IF (TG_OP = 'DELETE') THEN
  RETURN OLD;
 END IF;

 RETURN NEW;
END;
$$;
