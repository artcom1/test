CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _ttw_idtowaru ALIAS FOR $1;
 ret TEXT:='';---''
 r RECORD;
 prevValue NUMERIC:=0;
 currentID INT:=0;
BEGIN

 FOR r IN SELECT tel_idelem,tel_skojarzony,tel_flaga&(1<<16) AS isplus,COALESCE(tel_skojarzony,tel_idelem) AS id,tel_wnettowal,tel_flaga&(1<<17) AS isskoj
          FROM tg_transelem 
	  WHERE tel_newflaga&3<>0 AND ttw_idtowaru=_ttw_idtowaru AND COALESCE(tel_skojarzony,0)>=0 AND tel_newflaga&(1<<27)=0
	  ORDER BY COALESCE(tel_skojarzony,tel_idelem),tel_idelem
 LOOP

  --Rozpoczynamy nowa korekte
  IF (currentID<>r.id) THEN
   currentID=r.id;
   prevValue=r.tel_wnettowal;
  END IF;

  -- Jesli to plusowa to przepisz wartosc
  IF (r.isplus<>0) THEN
   prevValue=r.tel_wnettowal;
  ELSE
   --- Minusowa - sprawdz czy zgadzaja sie wartosci
   IF (r.tel_idelem<>currentID) AND (-r.tel_wnettowal<>prevValue) AND (r.isskoj=0) THEN
    RAISE NOTICE '% % % % ',r.tel_idelem,currentID,-r.tel_wnettowal,prevValue;
    ret=ret||'|'||r.tel_idelem;
   END IF;
  END IF;

 END LOOP;

 RETURN ret;
END;
$_$;
