CREATE FUNCTION onukonta() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltawn NUMERIC:=0;
 deltama NUMERIC:=0;
 deltawnbuf NUMERIC:=0;
 deltamabuf NUMERIC:=0;
 deltasdwn NUMERIC:=0;
 deltasdma NUMERIC:=0;
 deltasdwnbuf NUMERIC:=0;
 deltasdmabuf NUMERIC:=0;
 changednr BOOL:=false;
 rec RECORD;
 chnow BOOL:=false;
BEGIN


IF (TG_OP = 'DELETE') THEN
 --Konieczna zmiana wg. OLDow
 chnow=TRUE;
END IF;

IF (TG_OP = 'INSERT') THEN

 changednr=TRUE;

 IF (NEW.kt_ref IS NOT NULL) THEN
  SELECT zp_idelzapisu INTO rec FROM kh_zapisyelem WHERE kt_idkontawn=NEW.kt_ref OR kt_idkontama=NEW.kt_ref LIMIT 1 OFFSET 0;
  IF FOUND THEN
   RAISE EXCEPTION 'Istnieja zapisy na konto % ',NEW.kt_ref;
  END IF;
  DELETE FROM kh_obroty WHERE kt_idkonta=NEW.kt_ref AND mn_miesiac IS NOT NULL;
  --------------------------------------
  SELECT COALESCE(ktt_idtypuinh,ktt_idtypu) AS k INTO rec FROM kh_konta WHERE kt_idkonta=NEW.kt_ref;
  NEW.ktt_idtypuinh=rec.k;
 END IF;

END IF;

IF (TG_OP = 'UPDATE') THEN

 IF ((NEW.kt_flaga&16384)<>0) THEN
  NEW.kt_flaga=NEW.kt_flaga&(~16384);
  RETURN NEW;
 END IF;
 IF (nullZero(NEW.kt_ref)<>nullZero(OLD.kt_ref)) THEN
  IF ((NEW.kt_flaga&8192)=0) THEN
   RAISE EXCEPTION 'Nie mozna przenosic calych drzew';
   --Konieczna zmiana wg. OLDow
  END IF;
  NEW.kt_flaga=NEW.kt_flaga&(~8192);
  chnow=TRUE;
 END IF;
 IF (NEW.wl_idwaluty<>OLD.wl_idwaluty) THEN
  RAISE EXCEPTION 'Proba zmiany waluty konta lub proba zapisu na konto w innej walucie';
 END IF;
 IF (NEW.kt_flaga&16)<>(OLD.kt_flaga&16) AND (NEW.kt_flaga&2)<>0 THEN
  RAISE EXCEPTION 'Nie mozna robic zapisow na konta nie bedace liscmi';
 END IF;
 NEW.kt_flaga=NEW.kt_flaga&(~16);

END IF;

--- Wartosc delta winien
IF (TG_OP <> 'INSERT') THEN
 deltawn=-OLD.kt_wn;
 deltama=-OLD.kt_ma;
 deltawnbuf=-OLD.kt_wnbuf;
 deltamabuf=-OLD.kt_mabuf;
 deltasdwn=-OLD.kt_sdwn;
 deltasdma=-OLD.kt_sdma;
 deltasdwnbuf=-OLD.kt_sdwnbuf;
 deltasdmabuf=-OLD.kt_sdmabuf;
END IF;

IF (chnow) THEN
 IF (
     (deltawn<>0) OR (deltama<>0) OR (deltawnbuf<>0) OR (deltamabuf<>0) OR 
     (deltasdwn<>0) OR (deltasdma<>0) OR (deltasdwnbuf<>0) OR (deltasdmabuf<>0) OR 
     (TG_OP='DELETE')
    ) THEN
  --- Zrob update wartosci kont
  UPDATE kh_konta SET kt_wn=kt_wn+deltawn,kt_ma=kt_ma+deltama,kt_wnbuf=kt_wnbuf+deltawnbuf,kt_mabuf=kt_mabuf+deltamabuf,
                      kt_sdwn=kt_sdwn+deltasdwn,kt_sdma=kt_sdma+deltasdma,kt_sdwnbuf=kt_sdwnbuf+deltasdwnbuf,kt_sdmabuf=kt_sdmabuf+deltasdmabuf,
                      kt_flaga=kt_flaga&(~checkFlagaKonta(OLD.kt_idkonta,OLD.kt_ref)) 
                  WHERE kt_idkonta=OLD.kt_ref;
  deltawn=0;
  deltama=0;
  deltawnbuf=0;
  deltamabuf=0;
  deltasdwn=0;
  deltasdma=0;
  deltasdwnbuf=0;
  deltasdmabuf=0;
 END IF;
END IF;


