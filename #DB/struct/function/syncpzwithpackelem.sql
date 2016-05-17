CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idelempzam ALIAS FOR $1;
 _idpackelem ALIAS FOR $2;
 _deltailosc ALIAS FOR $3;
 r RECORD;
BEGIN

 SELECT rm_idrealizacji INTO r FROM tg_realizacjapzam WHERE rm_powod=8 AND tel_idelemsrc=_idelempzam AND pe_idelemuzam=_idpackelem LIMIT 1;
 IF NOT FOUND THEN
  INSERT INTO tg_realizacjapzam
   (rm_iloscf,rm_powod,tel_idelemsrc,rm_flaga,pe_idelemuzam)
  VALUES
   (_deltailosc,8,_idelempzam,(5<<4)|2|4,_idpackelem);

   RETURN (SELECT currval('tg_realizacjapzam_s'));
 ELSE
  UPDATE tg_realizacjapzam SET rm_iloscf=rm_iloscf+_deltailosc WHERE rm_idrealizacji=r.rm_idrealizacji;
  RETURN r.rm_idrealizacji;
 END IF;

 RETURN NULL;
END;
$_$;
