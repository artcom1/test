CREATE FUNCTION przeliczallbackorderkkw(_kkwhead tr_kkwhead) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE 
 _wynik INT;
 ret    INT:=-1;
BEGIN 
 IF (_kkwhead IS NULL) THEN
  RETURN ret;
 ELSE
  ret=_kkwhead.kwh_idheadu;
 END IF;

 --IF (zzerowaniem) THEN
 DELETE FROM tg_backorder WHERE bo_powod=4 AND kwh_idheadusrc=_kkwhead.kwh_idheadu;
 DELETE FROM tg_backorder WHERE bo_powod=3 AND knr_idelemusrc IN (SELECT knr_idelemu FROM tr_nodrec WHERE kwh_idheadu=_kkwhead.kwh_idheadu);
 --END IF;
  
 IF ((_kkwhead.kwh_flaga&3)<>0) THEN ---KKW zamkniete, nic nie licze
  ret=0;
 ELSE	   
  _wynik=
  (
   SELECT sum(i) FROM 
   (
    SELECT
    (
     CASE 
     WHEN knr_wplywmag=1 THEN 
     DodajBackOrderNodRec(knr_idelemu,ttm_idtowmag,max(knr_iloscplan-knr_iloscrozch,0),3,1,coalesce(_kkwhead.kwh_dataplanstop,_kkwhead.kwh_datazak)::date,zl_idzlecenia,knr_flaga,nod.tmg_idmagazynu)
     ELSE 
     DodajBackOrderNodRec(knr_idelemu,ttm_idtowmag,max(knr_iloscplan-knr_iloscrozch,0),3,0,coalesce(_kkwhead.kwh_dataplanstart,_kkwhead.kwh_datarozp)::date,zl_idzlecenia,knr_flaga,nod.tmg_idmagazynu)
     END
    ) AS i
    FROM tr_nodrec AS nod JOIN tr_kkwhead AS kkw USING (kwh_idheadu)
    WHERE nod.kwh_idheadu=_kkwhead.kwh_idheadu AND knr_flaga&(4+2+1)=0 AND (knr_wplywmag=-1 OR knr_wplywmag=1)
   ) AS t
  );
	
  PERFORM dodajBackOrderKKW(_kkwhead.kwh_idheadu,(SELECT ttm_idtowmag FROM tg_towmag WHERE ttw_idtowaru=_kkwhead.ttw_idtowaru AND tmg_idmagazynu=_kkwhead.tmg_idmagazynu_def),max(0,_kkwhead.kwh_iloscoczek-_kkwhead.kwh_iloscwmag),4,coalesce(_kkwhead.kwh_dataplanstop,_kkwhead.kwh_datazak)::date,_kkwhead.zl_idzlecenia,_kkwhead.kwh_towary,_kkwhead.tmg_idmagazynu_def);    
 END IF;
 
 RETURN ret;
END;
$$;
