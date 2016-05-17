CREATE OR REPLACE FUNCTION 
    LANGUAGE sql
    AS $$
 SELECT gm.updateZamIlosci(te,updateiloscpierw) FROM tg_transelem AS te WHERE te.tel_idelem=idelem;
$$;


SET search_path = public, pg_catalog;

--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 rr RECORD;
 iloscf NUMERIC;
 id INT;
BEGIN

 IF (elem.ttw_idtowaru IS NULL) THEN
  RETURN NULL;
 END IF;

 SELECT * INTO rr FROM tg_zamilosci WHERE tel_idelem=elem.tel_idelem;
 IF FOUND THEN
  IF (updateiloscpierw=TRUE) THEN   
   --Wez ilosc z rekordu pierwotnego
   IF ((elem.tel_flaga&(1<<15))!=0) THEN
    --Ilosc pierwotna z ZO
    iloscf=(SELECT te.tel_iloscf FROM tg_transelem AS te JOIN tg_realizacjapzam as r ON (r.tel_idelemsrc=te.tel_idelem AND r.rm_powod=4) WHERE r.rm_powod=4 AND r.tel_idpzam=elem.tel_idelem);
   ELSE
    --Ilosc z uwzglednieniem korekt
    iloscf=(SELECT sum(tel_iloscf) FROM tg_transelem WHERE tel_idelem=elem.tel_idelem OR (tel_skojarzony=elem.tel_idelem AND tel_flaga&16=16));
   END IF;
   ---Ilosc oryginalna
   iloscf=COALESCE(iloscf,elem.tel_iloscf);
   	
   UPDATE tg_zamilosci 
   SET zmi_if_pierw=iloscf,
       tel_skojzestaw=elem.tel_skojzestaw,
	   zmi_tepos=(elem.tel_new2flaga>>15)&63
   WHERE zmi_idelemu=rr.zmi_idelemu AND 
         (zmi_if_pierw<>iloscf OR 
		  tel_skojzestaw IS DISTINCT FROM elem.tel_skojzestaw OR
		  zmi_tepos!=((elem.tel_new2flaga>>15)&63)
		  );
  ELSE
   UPDATE tg_zamilosci
   SET tel_skojzestaw=elem.tel_skojzestaw,
       zmi_tepos=(elem.tel_new2flaga>>15)&63
   WHERE zmi_idelemu=rr.zmi_idelemu AND 
         (tel_skojzestaw IS DISTINCT FROM elem.tel_skojzestaw OR
		  zmi_tepos!=((elem.tel_new2flaga>>15)&63)
		 );
  END IF;
  
  return rr.zmi_idelemu;
 END IF;
 
 id=nextval('tg_zamilosci_s');
 
 SELECT tr_idtrans,tr_rodzaj,ttw_idtowaru,tel_iloscf,ttm_idtowmag INTO rr FROM tg_transelem JOIN tg_transakcje USING (tr_idtrans) WHERE tel_idelem=elem.tel_idelem;
 --Wez ilosc z rekordu pierwotnego
 IF ((elem.tel_flaga&(1<<15))!=0) THEN
  --Ilosc pierwotna z ZO
  iloscf=(SELECT te.tel_iloscf FROM tg_transelem AS te JOIN tg_realizacjapzam as r ON (r.tel_idelemsrc=te.tel_idelem AND r.rm_powod=4) WHERE r.rm_powod=4 AND r.tel_idpzam=elem.tel_idelem);
 ELSE
  --Ilosc z uwzglednieniem korekt
  iloscf=(SELECT sum(tel_iloscf) FROM tg_transelem WHERE tel_idelem=elem.tel_idelem OR (tel_skojarzony=elem.tel_idelem AND tel_flaga&16=16));
 END IF;
 ---Ilosc oryginalna
 iloscf=COALESCE(iloscf,elem.tel_iloscf);

 INSERT INTO tg_zamilosci
  (
   zmi_idelemu,
   tel_idelem,tr_rodzaj,tr_idtrans,ttw_idtowaru,
   zmi_if_pierw,
   tmg_idmagazynu,
   zmi_if_reserved,
   zmi_if_waitingtoreserve,
   zmi_rtowaru,
   tel_skojzestaw,
   zmi_tepos,
   zmi_wplyw,
   zmi_if_inprzepakowanie
  )
 VALUES
  (id, 
   elem.tel_idelem,rr.tr_rodzaj,rr.tr_idtrans,rr.ttw_idtowaru,
   iloscf,
   (SELECT tmg_idmagazynu FROM tg_towmag WHERE ttm_idtowmag=rr.ttm_idtowmag),
    nullZero((SELECT sum(rc_iloscrez) FROM tg_ruchy WHERE isRezerwacja(rc_flaga) AND tg_ruchy.tel_idelem=elem.tel_idelem)),
	nullZero((SELECT sum(rc_ilosc-rc_iloscrezzr-rc_iloscrez) FROM tg_ruchy WHERE isRezerwacja(rc_flaga) AND tg_ruchy.tel_idelem=elem.tel_idelem)),
	(SELECT ttw_rtowaru FROM tg_towary WHERE ttw_idtowaru=rr.ttw_idtowaru),
	elem.tel_skojzestaw,
	(elem.tel_new2flaga>>15)&63,
	(CASE WHEN elem.tel_newflaga&4=4 THEN -1 ELSE 1 END),
	nullZero((SELECT sum(he.phe_iloscop*he.phe_mnoznik) FROM tg_ppheadelem AS he WHERE he.phe_docclosed=FALSE AND he.tel_idelemsrcskoj=elem.tel_idelem AND he.phe_ref IS NOT NULL))
  );

 RETURN id;   
END;
$$;
