CREATE FUNCTION onbiudplatfifo() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltawal NUMERIC:=0;
 deltapln NUMERIC:=0;
BEGIN

 IF (TG_OP='INSERT') THEN
  IF (NEW.po_wplyw>0) THEN
   NEW.po_pozostalowal=NEW.po_kwotawal;
   NEW.po_pozostalopln=NEW.po_kwotapln;
  ELSE
   NEW.po_pozostalowal=0;
   NEW.po_pozostalopln=0;
  END IF;
 END IF;

 IF (TG_OP<>'INSERT') THEN
  IF (OLD.po_wplyw<0) THEN
   deltawal=deltawal-OLD.po_kwotawal;
   deltapln=deltapln-OLD.po_kwotapln;
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  IF (NEW.po_wplyw<0) THEN
   deltawal=deltawal+NEW.po_kwotawal;
   deltapln=deltapln+NEW.po_kwotapln;
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN 
  IF (NEW.po_wplyw>0) THEN
   NEW.po_pozostalowal=NEW.po_pozostalowal+(NEW.po_kwotawal-OLD.po_kwotawal);
   NEW.po_pozostalopln=NEW.po_pozostalopln+(NEW.po_kwotapln-OLD.po_kwotapln);
  END IF;

  IF (OLD.po_ref<>NEW.po_ref) THEN
   RAISE EXCEPTION 'Nie mozna zmieniac przypisania kantoru walut';
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  IF ((NEW.po_flaga&8192)=0) THEN
   IF (NEW.po_pozostalowal<0 OR NEW.po_pozostalopln<0) THEN
    RAISE EXCEPTION '26|%:%:%:%:%|Niedozwolona zmiana wartosci ',NEW.pl_idplatnosc,NEW.bk_idbanku,NEW.po_pozostalowal,NEW.po_pozostalopln,NEW.wl_idwaluty;
   END IF;
   IF (NEW.po_pozostalowal=0 AND NEW.po_pozostalopln>0) THEN
    RAISE EXCEPTION '25|%:%:%|Niedozwolona zmiana wartosci w PLN ',NEW.pl_idplatnosc,NEW.bk_idbanku,NEW.po_pozostalopln;
   END IF;
  END IF;
 END IF;

 IF (deltawal<>0 OR deltapln<>0) THEN
  IF (TG_OP<>'DELETE') THEN
   UPDATE kh_platfifo SET po_pozostalowal=po_pozostalowal-deltawal,po_pozostalopln=po_pozostalopln-deltapln WHERE po_idfifo=NEW.po_ref;
  ELSE
   UPDATE kh_platfifo SET po_pozostalowal=po_pozostalowal-deltawal,po_pozostalopln=po_pozostalopln-deltapln WHERE po_idfifo=OLD.po_ref;
  END IF;
 END IF;
    
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