IF (TG_OP <> 'DELETE') THEN

 IF (NEW.kt_flaga&2=0) THEN
  -----------------------------------------------------
  IF (NEW.kt_wnbuf>NEW.kt_mabuf) THEN
   NEW.kt_sdwnbuf=NEW.kt_wnbuf-NEW.kt_mabuf;
   NEW.kt_sdmabuf=0;
  ELSE
   NEW.kt_sdwnbuf=0;
   NEW.kt_sdmabuf=NEW.kt_mabuf-NEW.kt_wnbuf;
  END IF;
  -----------------------------------------------------
  IF (NEW.kt_wn>NEW.kt_ma) THEN
   NEW.kt_sdwn=NEW.kt_wn-NEW.kt_ma;
   NEW.kt_sdma=0;
  ELSE
   NEW.kt_sdwn=0;
   NEW.kt_sdma=NEW.kt_ma-NEW.kt_wn;
  END IF;
 END IF;

 IF (NOT nullvalue(NEW.kt_ref)) THEN
  --- Jesli byl INSERT lub zmiana przepisania
  IF (TG_OP='INSERT') OR (chnow=TRUE) THEN
   SELECT INTO rec * FROM kh_konta WHERE kt_idkonta=NEW.kt_ref;
   IF FOUND THEN
    IF (rec.kt_prefix<>'') THEN 
     NEW.kt_prefix=numerKonta(rec.kt_prefix,rec.kt_numer,rec.kt_zerosto);
    ELSE
     NEW.kt_prefix=numerKonta('',rec.kt_numer,rec.kt_zerosto);
    END IF;
    --Bity od 0 do 3 to skopiowane bity od 4 do 7 z rodzica
    NEW.kt_zerosto=(NEW.kt_zerosto&(~752))|((rec.kt_zerosto&15)<<4)|((rec.kt_zerosto&256)<<1);
    NEW.kt_poziom=rec.kt_poziom+1;
   ELSE
    NEW.kt_poziom=0;
   END IF;
   NEW.kt_numer=checkNumerKonta(NEW.kt_numer,NEW.kt_zerosto);
  END IF;
  --- Update nowych wartosci
  deltawn=deltawn+NEW.kt_wn;
  deltama=deltama+NEW.kt_ma;
  deltawnbuf=deltawnbuf+NEW.kt_wnbuf;
  deltamabuf=deltamabuf+NEW.kt_mabuf;
  deltasdwn=deltasdwn+NEW.kt_sdwn;
  deltasdma=deltasdma+NEW.kt_sdma;
  deltasdwnbuf=deltasdwnbuf+NEW.kt_sdwnbuf;
  deltasdmabuf=deltasdmabuf+NEW.kt_sdmabuf;
  IF (
      (deltawn<>0) OR (deltama<>0) OR (deltawnbuf<>0) OR (deltamabuf<>0) OR 
      (deltasdwn<>0) OR (deltasdma<>0) OR (deltasdwnbuf<>0) OR (deltasdmabuf<>0) OR 
      ((NEW.kt_flaga&2)=0)
     ) OR (TG_OP='INSERT') OR (chnow=TRUE) 
  THEN
   UPDATE kh_konta SET kt_wn=kt_wn+deltawn,kt_ma=kt_ma+deltama,kt_wnbuf=kt_wnbuf+deltawnbuf,kt_mabuf=kt_mabuf+deltamabuf,
                       kt_sdwn=kt_sdwn+deltasdwn,kt_sdma=kt_sdma+deltasdma,kt_sdwnbuf=kt_sdwnbuf+deltasdwnbuf,kt_sdmabuf=kt_sdmabuf+deltasdmabuf,
                       kt_flaga=kt_flaga|2 
		   WHERE kt_idkonta=NEW.kt_ref;
  END IF;
  NEW.kt_flaga=NEW.kt_flaga|1;
 ELSE
  NEW.kt_prefix='';
  NEW.kt_flaga=NEW.kt_flaga&(~1);
 END IF;

END IF;

IF (TG_OP = 'UPDATE') THEN
 IF (
     (NEW.kt_prefix<>OLD.kt_prefix) OR 
     (NEW.kt_numer<>OLD.kt_numer)
    ) 
  THEN
   changednr=TRUE;
  END IF; 
END IF;


IF (changednr=TRUE) THEN
 NEW.ktn_idkonta=findIDKontaNormalized(
                   (SELECT fm_idcentrali FROM kh_lata AS l WHERE l.ro_idroku=NEW.ro_idroku),
		   NEW.kt_prefix,
		   NEW.kt_numer,
		   NEW.kt_zerosto);
END IF;


IF (TG_OP = 'DELETE') THEN
 DELETE FROM kh_obroty WHERE kt_idkonta=OLD.kt_idkonta;
 DELETE FROM kh_obroty WHERE kt_idkonta=OLD.kt_ref AND (SELECT count(*) FROM kh_obroty AS o WHERE o.ob_ref=kh_obroty.ob_id)=0;
END IF;

IF (TG_OP <> 'DELETE') THEN
 RETURN NEW;
ELSE
 RETURN OLD;
END IF;

END;$$;
