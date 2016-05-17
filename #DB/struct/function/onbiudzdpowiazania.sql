CREATE FUNCTION onbiudzdpowiazania() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 zdarzenie RECORD;
 tmp INT:=0;
BEGIN

 IF (TG_OP='INSERT') THEN
 ---Przepisujemy dodatkowy rodzaj ze zdarzenia (zwykle, windykacyjne)
  SELECT ((zd_flaga&384) >>7) AS  rodzaj INTO zdarzenie FROM tb_zdarzenia WHERE zd_idzdarzenia=NEW.zd_idzdarzenia;
  NEW.zp_flaga=(NEW.zp_flaga&(~3))|(zdarzenie.rodzaj&3);
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
