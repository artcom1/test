CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 ret tg_partie;
 idref INT;
 rozroznik INT;
BEGIN
 
 IF (wzor.prt_terozroznik IS NOT NULL) THEN
  IF (wzor.prt_idpartii IS NOT NULL) THEN
   rozroznik=(SELECT prt_terozroznik FROM tg_partie WHERE prt_idparent_rozm=wzor.prt_idpartii AND ttw_idtowaru=wzor.ttw_idtowaru AND prt_wplyw=wzor.prt_wplyw);
  END IF;
  IF (rozroznik IS NULL) THEN
   rozroznik=(SELECT prt_terozroznik FROM tg_partie WHERE prt_idparent_rozm=(SELECT prt_idpartii FROM tg_partie WHERE prt_terozroznik=wzor.prt_terozroznik AND prt_wplyw=wzor.prt_wplyw) AND ttw_idtowaru=wzor.ttw_idtowaru);
  END IF;
  IF (rozroznik IS NULL) THEN
   rozroznik=(SELECT tel_idelem FROM tg_transelem WHERE ttw_idtowaru=idtowarunew AND tel_skojzestaw=wzor.prt_terozroznik LIMIT 2);
  END IF;
  IF (rozroznik IS NULL) THEN
   IF (wzor.prt_idpartii IS NULL) THEN
    RETURN NULL;
   END IF;
   RAISE EXCEPTION 'Blad rozroznika';
  END IF;
 END IF;
 -----------------------------------------------------------------------------------------
 IF (wzor.prt_idref IS NOT NULL) THEN
  idref=(SELECT gmr.findOrCreatePartiaLikeOther(p,idtowarunew,savenewtodbifnotexists) FROM tg_partie AS p WHERE p.prt_idpartii=wzor.prt_idref);
  IF (idref IS NULL) THEN
   RETURN NULL;
  END IF;
 END IF;
 
 SELECT p.* INTO ret
 FROM tg_partie AS p
 WHERE ttw_idtowaru=idtowarunew AND
       prt_hashcode IS NOT DISTINCT FROM wzor.prt_hashcode AND
	   k_idklienta IS NOT DISTINCT FROM wzor.k_idklienta AND
 	   zl_idzlecenia IS NOT DISTINCT FROM wzor.zl_idzlecenia AND
	   prt_serialno IS NOT DISTINCT FROM wzor.prt_serialno AND
	   prt_datawazn IS NOT DISTINCT FROM wzor.prt_datawazn AND
	   prt_wplyw IS NOT DISTINCT FROM wzor.prt_wplyw AND
	   prt_idref IS NOT DISTINCT FROM idref AND
	   prt_terozroznik IS NOT DISTINCT FROM rozroznik AND
	   prt_inkj IS NOT DISTINCT FROM wzor.prt_inkj AND
	   rmp_idsposobu IS NOT DISTINCT FROM wzor.rmp_idsposobu;
 IF (ret.prt_idpartii IS NOT NULL) THEN
  RETURN ret;
 END IF;
	 
 ret=wzor;
 ret.ttw_idtowaru=idtowarunew;
 ret.prt_rtowaru=(SELECT ttw_rtowaru FROM tg_towary WHERE ttw_idtowaru=idtowarunew);
 
 IF (savenewtodbifnotexists=FALSE) THEN
  ret.prt_idpartii=NULL;
  ret.prt_idref=idref;
  ret.prt_flaga=(1<<12);
  RETURN ret;
 END IF;

 --Wczytaj ID z sekwencji
 ret.prt_idpartii=nextval('tg_partie_s');
 
 ---Rozroznik kopiujemy zrodlowy - sztuczna partia uslugowa w takim przypadku dostanie rozroznik taki jak pozycja
 
 INSERT INTO tg_partie
  (prt_idpartii,ttw_idtowaru,prt_hashcode,k_idklienta,zl_idzlecenia,
   prt_serialno,prt_datawazn,prt_wplyw,prt_hashopis,
   prt_jm1,prt_jm2,prt_przelicznik1,prt_przelicznik2,prt_dokl12,
   prt_idref,
   prt_terozroznik,prt_inkj,
   zprt_id,
   prt_rtowaru,
   rmp_idsposobu,
   prt_flaga
   )
 VALUES
  (
   ret.prt_idpartii,ret.ttw_idtowaru,ret.prt_hashcode,ret.k_idklienta,ret.zl_idzlecenia,
   ret.prt_serialno,ret.prt_datawazn,ret.prt_wplyw,ret.prt_hashopis,
   ret.prt_jm1,ret.prt_jm2,
   ret.prt_przelicznik1,ret.prt_przelicznik2,ret.prt_dokl12,
   idref,
   rozroznik,ret.prt_inkj,
   ret.zprt_id,
   ret.prt_rtowaru,
   ret.rmp_idsposobu,
   ret.prt_flaga
  );
  
 RETURN ret;
END;
$$;
