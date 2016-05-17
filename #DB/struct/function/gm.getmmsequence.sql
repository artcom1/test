CREATE FUNCTION getmmsequence(idruchupz integer, idruchuwzfirst integer DEFAULT NULL::integer) RETURNS SETOF mmsequencetype
    LANGUAGE plpgsql
    AS $$
DECLARE
 r RECORD;
BEGIN
 /*
 gm.mmsequencetype:
   rc_idruchuwzi INT4,         --- ID pierwszego ruchu MM- w sekwencji MMek
   iloscpozmmplus NUMERIC,     --- rc_iloscpoz z ruchu MM+
   iloscmmminus NUMERIC,       --- Ilosc na MMce minusowej jesli jeszcze nie ma plusowej
   rc_idruchuwz INT4,          --- ID ruchu MM- pary MM-/MM+
   rc_idruchupz INT4,          --- ID ruchu MM+ pary MM-/MM+
   iterationno INT4,           --- Numer kolejny iteracji (pierwszy MM- ma 1)
   rc_idruchuwzfrom            --- ID ruchu PZ z ktorego pochodzi ruch MM-
   rc_seqid                    --- Numer sekwencji laczacy ruch MM- z MM+ 
 */
 FOR r IN
  WITH RECURSIVE ri (rc_idruchuwzinit,rc_idruchuwz,rc_idruchupz,iloscpoz,iterationno,wzfrom,seqid) AS (
   SELECT NULL::int,
          NULL::int,
		  pz.rc_idruchu,
		  NULL::numeric,
		  0,
		  NULL::int,
		  NULL::int
   FROM tg_ruchy AS pz WHERE isPZet(pz.rc_flaga) AND pz.rc_idruchu=idruchupz
  UNION
   SELECT COALESCE(ri.rc_idruchuwzinit,(CASE WHEN wz.rc_idruchu=COALESCE(idruchuwzfirst,wz.rc_idruchu) THEN wz.rc_idruchu ELSE NULL END)),
         wz.rc_idruchu,
		 pz.rc_idruchu,
		 COALESCE(pz.rc_iloscpoz,wz.rc_ilosc) AS iloscpoz,
		 ri.iterationno+1,
		 wz.rc_ruch,
		 wz.rc_seqid
   FROM ri 
   JOIN tg_ruchy AS wz ON (wz.rc_ruch=ri.rc_idruchupz AND wz.rc_ruch IS NOT NULL) 
   JOIN tg_transelem AS tewz ON (tewz.tel_idelem=wz.tel_idelem) 
   LEFT OUTER JOIN tg_ruchy AS pz ON (wz.rc_seqid=pz.rc_seqid AND isPZet(pz.rc_flaga)) 
   WHERE isFV(wz.rc_flaga) AND ((pz.rc_idruchu IS NOT NULL) OR (tewz.tel_new2flaga&(1<<10)!=0)) 
  )
  SELECT ri.rc_idruchuwzinit AS rc_idruchuwzi,
         (CASE WHEN ri.rc_idruchupz IS NOT NULL THEN ri.iloscpoz ELSE 0 END) AS iloscpozmmplus,
		 (CASE WHEN ri.rc_idruchupz IS NULL THEN ri.iloscpoz ELSE 0 END) AS iloscmmminus,
		 ri.rc_idruchuwz,
		 ri.rc_idruchupz,
		 ri.iterationno,
		 ri.wzfrom,
		 ri.seqid
		 FROM ri 
		 WHERE ri.rc_idruchuwzinit IS NOT NULL
  LOOP
   RETURN next r;
  END LOOP;  
  
 RETURN;
END;
$$;
