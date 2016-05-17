CREATE FUNCTION findorcreatepartialikeother_withsposobpakowania(wzor public.tg_partie, idsposobunew integer, savenewtodbifnotexists boolean DEFAULT true) RETURNS public.tg_partie
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
