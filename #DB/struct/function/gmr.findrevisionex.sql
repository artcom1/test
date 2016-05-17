CREATE FUNCTION findrevisionex(idsposobu integer, idtowarundx integer, createifnotexists boolean DEFAULT false) RETURNS findrevisionex_ret
    LANGUAGE plpgsql
    AS $$
DECLARE
 ret gmr.findrevisionex_ret;
BEGIN

 ret.rmp_idsposobu=gmr.findRevision(idsposobu,idtowarundx,createifnotexists);
 if (ret.rmp_idsposobu IS NOT NULL) THEN
  ret.xmin=(SELECT xmin FROM tg_rozmsppak WHERE rmp_idsposobu=ret.rmp_idsposobu);
 END IF;
 
 RETURN ret;
END;
$$;
