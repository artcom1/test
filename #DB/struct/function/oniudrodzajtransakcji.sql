CREATE FUNCTION oniudrodzajtransakcji() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

 --- Jesli skasowano - to usun wszystkie inne
 IF (TG_OP='DELETE') THEN
  IF (OLD.tr_rodzaj=1) THEN
   DELETE FROM tg_rodzajtransakcji WHERE tr_rodzaj<>1 AND trt_ostseria=OLD.trt_ostseria;
  END IF;
 END IF;

 --Jesli zupdatowano - to zupdatuj wszystkie inne
 IF (TG_OP='UPDATE') THEN
  IF (OLD.tr_rodzaj=1) THEN
   IF (OLD.trt_ostseria<>NEW.trt_ostseria) THEN
    UPDATE tg_rodzajtransakcji SET trt_ostseria=NEW.trt_ostseria WHERE tr_rodzaj<>1 AND trt_ostseria=OLD.trt_ostseria;
   END IF;
  END IF;
 END IF;

 --Jesli dodano - to dodaj wszystkie inne
 IF (TG_OP='INSERT') THEN
  IF (NEW.tr_rodzaj=1) THEN
   INSERT INTO tg_rodzajtransakcji
    (tr_rodzaj,trt_skrot,trt_ostseria)
   SELECT DISTINCT ON (tr_rodzaj) tr_rodzaj,trt_skrot,NEW.trt_ostseria FROM tg_rodzajtransakcji
   WHERE tr_rodzaj<>1;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END
$$;
