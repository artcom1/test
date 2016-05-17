CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 ret tg_partie;
BEGIN 
 IF (wzor.rmp_idsposobu IS NOT DISTINCT FROM idsposobunew) THEN
  RETURN wzor;
 END IF;
 wzor.rmp_idsposobu=idsposobunew; 
 ret=gmr.findorcreatepartialikeother(wzor,wzor.ttw_idtowaru,savenewtodbifnotexists);
 RETURN ret;
END;
$$;
