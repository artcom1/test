CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 pap tg_partie;
 ret gmr.stan_towaruex;
BEGIN 

 IF (idpartii IS NOT NULL) THEN
  SELECT * INTO pap FROM tg_partie WHERE prt_idpartii=idpartii;
 ELSE
  pap=gm.getNULLPartiaRecord(idtowaru,idtowmag,-1);
 END IF;

 ret=gmr.getstantowaruex(idtowmag,idtowaru,pap,idklienta,idskojelem,fmidx,simid,similosc,idsposobupakowania);
 
 return ret;
END;
$$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 ret gm.stan_towaru;   -- Zmienna pomocnicza
 rtowaru INT;          -- Rodzaj towaru
 idsposobu INT;        -- Sposob pakowania
 r RECORD;             -- Pomocniczy rekord
 dzielnik NUMERIC;     -- Dzielnik ilosci
 ---------------------
 tmp TEXT;
 retp gm.stan_towaru;  -- Pomocniczy stan towaru
 pnew tg_partie;
 ---------------------
 maxilosclocal NUMERIC;
 maxiloscpaczek gmr.stan_towaruex; 
BEGIN 

 ---Wczytaj rodzaj towaru
 rtowaru=pap.prt_rtowaru;
 IF (rtowaru IS NULL) THEN
  SELECT ttw_rtowaru INTO rtowaru FROM tg_towary WHERE ttw_idtowaru=idtowaru;
 END IF;
 
  
