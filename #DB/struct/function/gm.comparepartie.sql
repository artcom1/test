CREATE FUNCTION comparepartie(public.tg_partie, public.tg_partie, integer, boolean DEFAULT true, integer DEFAULT 0) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _pz        ALIAS FOR $1;
 _wz        ALIAS FOR $2;
 _wp        ALIAS FOR $3;
 _towmusteq ALIAS FOR $4;
 _neqwpmask ALIAS FOR $5;
 ret        INT:=3;
BEGIN

 _wp=_wp&(~_neqwpmask);

 IF (_pz IS NULL OR _wz IS NULL) THEN
---RAISE NOTICE 'FALSE bo pz lub wz NULL';
  RETURN 0;
 END IF;

 ---Musi byc ten sam towar
 IF (_towmusteq=TRUE AND (_pz.ttw_idtowaru<>_wz.ttw_idtowaru)) THEN
---RAISE NOTICE 'FALSE bo rozny towar';
  RETURN 0;
 END IF;


 ---Nie porownujemy dwoch WZetek (bo nie wiemy jak)
 IF (_pz.prt_wplyw<0 AND _wz.prt_wplyw<0) THEN
---RAISE NOTICE 'FALSE bo dwa rozchody';
  RETURN 0;
 END IF;


 ---Dwie PZetki
 IF (_pz.prt_wplyw>0 AND _wz.prt_wplyw>0) THEN
  ---Dwie PZetki i na obydwu 
  IF (_pz.prt_idpartii IS NOT NULL AND _wz.prt_idpartii IS NOT NULL) THEN
  ---RAISE NOTICE 'RETURN porownanie id partii';
   RETURN (CASE WHEN (_pz.prt_idpartii=_wz.prt_idpartii) THEN 3 ELSE 0 END);
  END IF;

  IF (_pz.prt_hashcode IS DISTINCT FROM _wz.prt_hashcode) THEN
   RETURN 0;
  END IF;

  IF (_pz.k_idklienta IS DISTINCT FROM _wz.k_idklienta) THEN
   RETURN 0;
  END IF;

  IF (_pz.zl_idzlecenia IS DISTINCT FROM _wz.zl_idzlecenia) THEN
   RETURN 0;
  END IF;

  IF (_pz.prt_serialno IS DISTINCT FROM _wz.prt_serialno) THEN
   RETURN 0;
  END IF;

  IF (_pz.prt_datawazn IS DISTINCT FROM _wz.prt_datawazn) THEN
   RETURN 0;
  END IF;

  IF (_pz.prt_terozroznik IS DISTINCT FROM _wz.prt_terozroznik) THEN
   RETURN 0;
  END IF;
  
  IF (_pz.prt_inkj IS DISTINCT FROM _wz.prt_inkj) THEN
   RETURN 0;
  END IF;
  
  IF(_pz.rmp_idsposobu IS DISTINCT FROM _wz.rmp_idsposobu) THEN
   RETURN 0;
  END IF;
  
  RETURN 3;
 END IF;


 IF (_pz.prt_wplyw>0 AND _wz.prt_wplyw<0) THEN

  IF (_wz.prt_idref IS NOT NULL) THEN
   IF (_wz.prt_idref=_pz.prt_idpartii) THEN
    RETURN 3;
   END IF;
   RETURN 0;
  END IF;

  IF ((COALESCE(_pz.prt_hashcode,'00000000-0000-0000-0000-000000000000'::uuid)==COALESCE(_wz.prt_hashcode,'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF'::uuid))=FALSE) THEN
