CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtransnew ALIAS FOR $1;
 _idelemnew  ALIAS FOR $2;
 _skojarzony ALIAS FOR $3;
 _recminus   ALIAS FOR $4; 
 _rozpismode ALIAS FOR $5;    --- Czy stosowac tryb rozpisania
 r           RECORD;
 flag        INT:=0;
 mask        INT:=0;
 ipkor       NUMERIC;
BEGIN

---- RAISE EXCEPTION 'Skojarzony %',_skojarzony;

 FOR r IN SELECT * FROM (
          SELECT ex.*,
                 COALESCE(ex.tex_skojarzony,ex.tex_idelem) AS idskoj,
		 rank() OVER w AS rr
          FROM tg_teex AS ex 
	  JOIN tg_transelem AS te USING (tel_idelem)
          WHERE (te.tel_skojarzony=_skojarzony OR te.tel_idelem=_skojarzony) AND
	        te.tr_idtrans<>_idtransnew AND
		te.tel_idelem<_idelemnew AND
	        (ex.tex_flaga&(1<<4))=0
	  WINDOW w AS (PARTITION BY COALESCE(ex.tex_skojarzony,ex.tex_idelem) ORDER BY ex.tex_idelem DESC)
	  ORDER BY ex.tex_idelem DESC
	  ) AS i WHERE rr=1
	  ORDER BY i.tex_idelem
 LOOP
  
  ---RAISE EXCEPTION 'Mam rank % ',r.rr;

  IF (_recminus=TRUE) THEN
   flag=flag|(1<<4);
  END IF;
  IF (_recminus=TRUE) OR (_rozpismode=FALSE) THEN
   flag=flag|1;
  ELSE
   flag=flag|2;
  END IF;
  mask=mask|3;

  ipkor=r.tex_iloscf;

  INSERT INTO tg_teex
   (tel_idelem,tex_flaga,
    ttm_idtowmag,tex_iloscpkor,
    tex_iloscf,tex_sprzedaz,
    prt_idpartii,tex_skojarzony,
    tex_nrseryjny,tex_datawaznosci
   )
   VALUES
   (_idelemnew,(r.tex_flaga&(~mask))|flag,
    r.ttm_idtowmag,r.tex_iloscf,
    (CASE WHEN _recminus=TRUE THEN -ipkor ELSE ipkor END),0,
    r.prt_idpartii,r.idskoj,
    r.tex_nrseryjny,r.tex_datawaznosci
   );
 END LOOP;
 
 RETURN TRUE;
END;
$_$;
