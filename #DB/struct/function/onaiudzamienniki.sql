CREATE FUNCTION onaiudzamienniki() RETURNS trigger
    LANGUAGE plpgsql
    AS $$  
BEGIN
 
 IF (TG_OP='INSERT') THEN
  PERFORM oznaczTowarZamiennik(NEW.zt_idtowarusrc,1);
  IF (NEW.zt_flaga&1=1) THEN
   PERFORM oznaczTowarZamiennik(NEW.zt_idtowarudesc,1);
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
 ---oznaczac dla zmiany symetrycznosci i zmiany id desc
  IF (NEW.zt_idtowarusrc!=OLD.zt_idtowarusrc) THEN
  ---gdy sie zmienil towar zrodlowy
   PERFORM oznaczTowarZamiennik(OLD.zt_idtowarusrc,(SELECT count(*)::int from tv_zamienniki WHERE zt_idtowarusrc=OLD.zt_idtowarusrc));
   PERFORM oznaczTowarZamiennik(NEW.zt_idtowarusrc,1);
  END IF;
  IF (NEW.zt_flaga&1=1 AND OLD.zt_flaga&1=0) THEN
  ---jest symetryczny a nie byl, dodajemy do towaru desc oznaczenie ze ma zamiennik
   PERFORM oznaczTowarZamiennik(NEW.zt_idtowarudesc,1);
  END IF;

  IF (NEW.zt_flaga&1=0 AND OLD.zt_flaga&1=1) THEN
  ---byl symetryczny a nie byl, kasujemy oznaczenie
   PERFORM oznaczTowarZamiennik(NEW.zt_idtowarudesc,(SELECT count(*)::int from tv_zamienniki WHERE zt_idtowarusrc=NEW.zt_idtowarudesc));
  END IF;

  IF (NEW.zt_idtowarudesc!=OLD.zt_idtowarudesc AND NEW.zt_flaga&1=1 AND OLD.zt_flaga&1=1) THEN
  ---zmienil sie zamiennik ale obydwa sa symetryczne
   PERFORM oznaczTowarZamiennik(OLD.zt_idtowarudesc,(SELECT count(*)::int from tv_zamienniki WHERE zt_idtowarusrc=OLD.zt_idtowarudesc));
   PERFORM oznaczTowarZamiennik(NEW.zt_idtowarudesc,1);
  END IF;
 
 END IF;

 IF (TG_OP='DELETE') THEN
  PERFORM oznaczTowarZamiennik(OLD.zt_idtowarusrc,(SELECT count(*)::int from tv_zamienniki WHERE zt_idtowarusrc=OLD.zt_idtowarusrc));
  IF (OLD.zt_flaga&1=1) THEN
   PERFORM oznaczTowarZamiennik(OLD.zt_idtowarudesc,(SELECT count(*)::int from tv_zamienniki WHERE zt_idtowarusrc=OLD.zt_idtowarudesc));
  END IF;
 END IF;
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
