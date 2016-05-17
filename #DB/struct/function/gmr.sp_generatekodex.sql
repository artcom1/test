CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 ret TEXT:='';
 r RECORD;
BEGIN

 FOR r IN SELECT COALESCE(tw.ttw_idxsufix,re.rme_kod) AS kod,e.rmk_przelicznik
          FROM tg_rozmsppakelems AS e
		  LEFT OUTER JOIN tg_towary AS tw ON (tw.ttw_idtowaru=e.ttw_idtowaru_pdx)
		  LEFT OUTER JOIN tg_rozmrodzajeelems AS re ON (re.rme_idelemu=e.rme_idelemu)
		  WHERE e.rmp_idsposobu=_rmp_idsposobu
		  ORDER BY COALESCE(tw.ttw_idxsufix,re.rme_kod)
 LOOP
  ret=ret||','||r.kod||'*'||round(r.rmk_przelicznik,0)::text;
 END LOOP;

 RETURN substring(ret,2);
END;
$$;
