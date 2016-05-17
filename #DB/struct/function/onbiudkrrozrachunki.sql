CREATE FUNCTION onbiudkrrozrachunki() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 dwartoscpozo NUMERIC:=0;
 dwartoscpozn NUMERIC:=0;
 dwartoscrozo NUMERIC:=0;
 dwartoscrozn NUMERIC:=0;

 dsaldoo     NUMERIC:=0;
 dsaldon     NUMERIC:=0;
 dsaldopozo  NUMERIC:=0;
 dsaldopozn  NUMERIC:=0;

 diswno       BOOL:=TRUE;
 diswnn       BOOL:=TRUE;
 disrro       BOOL:=FALSE;
 disrrn       BOOL:=FALSE;
BEGIN
   
 -------------------------------------------------------------------------------------------------------------
 --- STARTOF: Przeliczenie Wn/Ma
 -------------------------------------------------------------------------------------------------------------
 IF (TG_OP<>'DELETE') THEN
  NEW.rr_kwotawalfornorm=COALESCE(NEW.rr_kwotawalfornorm,NEW.rr_kwotawal);   
  
  IF (NEW.rr_iswn=TRUE) THEN
   NEW.rr_kwotawnwal=NEW.rr_kwotawal;
   NEW.rr_kwotamawal=0;
   NEW.rr_wartoscwnpln=NEW.rr_wartoscpln;
   NEW.rr_wartoscmapln=0;
   NEW.rr_wartoscwnpozwal=NEW.rr_wartoscpozwal;
   NEW.rr_wartoscmapozwal=0;
   NEW.rr_wartoscwnpozpln=NEW.rr_wartoscpozpln;
   NEW.rr_wartoscmapozpln=0;
  ELSE
   NEW.rr_kwotawnwal=0;
   NEW.rr_kwotamawal=-NEW.rr_kwotawal;
   NEW.rr_wartoscwnpln=0;
   NEW.rr_wartoscmapln=-NEW.rr_wartoscpln;
   NEW.rr_wartoscwnpozwal=0;
   NEW.rr_wartoscmapozwal=-NEW.rr_wartoscpozwal;
   NEW.rr_wartoscwnpozpln=0;
   NEW.rr_wartoscmapozpln=-NEW.rr_wartoscpozpln;
  END IF;

  IF (NEW.zp_idelzapisu IS NULL) THEN
   NEW.kt_idkonta=NULL;
  ELSE
   IF (NEW.kt_idkonta IS NULL) THEN
    NEW.kt_idkonta=(SELECT (CASE WHEN NEW.rr_iswn=TRUE THEN kt_idkontawn ELSE kt_idkontama END) FROM kh_zapisyelem WHERE zp_idelzapisu=NEW.zp_idelzapisu);
   END IF;
  END IF;

  NEW.sd_idsalda=getIDSalda(NEW.k_idklienta,NEW.kt_idkonta,NEW.fm_idcentrali);
 END IF;
 -------------------------------------------------------------------------------------------------------------
 --- ENDOF: Przeliczenie Wn/Ma
 -------------------------------------------------------------------------------------------------------------

 -------------------------------------------------------------------------------------------------------------
 --- STARTOF: Sprawdzenia
 -------------------------------------------------------------------------------------------------------------
 IF (TG_OP<>'DELETE') THEN
  IF (NEW.rr_flaga&8=0) THEN
   IF (NEW.rr_kwotawal=0) AND (NEW.rr_wartoscpozwal<>0) THEN
    RAISE EXCEPTION 'Pozostalo niezero przy zerowym rozrachunku % (% i %)!',NEW.rr_idrozrachunku,NEW.rr_kwotawal,NEW.rr_wartoscpozwal;
   END IF;
   IF (sign(NEW.rr_kwotawal*NEW.rr_wartoscpozwal)<0) THEN
    RAISE EXCEPTION 'Przekroczenie granicy przy rozrachunku % (% i %)!',NEW.rr_idrozrachunku,NEW.rr_kwotawal,NEW.rr_wartoscpozwal;
   END IF;
  END IF;
 END IF;
 -------------------------------------------------------------------------------------------------------------
 --- ENDOF: Sprawdzenia
 -------------------------------------------------------------------------------------------------------------

 -------------------------------------------------------------------------------------------------------------
 --- STARTOF: Flagi
 -------------------------------------------------------------------------------------------------------------
 IF (TG_OP<>'DELETE') THEN
  NEW.rr_flaga=NEW.rr_flaga&(~(63<<7));
  IF (NEW.tr_idtrans IS NOT NULL AND NEW.rr_iswn=TRUE) THEN
   NEW.rr_flaga=NEW.rr_flaga|(1<<7);
  END IF;
  IF (NEW.tr_idtrans IS NOT NULL AND NEW.rr_iswn=FALSE) THEN
   NEW.rr_flaga=NEW.rr_flaga|(1<<8);
  END IF;
  IF (NEW.pl_idplatnosc IS NOT NULL AND NEW.rr_iswn=TRUE) THEN
   NEW.rr_flaga=NEW.rr_flaga|(1<<9);
  END IF;
  IF (NEW.pl_idplatnosc IS NOT NULL AND NEW.rr_iswn=FALSE) THEN
   NEW.rr_flaga=NEW.rr_flaga|(1<<10);
  END IF;
  IF (NEW.zp_idelzapisu IS NOT NULL AND NEW.rr_iswn=TRUE) THEN
   NEW.rr_flaga=NEW.rr_flaga|(1<<11);
  END IF;
  IF (NEW.zp_idelzapisu IS NOT NULL AND NEW.rr_iswn=FALSE) THEN
   NEW.rr_flaga=NEW.rr_flaga|(1<<12);
  END IF;
 END IF;

 -------------------------------------------------------------------------------------------------------------
 --- ENDOF: Flagi
 -------------------------------------------------------------------------------------------------------------

 -------------------------------------------------------------------------------------------------------------
 --- STARTOF: Wyliczenie salda
 -------------------------------------------------------------------------------------------------------------
 IF (TG_OP<>'INSERT') THEN
  diswno=OLD.rr_iswn;
  IF (OLD.rr_wartoscpozpln=0) THEN
   disrro=TRUE;
  END IF;
  IF (OLD.rr_isnormal=TRUE AND OLD.rr_isbufor=FALSE) THEN
   dsaldoo=dsaldoo-(OLD.rr_wartoscwnpln+OLD.rr_wartoscmapln);
   dsaldopozo=dsaldopozo-(OLD.rr_wartoscwnpozpln+OLD.rr_wartoscmapozpln);
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  diswnn=NEW.rr_iswn;
  IF (NEW.rr_wartoscpozpln=0) THEN
   disrrn=TRUE;
  END IF;
  IF (NEW.rr_isnormal=TRUE AND NEW.rr_isbufor=FALSE) THEN
   dsaldon=dsaldon+(NEW.rr_wartoscwnpln+NEW.rr_wartoscmapln);
   dsaldopozn=dsaldopozn+(NEW.rr_wartoscwnpozpln+NEW.rr_wartoscmapozpln);
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (nullZero(OLD.sd_idsalda)=nullZero(NEW.sd_idsalda) AND (disrro=disrrn) AND (diswno=diswnn)) THEN
   dsaldon=dsaldon+dsaldoo;
   dsaldopozn=dsaldopozn+dsaldopozo;
   dsaldoo=0;
   dsaldopozo=0;
  END IF;
 END IF;

 IF (dsaldoo<>0 OR dsaldopozo<>0) THEN
  UPDATE kr_salda SET 
                      sd_wn=sd_wn+(CASE WHEN diswno=TRUE THEN dsaldoo ELSE 0 END),
                      sd_ma=sd_ma+(CASE WHEN diswno=FALSE THEN dsaldoo ELSE 0 END),
                      sd_wnnr=sd_wnnr+(CASE WHEN diswno=TRUE AND disrro=FALSE THEN dsaldoo ELSE 0 END),
                      sd_manr=sd_manr+(CASE WHEN diswno=FALSE AND disrro=FALSE THEN dsaldoo ELSE 0 END),
                      sd_wnpoz=sd_wnpoz+(CASE WHEN diswno=TRUE THEN dsaldopozo ELSE 0 END),
                      sd_mapoz=sd_mapoz+(CASE WHEN diswno=FALSE THEN dsaldopozo ELSE 0 END)
  	          WHERE sd_idsalda=OLD.sd_idsalda;
 END IF;
 IF (dsaldon<>0 OR dsaldopozn<>0) THEN
