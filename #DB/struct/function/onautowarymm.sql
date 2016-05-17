CREATE FUNCTION onautowarymm() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 
 IF (NEW.ttw_objetosc_mpq<>OLD.ttw_objetosc_mpq) OR (NEW.ttw_waga<>OLD.ttw_waga) THEN
  PERFORM (SELECT count(*) FROM (SELECT WMSCountAll(mm_idmiejsca) FROM 
    (SELECT DISTINCT mm_idmiejsca FROM tg_ruchy WHERE isPZet(rc_flaga) AND rc_iloscpoz>0 AND ttw_idtowaru=NEW.ttw_idtowaru AND mm_idmiejsca IS NOT NULL) AS a
   ) AS b);
 END IF;

 RETURN NEW;
END;
$$;
