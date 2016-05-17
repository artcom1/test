CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 skojarzonyold ALIAS FOR $1;
 skojarzony ALIAS FOR $2;
 skojlogold ALIAS FOR $3;
 skojlog ALIAS FOR $4;
 iloscold ALIAS FOR $5;
 iloscnew ALIAS FOR $6;
 wartoscold ALIAS FOR $7;
 wartoscnew ALIAS FOR $8;
 flaga ALIAS FOR $9;
 deltalo NUMERIC:=0;
 deltal NUMERIC:=0;
 deltalow NUMERIC:=0;
 deltalw NUMERIC:=0;

 deltaso NUMERIC:=0;
 deltas NUMERIC:=0;
 deltasow NUMERIC:=0;
 deltasw NUMERIC:=0;
BEGIN

 IF (TEisOpMagazyn(flaga)) THEN
  
  IF (TEisOpHandel(flaga)) AND (COALESCE(skojlog,0)<>0) THEN
   RAISE EXCEPTION 'Nie mozna wykonac skojarzenia logicznego na dokumencie handlowym';
  END IF;

  --- Jesli skojarzenie logiczne stare bylo nieNULLowe
  IF (COALESCE(skojlogold,0)<>0) THEN
   deltalo=-iloscold;
   deltalow=-wartoscold;
  END IF;

  --- Jesli skojarzenie logiczne nowe jest nieNULLowe
  IF (COALESCE(skojlog,0)<>0) THEN
   deltal=iloscnew;
   deltalw=wartoscnew;
  END IF;

  --- Jesli skojarzenie stare jest nieNULLowe i skojarzenie logiczne stare jest NULLowe
  IF (COALESCE(skojarzonyold,0)<>0) AND (COALESCE(skojlogold,0)=0) THEN
   deltaso=-iloscold;
   deltasow=-wartoscold;
  END IF;

  ---Jesli skojarzenie nowe jest nieNULLowe i skojarzenie logiczne jest NULLowe
  IF (COALESCE(skojarzony,0)<>0) AND (COALESCE(skojlog,0)=0) THEN
   deltas=iloscnew;
   deltasw=wartoscnew;
  END IF;


  ---Jesli stare skojarzenie logiczne jest rowne nowemu
  IF (COALESCE(skojlogold,0)=COALESCE(skojlog,0)) THEN
   deltal=deltal+deltalo;
   deltalw=deltalw+deltalow;
   deltalo=0;
   deltalow=0;
  END IF;


  ---Jesli nowe skojarzenie jest rowne staremu
  IF (COALESCE(skojarzonyold,0)=COALESCE(skojarzony,0)) THEN
   deltas=deltas+deltaso;
   deltasw=deltasw+deltasow;
   deltaso=0;
   deltasow=0;
  END IF;


  IF (deltalo<>0) OR (deltalow<>0) THEN
   UPDATE tg_transelem SET tel_iloscwyd=tel_iloscwyd-deltalo,tel_kosztnabycia=tel_kosztnabycia+deltalow WHERE tel_idelem=skojlogold;
  END IF;


  IF (deltal<>0) OR (deltalw<>0) THEN
   IF (COALESCE(skojlog,0)=COALESCE(skojarzony,0)) THEN
    RAISE EXCEPTION 'Tranelem nie moze byc skojarzony korektowo i logicznie do tego samego tranelemu';
   END IF;
   UPDATE tg_transelem SET tel_iloscwyd=tel_iloscwyd-deltal,tel_kosztnabycia=tel_kosztnabycia+deltalw WHERE tel_idelem=skojlog;
  END IF;

  IF (deltaso<>0) OR (deltasow<>0) THEN
   UPDATE tg_transelem SET tel_iloscwyd=tel_iloscwyd+deltaso,tel_kosztnabycia=tel_kosztnabycia+deltasow WHERE tel_idelem=skojarzonyold AND (NOT TEisOpMagazyn(tel_newflaga) OR (skojlogold=NULL AND NOT TEisOpHandel(tel_newflaga)));
  END IF;

  IF (deltas<>0) OR (deltasw<>0) THEN
   UPDATE tg_transelem SET tel_iloscwyd=tel_iloscwyd+deltas,tel_kosztnabycia=tel_kosztnabycia+deltasw WHERE tel_idelem=skojarzony AND (NOT TEisOpMagazyn(tel_newflaga) OR (skojlog=NULL AND NOT TEisOpHandel(tel_newflaga)));
  END IF;

 END IF;

 RETURN TRUE;
END;
$_$;