--  IF (diswnn=FALSE) THEN
--   RAISE EXCEPTION 'Jest % % % %',diswnn,dsaldon,dsaldopozn,NEW.sd_idsalda;
---  END IF;
  UPDATE kr_salda SET 
                      sd_wn=sd_wn+(CASE WHEN diswnn=TRUE THEN dsaldon ELSE 0 END),
                      sd_ma=sd_ma+(CASE WHEN diswnn=FALSE THEN dsaldon ELSE 0 END),
                      sd_wnnr=sd_wnnr+(CASE WHEN diswnn=TRUE AND disrrn=FALSE THEN dsaldon ELSE 0 END),
                      sd_manr=sd_manr+(CASE WHEN diswnn=FALSE AND disrrn=FALSE THEN dsaldon ELSE 0 END),
                      sd_wnpoz=sd_wnpoz+(CASE WHEN diswnn=TRUE THEN dsaldopozn ELSE 0 END),
                      sd_mapoz=sd_mapoz+(CASE WHEN diswnn=FALSE THEN dsaldopozn ELSE 0 END)
  	          WHERE sd_idsalda=NEW.sd_idsalda;
 END IF;

 -------------------------------------------------------------------------------------------------------------
 --- ENDOF: Wyliczenie salda
 -------------------------------------------------------------------------------------------------------------
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
