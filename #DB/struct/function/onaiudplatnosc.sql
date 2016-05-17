CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 old_wartoscwnpln NUMERIC:=0;
 old_wartoscmapln NUMERIC:=0;
 
 new_wartoscwnpln NUMERIC:=0;
 new_wartoscmapln NUMERIC:=0;
 
 old_zdarzenie INT:=0;
 new_zdarzenie INT:=0;
 
 old_dokument INT:=0;
 new_dokument INT:=0;
BEGIN
 ---update rozrachunkow
 IF (TG_OP='UPDATE') THEN
  IF (NEW.pl_flaga&6144<>4096) AND (NEW.pl_flaga&4=0) THEN
   IF (NEW.wl_idwaluty<>OLD.wl_idwaluty OR NEW.wl_przelicznik<>OLD.wl_przelicznik) THEN
    PERFORM normalizeWalutaRozrachunkow(NULL,NEW.pl_idplatnosc,NEW.wl_idwaluty,NEW.pl_wartosc,NEW.wl_przelicznik,(NEW.pl_wplyw<0));
   END IF;
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN

  ---- Rozrachunki
  IF (NEW.pl_flaga&6144<>4096) AND (NEW.pl_flaga&4=0) THEN
   PERFORM updateRozrachunkiPlat(NEW.pl_idplatnosc,NEW.k_idklienta,NEW.bk_idbanku,NEW.pl_wartosc,NEW.wl_przelicznik,NEW.wl_idwaluty,NEW.pl_flaga,NEW.pl_wplyw::int,NEW.pl_datawplywu,NEW.pl_formaplat,NEW.fm_idcentrali,(CASE WHEN PLisFIFOtoRR(NEW.pl_flaga)=TRUE THEN NEW.pl_wplnfifo ELSE NULL END));
   PERFORM updateRozrachunkiKompensaty(NEW.pl_idplatnosc,NEW.k_idklienta,NEW.pl_saldokomp,NEW.wl_przelicznik,NEW.wl_idwaluty,NEW.pl_flaga,NEW.pl_datawplywu,NEW.fm_idcentrali,((NEW.pl_flaga&(1<<23))!=0));
  ELSE
   PERFORM updateRozrachunkiPlat(NEW.pl_idplatnosc,NEW.k_idklienta,NEW.bk_idbanku,0::numeric,NEW.wl_przelicznik,NEW.wl_idwaluty,NEW.pl_flaga,NEW.pl_wplyw::int,NEW.pl_datawplywu,NEW.pl_formaplat,NEW.fm_idcentrali,0);
   PERFORM updateRozrachunkiKompensaty(NEW.pl_idplatnosc,NEW.k_idklienta,0::numeric,NEW.wl_przelicznik,NEW.wl_idwaluty,NEW.pl_flaga,NEW.pl_datawplywu,NEW.fm_idcentrali,FALSE);
  END IF;

  IF (NEW.pl_wplyw>0) THEN
   PERFORM updatePlusPlatFifo(NEW.pl_idplatnosc,NEW.bk_idbanku,NEW.pl_wartosc,round(NEW.pl_wartosc*NEW.wl_przelicznik,2),NEW.wl_idwaluty,NEW.pl_datawplywu,NEW.pl_flaga);
  END IF;

  IF (NEW.pl_wplyw=0) THEN
   PERFORM clearPlatFifo(NEW.pl_idplatnosc);
  END IF;
 
 END IF;
 ---koniec update rozrachunkow
 
 -----------------------------------------------------------------------------------
 --- AKUMULATOR PALTNOSCI NA OBIEKTACH
 ----------------------------------------------------------------------------------- 
 -- DELETE lub UPDATE
 IF (TG_OP<>'INSERT') THEN
  IF (OLD.pl_flaga&1024=0) THEN 
   -- WYPLATA
   old_wartoscmapln=round(OLD.pl_wartosc*OLD.wl_przelicznik,2);
  ELSE  
   -- WPLATA
   old_wartoscwnpln=round(OLD.pl_wartosc*OLD.wl_przelicznik,2);
  END IF;
  
  IF (OLD.zd_idzdarzenia IS NOT NULL) THEN old_zdarzenie=OLD.zd_idzdarzenia; END IF;
  IF (OLD.tr_idtrans IS NOT NULL) THEN old_dokument=OLD.tr_idtrans; END IF;
 END IF; 
 
 -- INSERT lub UPDATE 
 IF (TG_OP<>'DELETE') THEN
  IF (NEW.pl_flaga&1024=0) THEN 
   -- WYPLATA
   new_wartoscmapln=round(NEW.pl_wartosc*NEW.wl_przelicznik,2);
  ELSE  
   -- WPLATA
   new_wartoscwnpln=round(NEW.pl_wartosc*NEW.wl_przelicznik,2);
  END IF;
  
  IF (NEW.zd_idzdarzenia IS NOT NULL) THEN new_zdarzenie=NEW.zd_idzdarzenia; END IF;
  IF (NEW.tr_idtrans IS NOT NULL) THEN new_dokument=NEW.tr_idtrans; END IF;
 END IF;
 
 IF ( old_zdarzenie=new_zdarzenie AND new_zdarzenie>0 ) THEN
  UPDATE tb_zdarzenia SET zd_platnosciwnlpn=zd_platnosciwnlpn+(new_wartoscwnpln-old_wartoscwnpln), zd_platnoscimalpn=zd_platnoscimalpn+(new_wartoscmapln-old_wartoscmapln) WHERE zd_idzdarzenia=new_zdarzenie;
 ELSE
  IF ( old_zdarzenie>0 ) THEN
   UPDATE tb_zdarzenia SET zd_platnosciwnlpn=zd_platnosciwnlpn-old_wartoscwnpln, zd_platnoscimalpn=zd_platnoscimalpn-old_wartoscmapln WHERE zd_idzdarzenia=old_zdarzenie;
  END IF;  
  IF ( new_zdarzenie>0 ) THEN
   UPDATE tb_zdarzenia SET zd_platnosciwnlpn=zd_platnosciwnlpn+new_wartoscwnpln, zd_platnoscimalpn=zd_platnoscimalpn+new_wartoscmapln WHERE zd_idzdarzenia=new_zdarzenie;
  END IF;
 END IF;
  
 IF ( old_dokument=new_dokument AND new_dokument>0 ) THEN
  UPDATE tg_transakcje SET tr_platnosciwnlpn=tr_platnosciwnlpn+(new_wartoscwnpln-old_wartoscwnpln), tr_platnoscimalpn=tr_platnoscimalpn+(new_wartoscmapln-old_wartoscmapln) WHERE tr_idtrans=new_dokument;
 ELSE
  IF ( old_dokument>0 ) THEN
   UPDATE tg_transakcje SET tr_platnosciwnlpn=tr_platnosciwnlpn-old_wartoscwnpln, tr_platnoscimalpn=tr_platnoscimalpn-old_wartoscmapln WHERE tr_idtrans=old_dokument;
  END IF;  
  IF ( new_dokument>0 ) THEN
   UPDATE tg_transakcje SET tr_platnosciwnlpn=tr_platnosciwnlpn+new_wartoscwnpln, tr_platnoscimalpn=tr_platnoscimalpn+new_wartoscmapln WHERE tr_idtrans=new_dokument;
  END IF;
 END IF;
 -----------------------------------------------------------------------------------
 --- KONIEC AKUMULATORA PALTNOSCI NA OBIEKTACH
 ----------------------------------------------------------------------------------- 

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
