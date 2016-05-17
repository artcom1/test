CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 r RECORD;
BEGIN

 SELECT twx.ttw_idtowaru,twx.ttw_whereparams INTO r 
 FROM tg_towary AS tw 
 JOIN tg_towary AS twx ON (twx.ttw_idtowaru=tw.ttw_idxref) 
 WHERE tw.ttw_idtowaru=recpartii.ttw_idtowaru AND twx.ttw_rtowaru=128;                 --- Tylko rozmiarowka
 IF (r.ttw_idtowaru IS NULL) THEN
  RETURN NULL;
 END IF;
 
 RETURN gmr.findPartiaParentRozm(recpartii,r.ttw_idtowaru,r.ttw_whereparams,createIfNotExists);
END;
$$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 q TEXT;
 savedid INT;
 savedidp INT;
 r RECORD;
BEGIN

 recpartii.prt_idpartii=NULL;
 RETURN (gmr.findOrCreatePartiaLikeOther(recpartii,idtowarundx,createifnotexists)).prt_idpartii;
END;
$$;
