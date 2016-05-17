CREATE FUNCTION ptowar_dodajwz(idtowmag integer, iloscfold numeric, wartosczakupuold numeric, telsprzedazold integer, iloscfnew numeric, telsprzedaznew integer, alwaysusenewvalue numeric DEFAULT NULL::numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
 r RECORD;
 srednia NUMERIC:=0;
 wartosczakupu NUMERIC:=wartosczakupuold;
BEGIN

 IF (iloscfnew<=0) OR (telsprzedaznew!=(-1)) THEN
  IF (iloscfnew<0) THEN
   RAISE EXCEPTION 'Ilosc nie moze byc mniejsza od 0 (jest %)!',iloscfnew;
  END IF;
  RETURN 0;
 END IF;

 IF (alwaysusenewvalue IS NOT NULL) THEN
  wartosczakupu=alwaysusenewvalue;
 END IF;
 
 IF (iloscfold IS NOT DISTINCT FROM iloscfnew) THEN
  RETURN wartosczakupu;
 END IF;

 SELECT ttm_stan,ttm_wartosc INTO r FROM tg_towmag WHERE ttm_idtowmag=idtowmag FOR UPDATE;
 
 IF (iloscfold IS NULL) THEN
  --- Wylicz nowa srednia  
  IF (r.ttm_stan!=0) THEN
   srednia=max(0,round(r.ttm_wartosc/r.ttm_stan,2));
  END IF;
 ELSE
  IF (iloscfold!=0) THEN
   srednia=max(0,round(wartosczakupu/iloscfold,2));
  END IF;
 END IF;
  
 RETURN round(iloscfnew*srednia,2); 
END;
$$;
