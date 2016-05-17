CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 parent integer;
 rodzaj integer;
BEGIN
 
 IF (TG_OP = 'DELETE') THEN
  parent = OLD.zd_idparent;
  rodzaj = OLD.zd_rodzaj;
 ELSE 
  parent = NEW.zd_idparent;
  rodzaj = NEW.zd_rodzaj;
 END IF; 
 
 IF (parent IS NOT NULL) 
	AND (NOT zdarzenie_isticketheader(rodzaj)) 
	AND ((TG_OP = 'DELETE') OR (TG_OP = 'INSERT') OR ((NEW.zd_flaga&(3<<2))<>(OLD.zd_flaga&(3<<2))))
 THEN 
	WITH czd(spr_id, zd_id, status) AS
	(
		SELECT zd.zd_idparent AS spr_id, zd.zd_idzdarzenia AS zd_id, zd.zd_flaga&(3<<2) AS status
		FROM tb_zdarzenia AS zd
		WHERE zd.zd_idparent = parent 
		ORDER BY ((zd.zd_flaga&(3<<2))=0) DESC, zd.zd_idzdarzenia DESC 
		LIMIT 1
	)
	UPDATE tb_zdarzenia AS spr
	SET zd_flaga = (spr.zd_flaga&(~(3<<2))) | n.status,
		zd_aktualnieu = n.zd_id
	FROM czd AS n
	WHERE spr.zd_idzdarzenia = n.spr_id
		AND zdarzenie_isticketheader(spr.zd_rodzaj);
 END IF; 
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
 
END;
$$;