---   RAISE NOTICE 'FALSE bo rozne hashcode (% i %)',_pz.prt_hashcode,_wz.prt_hashcode;
   RETURN 0;
  END IF;

  IF (_wz.prt_wplyw=-2) THEN
   RETURN 1;
  END IF;


  ret=gm.comparepartie_klient(ret,_wp,_pz.k_idklienta,_wz.k_idklienta);
  IF (ret=0) THEN
   RETURN 0;
  END IF;
  
  ret=gm.comparepartie_zlecenie(ret,_wp,_pz.zl_idzlecenia,_wz.zl_idzlecenia);
  IF (ret=0) THEN
   RETURN 0;
  END IF;
  
 END IF;

  ----NR SERYJNY
 IF ((_wp&(1<<13))<>0) THEN
  IF (_wz.prt_serialno IS NOT NULL) THEN
   IF (_pz.prt_serialno IS NOT NULL) THEN
    CASE ((_wp>>0)&7)
     WHEN 0 THEN 
      IF (_pz.prt_serialno<>_wz.prt_serialno) THEN RETURN 0; END IF;
     WHEN 1 THEN 
      IF (_pz.prt_serialno NOT ILIKE '%'||_wz.prt_serialno||'%') THEN RETURN 0; END IF;
     WHEN 2 THEN 
      IF (_pz.prt_serialno NOT ILIKE _wz.prt_serialno||'%') THEN RETURN 0; END IF;
	 WHEN 3 THEN
      IF (_pz.prt_serialno<>_wz.prt_serialno) THEN 
	   IF (_pz.prt_serialno!='') THEN
	    ---PZ nie jest pusty - nie zgadza sie
	    RETURN 0; 
	   END IF;
	   ---Zgadza sie warunkowo
	   ret=2;
	  END IF;	 
    END CASE;
   ELSE
    ---RAISE NOTICE 'FALSE bo PZ nie ma numeru seryjnego';
    RETURN 0;
   END IF;
  ELSE
   IF (_pz.prt_serialno IS NOT NULL) THEN
    --- RAISE NOTICE 'FALSE bo na PZecie jest numer seryjny';
    RETURN 0;
   END IF;
  END IF;
 END IF;

  ----DATA WAZNOSCI
 IF ((_wp&(1<<14))<>0) THEN
  IF (_wz.prt_datawazn IS NOT NULL) THEN
   IF (_pz.prt_datawazn IS NOT NULL) THEN
    CASE ((_wp>>3)&7)
     WHEN 0 THEN 
      IF NOT (_pz.prt_datawazn=_wz.prt_datawazn) THEN RETURN 0; END IF;
     WHEN 1 THEN 
      IF NOT (_pz.prt_datawazn<_wz.prt_datawazn) THEN RETURN 0; END IF;
     WHEN 2 THEN 
      IF NOT (_pz.prt_datawazn>_wz.prt_datawazn) THEN RETURN 0; END IF;
     WHEN 3 THEN 
      IF NOT (_pz.prt_datawazn<=_wz.prt_datawazn) THEN RETURN 0; END IF;
     WHEN 4 THEN 
      IF NOT (_pz.prt_datawazn>=_wz.prt_datawazn) THEN RETURN 0; END IF;
    END CASE;
   ELSE
    ---RAISE NOTICE 'FALSE bo na PZecie nie ma daty';
    RETURN 0;
   END IF;
  ELSE
   IF (_pz.prt_datawazn IS NOT NULL) THEN
    --- RAISE NOICE 'FALSE bo na PZecie jest data';
    RETURN 0;
   END IF;
  END IF;
 END IF;

 ----Kontrola jakosci na PZecie
 IF (_pz.prt_inkj IS NOT DISTINCT FROM 2) THEN
  ---Na WZecie musi byc explicite zezwolenie na sciaganie KJ
  IF ((_wz.prt_inkj&2) IS DISTINCT FROM 2) THEN
   RETURN 0;
  END IF;
 END IF;

 --Jesli PZet ma KJ i WZet tez ma KJ to sprawdz czy sie lapia 
 IF (_pz.prt_inkj IS NOT NULL) AND (_wz.prt_inkj IS NOT NULL) THEN
  IF ((_wz.prt_inkj&_pz.prt_inkj)=0) THEN
   RETURN 0;
  END IF;
 END IF;
 
 --Sposob pakowania
 IF ((_wp&(1<<30))<>0) THEN --- FV
  --- Jesli WZ wymaga sposobu pakowania musza sie zgodzic
  IF (_pz.rmp_idsposobu IS DISTINCT FROM _wz.rmp_idsposobu) THEN
   RETURN 0;
  END IF;
 END IF;
 
 IF ((_wp&(1<<29))<>0) THEN ---WZ
  ---Preferujemy te rekordy gdzie sie zgadza sposob pakowania
  IF (_pz.rmp_idsposobu IS NOT DISTINCT FROM _wz.rmp_idsposobu) THEN
   ret=max(ret,2);
  END IF;
 END IF;

--- RAISE NOTICE 'RETURN true %',ret;
 RETURN ret;
END
$_$;
