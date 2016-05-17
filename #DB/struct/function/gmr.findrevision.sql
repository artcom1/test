CREATE FUNCTION findrevision(idsposobu integer, idtowarundx integer, createifnotexists boolean DEFAULT false) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
 r RECORD;
 ret INT;
 ----kodex TEXT;
BEGIN

 IF (idsposobu IS NULL OR idtowarundx IS NULL) THEN
  RETURN NULL;
 END IF;
 
 SELECT ttw_idtowaru_ndx INTO r FROM tg_rozmsppak WHERE rmp_idsposobu=idsposobu;
 IF (r.ttw_idtowaru_ndx IS NOT DISTINCT FROM idtowarundx) THEN
  RETURN idsposobu;
 END IF;
 
 ---kodex=gmr.sp_generatekodex(idsposobu,true);

 FOR r IN 
          WITH m AS
          ( --- Oryginalny rekord
		   SELECT COALESCE(me.ttw_idtowaru_pdx,tw.ttw_idtowaru) AS ttw_idtowaru,me.rmk_przelicznik AS rmk_przelicznikm
		   FROM tg_rozmsppakelems AS me -------- Elementy zrodlowe
		   LEFT OUTER JOIN tg_rozmrodzajeelems AS e ON (e.rme_idelemu=me.rme_idelemu)    --- Elementy
		   LEFT OUTER JOIN tg_towary AS tw ON (tw.ttw_idxsufix=e.rme_kod AND tw.ttw_idxref=idtowarundx AND e.rme_isactive=true AND tw.ttw_idxref IS NOT NULL)
		   WHERE me.rmp_idsposobu=idsposobu AND 
		        (me.ttw_idtowaru_pdx IS NOT NULL OR tw.ttw_idtowaru IS NOT NULL) AND
				(me.ttw_idtowaru_pdx IS NULL OR tw.ttw_idtowaru IS NULL)		         
		 ),
		 v AS
		 ( --- Matryca
		  SELECT vhe.ttw_idtowaru_pdx AS ttw_idtowaru_pdx,vhe.rmk_przelicznik AS rmk_przelicznikv,vh.rmp_idsposobu		  
		  FROM tg_rozmsppak AS vh      -------- Matryce
		  JOIN tg_rozmsppakelems AS vhe ON (vhe.rmp_idsposobu=vh.rmp_idsposobu)   --- Elementy matrycy
	      JOIN tg_towary AS vhtw ON (vhtw.ttw_idtowaru=vhe.ttw_idtowaru_pdx)      --- Podindeksy matrycy
		  WHERE vh.ttw_idtowaru_ndx=idtowarundx AND vh.rmp_istmp=FALSE ----AND vh.rmp_kodex=kodex
		 ),
		 j AS 
		 ( --- Polaczenie dwoch tabel
          SELECT * 
          FROM m 
          FULL JOIN v ON (m.ttw_idtowaru=v.ttw_idtowaru_pdx AND m.rmk_przelicznikm=v.rmk_przelicznikv)
        ),
		k AS 
		( --- Dla kazdego rekordu znajdz ilosc pasujacych
         SELECT rmp_idsposobu,count(*) AS ile
		 FROM j
		 WHERE rmk_przelicznikm IS NOT NULL AND rmk_przelicznikv IS NOT NULL
		 GROUP BY rmp_idsposobu
		),
		l AS 
		( --- Ilosc nie pasujacych rekordow
         SELECT rmp_idsposobu ,count(*) AS ile
		 FROM j
		 WHERE rmk_przelicznikm IS NULL OR rmk_przelicznikv IS NULL AND rmp_idsposobu IS NOT NULL		 
		 GROUP BY rmp_idsposobu
		),
		ec AS
		(
		 SELECT count(*) powinnobyc FROM m
		) 		 
 SELECT max(k.rmp_idsposobu) AS rmp_idsposobu,count(*) AS ile 
 FROM ec,k
 LEFT JOIN l USING (rmp_idsposobu)
 WHERE l.rmp_idsposobu IS NULL AND k.ile=ec.powinnobyc
 HAVING count(*)>0
 LOOP
  IF (r.ile IS DISTINCT FROM 1) THEN
   RAISE EXCEPTION 'Blad tworzenia wersji matrycy rozmiarowki (znaleziono % rekordow)',r.ile;
  END IF;
  
  RETURN r.rmp_idsposobu;
 END LOOP;

 SELECT * INTO r FROM tg_rozmsppak WHERE rmp_idsposobu=idsposobu;
 IF (r.ttw_idtowaru_ndx IS NOT NULL) THEN
  IF (r.ttw_idtowaru_ndx IS NOT DISTINCT FROM idtowarundx) AND (r.rmp_idsposobu_ref IS NOT NULL) THEN
   RETURN r.rmp_idsposobu;
  END IF;
 END IF;

 IF ((SELECT count(*) FROM tg_rozmsppakelems WHERE rmp_idsposobu=idsposobu)=0) THEN
  ret=(SELECT rmp_idsposobu FROM tg_rozmsppak AS sp WHERE ttw_idtowaru_ndx=idtowarundx AND NOT EXISTS (SELECT 1 FROM tg_rozmsppakelems AS e WHERE e.rmp_idsposobu=sp.rmp_idsposobu));
  IF (ret IS NOT NULL) THEN
   return ret;
  END IF;
 END IF;
 
 
 IF (createIfNotExists = FALSE) THEN
  RETURN NULL;
 END IF;
 
 SELECT * INTO r FROM tg_rozmsppak WHERE rmp_idsposobu=idsposobu FOR UPDATE;
 --- Sprawdz czy juz przypadkiem nie ma takiego elementu
 IF (r.rmp_idsposobu IS NULL) THEN
  RAISE EXCEPTION 'Nie znalazlem poprawnego zrodlowego sposobu pakowania (%)',idsposobu;
 END IF;
 
 ret=nextval('tg_rozmrodzaje_s');
 
 INSERT INTO tg_rozmsppak
  (rmp_idsposobu,rmp_kod,ttw_idtowaru_ndx,rmp_idsposobu_ref)
 SELECT ret,rmp_kod,idtowarundx,(CASE WHEN rmp_istmp=TRUE THEN NULL ELSE idsposobu END) FROM tg_rozmsppak WHERE rmp_idsposobu=idsposobu;

 INSERT INTO tg_rozmsppakelems
  (rmp_idsposobu,rmk_przelicznik,ttw_idtowaru_pdx)
 SELECT
  ret,me.rmk_przelicznik,COALESCE(me.ttw_idtowaru_pdx,tw.ttw_idtowaru)
 FROM tg_rozmsppakelems AS me
 JOIN tg_rozmsppak AS sp ON (sp.rmp_idsposobu=me.rmp_idsposobu)
 LEFT OUTER JOIN tg_rozmrodzajeelems AS e ON (e.rme_idelemu=me.rme_idelemu)    --- Elementy
 LEFT OUTER JOIN tg_towary AS tw ON (tw.ttw_idxsufix=e.rme_kod AND tw.ttw_idxref=idtowarundx AND tw.ttw_idxref IS NOT NULL)
 WHERE me.rmp_idsposobu=idsposobu AND (tw.ttw_idtowaru IS NOT NULL OR sp.rmp_istmp=TRUE);

 IF (gmr.findRevision(idsposobu,idtowarundx,FALSE) IS DISTINCT FROM ret) THEN
  IF ((SELECT count(*) FROM tg_rozmsppakelems WHERE rmp_idsposobu=idsposobu)=0) THEN
   RETURN ret;
  END IF;
  RAISE EXCEPTION 'Blad przy tworzeniu wersji sposobu pakowania';
 END IF;
  					  
 RETURN ret;
END;
$$;