---Sprawdz czy mamy do czynienia z rozmiarowka
 IF (rtowaru NOT IN (128)) THEN
  ---Nie, standardowy sposob czytania stanow
  ret=gm.getstantowaru(idtowmag,idtowaru,pap,idklienta,idskojelem,fmidx,simid,similosc);
  maxiloscpaczek.iloscavail=ret.iloscavail;
  maxiloscpaczek.stanmag=ret.stanmag;
  maxiloscpaczek.stanh=ret.stanh;
  maxiloscpaczek.stanh_real=ret.stanh_real;
  return maxiloscpaczek;
 END IF;
 
 ---Wczytaj sposob pakowania
 ---1. Z partii 
 idsposobu=COALESCE(idsposobupakowania,pap.rmp_idsposobu);
 ---2. Z podanego transelemu
 IF ((idsposobu IS NULL) AND (idskojelem IS NOT NULL)) THEN
  idsposobu=(SELECT rmp_idsposobu FROM tg_transelem WHERE tel_idelem=idskojelem);
 END IF;
 
 ---RAISE NOTICE 'Sposob %',idsposobu;
 ---Nie znamy sposobu pakowania - wyjdz
 IF (idsposobu IS NULL) THEN
  ret=gm.getstantowaru(idtowmag,idtowaru,pap,idklienta,idskojelem,fmidx,simid,similosc);
  maxiloscpaczek.iloscavail=ret.iloscavail;
  return maxiloscpaczek;
 END IF;
 
 dzielnik=(SELECT sum(rmk_przelicznik) FROM tg_rozmsppakelems AS spe WHERE spe.rmp_idsposobu=idsposobu);
    
 ---tmp = current_setting('client_min_messages');
 ---PERFORM set_config('client_min_messages','warning',true);
    
 ----RAISE NOTICE '----------------------------------------------------------------';
 FOR r IN SELECT spe.rmk_przelicznik,spe.ttw_idtowaru_pdx
          FROM tg_rozmsppakelems AS spe
		  WHERE spe.rmp_idsposobu=idsposobu
		  ORDER BY spe.rmp_idsposobu
 LOOP
  pnew=gmr.findOrCreatePartiaLikeOther(pap,r.ttw_idtowaru_pdx,false);
  
  IF (pnew IS NULL) THEN
   maxiloscpaczek.iloscavail_inop=0;
   maxiloscpaczek.stanmag_inop=0;
   maxiloscpaczek.stanh_inop=0;
   maxiloscpaczek.stanh_real_inop=0;
   EXIT WHEN TRUE;
  END IF;
  
  maxilosclocal=floor(r.rmk_przelicznik*similosc/dzielnik);
  ---RAISE NOTICE 'Max local %*%/%',r.rmk_przelicznik,similosc,dzielnik;
  
  CONTINUE WHEN (maxiloscpaczek.iloscavail_inop=0) AND (maxiloscpaczek.stanmag_inop=0) AND (maxiloscpaczek.stanh_inop=0) AND (maxiloscpaczek.stanh_real_inop=0);
  
  BEGIN  
   retp=gm.getStantowaru((SELECT ttm_idtowmag FROM tg_towmag AS tm WHERE tm.ttw_idtowaru=r.ttw_idtowaru_pdx AND tmg_idmagazynu=(SELECT tmg_idmagazynu FROM tg_towmag WHERE ttm_idtowmag=idtowmag)),
                          r.ttw_idtowaru_pdx,
	   	          	      pnew,
		 				  idklienta,
						  (SELECT tel_idelem FROM tg_transelem WHERE tel_skojzestaw=idskojelem AND ttw_idtowaru=r.ttw_idtowaru_pdx),
						  fmidx,
						  simid,
						  maxilosclocal);
   RAISE EXCEPTION SQLSTATE 'EDUPA';
  EXCEPTION 
   WHEN SQLSTATE 'EDUPA' THEN pnew=NULL;
  END;
  
  ---RAISE NOTICE 'Local: %',retp;  
  ---RAISE NOTICE 'Mam iloscavail % %',r.ttw_idtowaru_pdx,retp.iloscavail;
  
  retp.iloscavail=COALESCE(floor(retp.iloscavail/r.rmk_przelicznik),0);
  retp.stanmag = COALESCE(floor(retp.stanmag/r.rmk_przelicznik),0);
  retp.stanh = COALESCE(floor(retp.stanh/r.rmk_przelicznik),0);
  retp.stanh_real = COALESCE(floor(retp.stanh_real/r.rmk_przelicznik),0);
  
  maxiloscpaczek.iloscavail_inop=COALESCE(min(maxiloscpaczek.iloscavail_inop,retp.iloscavail),retp.iloscavail);
  maxiloscpaczek.stanmag_inop=COALESCE(min(maxiloscpaczek.stanmag_inop,retp.stanmag),retp.stanmag);
  maxiloscpaczek.stanh_inop=COALESCE(min(maxiloscpaczek.stanh_inop,retp.stanh),retp.stanh);
  maxiloscpaczek.stanh_real_inop=COALESCE(min(maxiloscpaczek.stanh_real_inop,retp.stanh_real),retp.stanh_real);
  
  ---RAISE NOTICE '%',maxiloscpaczek;
 END LOOP; 

 --- PERFORM set_config('client_min_messages',tmp,true); 
 ----RAISE NOTICE 'Wynik % %',maxiloscpaczek.iloscavail_inop,maxiloscpaczek;
 
 
 IF (maxiloscpaczek.iloscavail_inop>0) THEN
 --- Powtorz jeszcze raz liczenie, tym razem z obliczonym minimum
  FOR r IN SELECT spe.rmk_przelicznik,spe.ttw_idtowaru_pdx
           FROM tg_rozmsppakelems AS spe
	 	   WHERE spe.rmp_idsposobu=idsposobu
 		   ORDER BY spe.rmp_idsposobu
  LOOP
   pnew=gmr.findOrCreatePartiaLikeOther(pap,r.ttw_idtowaru_pdx,false);
   maxilosclocal=r.rmk_przelicznik*maxiloscpaczek.iloscavail_inop;
  
   retp=gm.getStantowaru((SELECT ttm_idtowmag FROM tg_towmag AS tm WHERE tm.ttw_idtowaru=r.ttw_idtowaru_pdx AND tmg_idmagazynu=(SELECT tmg_idmagazynu FROM tg_towmag WHERE ttm_idtowmag=idtowmag)),
                          r.ttw_idtowaru_pdx,
	    				  pnew,
						  idklienta,
						  (SELECT tel_idelem FROM tg_transelem WHERE tel_skojzestaw=idskojelem AND ttw_idtowaru=r.ttw_idtowaru_pdx),
						  fmidx,
						  simid,
						  maxilosclocal);
						  
  ----RAISE NOTICE 'F2 iloscavail % %',r.ttw_idtowaru_pdx,retp.iloscavail;
   IF (retp.iloscavail!=maxilosclocal) THEN
    RAISE EXCEPTION 'Blad podczas liczenia ilosci dla rozmiarowki (%!=%)!',retp.iloscavail,maxilosclocal;
   END IF;
  END LOOP;
 END IF;

 maxiloscpaczek.iloscavail=maxiloscpaczek.iloscavail_inop*dzielnik;	
 maxiloscpaczek.stanmag=maxiloscpaczek.stanmag_inop*dzielnik;
 maxiloscpaczek.stanh=maxiloscpaczek.stanh_inop*dzielnik;
 maxiloscpaczek.stanh_real=maxiloscpaczek.stanh_real_inop*dzielnik;
 return maxiloscpaczek;
END;
$$;
