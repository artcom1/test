CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _tabalias    ALIAS FOR $1;
 _pwz         ALIAS FOR $2;
 _whereparams ALIAS FOR $3;
 ret TEXT;
BEGIN

 ret=''; ---''

 IF (_pwz IS NULL) THEN
  RETURN 'AND TRUE=FALSE';
 END IF;

 ret=ret||' AND ('||_tabalias||'.ttw_idtowaru='||_pwz.ttw_idtowaru||')';

 IF (_pwz.prt_wplyw>0) THEN
  IF (_pwz.prt_idpartii IS NOT NULL) THEN
   ret=ret||' AND ('||_tabalias||'.prt_idpartii='||_pwz.prt_idpartii||')';
  ELSE
   ret=ret||' AND (gm.comparePartie('||_tabalias||','||vendo.record2string(_pwz)||','||_whereparams||')=3)';
  END IF;
  return ret;
 END IF;

 ret=ret||' AND ('||_tabalias||'.prt_wplyw=1)';
 
 IF (_pwz.prt_wplyw=-2) THEN
  RETURN ret;
 END IF;

 IF (_pwz.prt_idref IS NOT NULL) THEN
  ret=ret||' AND ('||_tabalias||'.prt_idpartii='||_pwz.prt_idref||')';
  RETURN ret;
 END IF;

 ---------------------------------------------------------------------------------------------
 IF (_pwz.prt_hashcode IS NOT NULL) THEN
  ret=ret||' AND ('||_tabalias||'.prt_hashcode=='''||_pwz.prt_hashcode||'''::uuid)';
 END IF;

 ---------------------------------------------------------------------------------------------
  ----KLIENT
 ---------------------------------------------------------------------------------------------
 IF ((_whereparams&(3<<10))<>0) THEN
  IF (_pwz.k_idklienta IS NULL) THEN
   --NA WZ klient NULL  
   ret=ret||' AND ('||_tabalias||'.k_idklienta IS NULL)';
  ELSE   
   IF ((_whereparams&(1<<15))<>0) THEN
    --Dokladne dopasowanie
    ret=ret||' AND ('||_tabalias||'.k_idklienta IS NOT NULL AND '||_tabalias||'.k_idklienta='||_pwz.k_idklienta||')';   
   ELSE
    ret=ret||' AND ('||_tabalias||'.k_idklienta IS NULL OR '||_tabalias||'.k_idklienta='||_pwz.k_idklienta||')';   
   END IF;
  END IF;
 END IF;

 ---------------------------------------------------------------------------------------------
 ----ZLECENIE
 ---------------------------------------------------------------------------------------------
 IF ((_whereparams&(1<<12))<>0) THEN
  IF (_pwz.zl_idzlecenia IS NULL) THEN
   --NA WZ klient NULL  
   ret=ret||' AND ('||_tabalias||'.zl_idzlecenia IS NULL)';
  ELSE   
   IF ((_whereparams&(1<<16))<>0) THEN
    --Dokladne dopasowanie
    ret=ret||' AND ('||_tabalias||'.zl_idzlecenia IS NOT NULL AND '||_tabalias||'.zl_idzlecenia='||_pwz.zl_idzlecenia||')';   
   ELSE
    ret=ret||' AND ('||_tabalias||'.zl_idzlecenia IS NULL OR '||_tabalias||'.zl_idzlecenia='||_pwz.zl_idzlecenia||')';   
   END IF;
  END IF;
 END IF;

 IF ((_whereparams&(1<<13))<>0) THEN
  IF (_pwz.prt_serialno IS NULL) THEN
   ret=ret||' AND ('||_tabalias||'.prt_serialno IS NULL)';
  ELSE
   ret=ret||' AND ('||_tabalias||'.prt_serialno IS NOT NULL)';   
   CASE ((_whereparams>>0)&7)
    WHEN 0 THEN 
     ret=ret||' AND ('||_tabalias||'.prt_serialno='''||_pwz.prt_serialno||''')';
    WHEN 1 THEN 
     ret=ret||' AND ('||_tabalias||'.prt_serialno ILIKE ''%'||_pwz.prt_serialno||'%'')';
    WHEN 2 THEN 
     ret=ret||' AND ('||_tabalias||'.prt_serialno ILIKE '''||_pwz.prt_serialno||'%'')';
    WHEN 3 THEN 
     ret=ret||' AND ('||_tabalias||'.prt_serialno='''||_pwz.prt_serialno||''' OR '||_tabalias||'.prt_serialno='''')';
   END CASE;
  END IF;
 END IF;

 IF ((_whereparams&(1<<14))<>0) THEN
  IF (_pwz.prt_datawazn IS NULL) THEN
   ret=ret||' AND ('||_tabalias||'.prt_datawazn IS NULL)';
  ELSE
   ret=ret||' AND ('||_tabalias||'.prt_datawazn IS NOT NULL)';   
   CASE ((_whereparams>>3)&7)
    WHEN 0 THEN 
     ret=ret||' AND ('||_tabalias||'.prt_datawazn='''||_pwz.prt_datawazn||''')';
    WHEN 1 THEN 
     ret=ret||' AND ('||_tabalias||'.prt_datawazn<'''||_pwz.prt_datawazn||''')';
    WHEN 2 THEN 
     ret=ret||' AND ('||_tabalias||'.prt_datawazn>'''||_pwz.prt_datawazn||''')';
    WHEN 3 THEN 
     ret=ret||' AND ('||_tabalias||'.prt_datawazn<='''||_pwz.prt_datawazn||''')';
    WHEN 4 THEN 
     ret=ret||' AND ('||_tabalias||'.prt_datawazn>='''||_pwz.prt_datawazn||''')';
    END CASE;
  END IF;
 END IF;
 
 IF ((_pwz.prt_inkj::int&2) IS DISTINCT FROM 2) THEN
  ret=ret||' AND ('||_tabalias||'.prt_inkj IS DISTINCT FROM 2)';
 END IF;
 ret=ret||' AND NOT ('||_tabalias||'.prt_inkj IS NOT NULL AND ('||_tabalias||'.prt_inkj&'||COALESCE(_pwz.prt_inkj,3)||')=0)';
  
 IF ((_whereparams&(1<<30))<>0) THEN
   IF (_pwz.rmp_idsposobu IS NULL) THEN
    return ' AND TRUE=FALSE';
   END IF;
   --- Sposob pakowania musi sie zgadzac
   ret=ret||' AND ('||_tabalias||'.rmp_idsposobu IS NOT DISTINCT FROM '||_pwz.rmp_idsposobu||')';    
 END IF;

 ----RAISE WARNING '%',ret;

 RETURN ret;
END;
$_$;
