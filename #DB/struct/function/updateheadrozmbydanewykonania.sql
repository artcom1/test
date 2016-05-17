CREATE FUNCTION updateheadrozmbydanewykonania(_kwh_idheadu integer, idx integer, iloscwyk integer, iloscmag integer, iloscmagclose integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN updateHeadRozmByDaneWykonania(_kwh_idheadu, idx, iloscWyk::NUMERIC, iloscMag::NUMERIC, iloscMagClose::NUMERIC);
END;
$$;


--
--

CREATE FUNCTION updateheadrozmbydanewykonania(_kwh_idheadu integer, idx integer, iloscwyk numeric, iloscmag numeric, iloscmagclose numeric) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
 zrobDodawanie   BOOLEAN:=FALSE;
 zrobOdejmowanie BOOLEAN:=FALSE;
 znaleziono      BOOLEAN;
 
 delta_wyk  NUMERIC;
 delta_mag  NUMERIC;
 delta_magc NUMERIC;
 
 il_wyk  NUMERIC;
 il_mag  NUMERIC;
 il_magc NUMERIC;
 
 _rec RECORD;
BEGIN
 
 iloscWyk=NullZero(iloscWyk);
 iloscMag=NullZero(iloscMag);
 iloscMagClose=NullZero(iloscMagClose);
 
 IF (iloscWyk>0 OR iloscMag>0 OR iloscMagClose>0) THEN
  zrobDodawanie=TRUE;
 END IF;
 
 IF (iloscWyk<0 OR iloscMag<0 OR iloscMagClose<0) THEN
  zrobOdejmowanie=TRUE;
 END IF;
   
 --RAISE NOTICE 'zrobDodawanie=% zrobOdejmowanie=%', zrobDodawanie, zrobOdejmowanie;
   
 IF (zrobDodawanie) THEN 
  znaleziono=FALSE; 
  il_wyk=max(iloscWyk,0);
  il_mag=max(iloscMag,0);
  il_magc=max(iloscMagClose,0);
 
  FOR _rec IN
   SELECT 
   lead(kwhr_idelemu) OVER w AS id_next,
   kwhr_idelemu,
   COALESCE(kwhr_ilosciwkart[idx]*kwhr_ilosckart,0) AS ilosc_plan,
   COALESCE(kwhr_iloscwyk_arr[idx],0) AS ilosc_wyk,
   COALESCE(kwhr_iloscwmag_arr[idx],0) AS ilosc_mag,
   COALESCE(kwhr_iloscwmagclosed_arr[idx],0) AS ilosc_magclose
   FROM tr_kkwheadrozm 
   WHERE 
   kwhr_kwh_idheadu=_kwh_idheadu AND
   COALESCE(kwhr_ilosciwkart[idx]*kwhr_ilosckart,0)>0
   WINDOW w AS (ORDER BY kwhr_idelemu ASC)
   ORDER BY kwhr_idelemu ASC
  LOOP  
   IF (_rec.id_next IS NULL) THEN -- Jestem ostatnim rekordem - dodaje wszystko jak leci
    delta_wyk = il_wyk;
    delta_mag = il_mag;
    delta_magc = il_magc;
   ELSE
    delta_wyk  = max((_rec.ilosc_plan-_rec.ilosc_wyk),0);
    delta_mag  = delta_wyk+max((_rec.ilosc_wyk-_rec.ilosc_mag),0);
    delta_magc = delta_mag+max((_rec.ilosc_mag-_rec.ilosc_magclose),0);
 
    delta_wyk = min(il_wyk,delta_wyk);
    delta_mag = min(il_mag,delta_mag);
    delta_magc = min(il_magc,delta_magc);
   END IF;
  
   IF (delta_wyk>0 OR delta_mag>0 OR delta_magc>0) THEN
    UPDATE tr_kkwheadrozm SET 
    kwhr_iloscwyk=COALESCE(kwhr_iloscwyk,0)+delta_wyk,
    kwhr_iloscwyk_arr[idx]=COALESCE(kwhr_iloscwyk_arr[idx],0)+delta_wyk,   
    kwhr_iloscwmag=COALESCE(kwhr_iloscwyk,0)+delta_mag,
    kwhr_iloscwmag_arr[idx]=COALESCE(kwhr_iloscwmag_arr[idx],0)+delta_mag,   
    kwhr_iloscwmagclosed=COALESCE(kwhr_iloscwyk,0)+delta_magc,
    kwhr_iloscwmagclosed_arr[idx]=COALESCE(kwhr_iloscwmagclosed_arr[idx],0)+delta_magc
    WHERE kwhr_idelemu=_rec.kwhr_idelemu;
   
    znaleziono = TRUE;
    il_wyk = max(il_wyk-delta_wyk,0);
    il_mag = max(il_mag-delta_mag,0);
    il_magc = max(il_magc-delta_magc,0);
   END IF;  
  END LOOP;

  IF (znaleziono=FALSE) THEN
   SELECT 
   max(kwhr_idelemu) AS kwhr_idelemu
   INTO _rec
   FROM tr_kkwheadrozm 
   WHERE kwhr_kwh_idheadu=_kwh_idheadu 
   GROUP BY kwhr_kwh_idheadu;
   
   delta_wyk = il_wyk;
   delta_mag = il_mag;
   delta_magc = il_magc;
   
   UPDATE tr_kkwheadrozm SET 
   kwhr_iloscwyk=COALESCE(kwhr_iloscwyk,0)+delta_wyk,
   kwhr_iloscwyk_arr[idx]=COALESCE(kwhr_iloscwyk_arr[idx],0)+delta_wyk,   
   kwhr_iloscwmag=COALESCE(kwhr_iloscwyk,0)+delta_mag,
   kwhr_iloscwmag_arr[idx]=COALESCE(kwhr_iloscwmag_arr[idx],0)+delta_mag,   
   kwhr_iloscwmagclosed=COALESCE(kwhr_iloscwyk,0)+delta_magc,
   kwhr_iloscwmagclosed_arr[idx]=COALESCE(kwhr_iloscwmagclosed_arr[idx],0)+delta_magc
   WHERE kwhr_idelemu=_rec.kwhr_idelemu;    
  END IF;
 END IF; -- Zrob dodawanie
    
 IF (zrobOdejmowanie) THEN   
  il_wyk = min(iloscWyk,0);
  il_mag = min(iloscMag,0);
  il_magc = min(iloscMagClose,0);
 
  FOR _rec IN
   SELECT 
   lead(kwhr_idelemu) OVER w AS id_next,
   kwhr_idelemu,
   COALESCE(kwhr_ilosciwkart[idx]*kwhr_ilosckart,0) AS ilosc_plan,
   COALESCE(kwhr_iloscwyk_arr[idx],0) AS ilosc_wyk,
   COALESCE(kwhr_iloscwmag_arr[idx],0) AS ilosc_mag,
   COALESCE(kwhr_iloscwmagclosed_arr[idx],0) AS ilosc_magclose
   FROM tr_kkwheadrozm 
   WHERE 
   kwhr_kwh_idheadu=_kwh_idheadu AND
   (
    COALESCE(kwhr_ilosciwkart[idx]*kwhr_ilosckart,0)>0 OR 
	COALESCE(kwhr_iloscwyk_arr[idx],0)>0 OR 
	COALESCE(kwhr_iloscwmag_arr[idx],0)>0 OR 
	COALESCE(kwhr_iloscwmagclosed_arr[idx],0)>0
   )
   WINDOW w AS (ORDER BY kwhr_idelemu DESC)
   ORDER BY kwhr_idelemu DESC
  LOOP  
    --RAISE NOTICE 'rec=%, il_wyk=%, il_mag=%, il_magc=%', _rec, il_wyk, il_mag, il_magc;
	
   IF (_rec.id_next IS NULL) THEN -- Jestem ostatnim rekordem - odejmuje wszystko jak leci
    delta_wyk = il_wyk;
    delta_mag = il_mag;
    delta_magc = il_magc;
    --RAISE NOTICE '00. delta_magc=%, delta_mag=%, delta_wyk=%', delta_magc, delta_mag, delta_wyk;
   ELSE   	
    -- maksymalnie moge o tyle zmniejszyc
    delta_magc = _rec.ilosc_magclose;
    delta_mag  = delta_magc+max((_rec.ilosc_mag-_rec.ilosc_magclose),0);
    delta_wyk  = delta_mag+max((_rec.ilosc_wyk-_rec.ilosc_mag),0);	
    --RAISE NOTICE '0. delta_magc=%, delta_mag=%, delta_wyk=%', delta_magc, delta_mag, delta_wyk;
	
	-- robie z tego delte	
    delta_magc = delta_magc*(-1);
    delta_mag  = delta_mag*(-1);
    delta_wyk  = delta_wyk*(-1);
    --RAISE NOTICE '1. delta_magc=%, delta_mag=%, delta_wyk=%', delta_magc, delta_mag, delta_wyk;
 
    delta_wyk = max(il_wyk,delta_wyk);
    delta_mag = max(il_mag,delta_mag);
    delta_magc= max(il_magc,delta_magc);
    --RAISE NOTICE '2. delta_magc=%, delta_mag=%, delta_wyk=%', delta_magc, delta_mag, delta_wyk;
   END IF;
  
   --RAISE NOTICE '3. delta_magc=%, delta_mag=%, delta_wyk=%', delta_magc, delta_mag, delta_wyk;
   IF (delta_wyk<0 OR delta_mag<0 OR delta_magc<0) THEN
    --RAISE NOTICE '4. delta_magc=%, delta_mag=%, delta_wyk=%', delta_magc, delta_mag, delta_wyk;
    UPDATE tr_kkwheadrozm SET 
    kwhr_iloscwyk=COALESCE(kwhr_iloscwyk,0)+delta_wyk,
    kwhr_iloscwyk_arr[idx]=COALESCE(kwhr_iloscwyk_arr[idx],0)+delta_wyk,   
    kwhr_iloscwmag=COALESCE(kwhr_iloscwyk,0)+delta_mag,
    kwhr_iloscwmag_arr[idx]=COALESCE(kwhr_iloscwmag_arr[idx],0)+delta_mag,   
    kwhr_iloscwmagclosed=COALESCE(kwhr_iloscwyk,0)+delta_magc,
    kwhr_iloscwmagclosed_arr[idx]=COALESCE(kwhr_iloscwmagclosed_arr[idx],0)+delta_magc
    WHERE kwhr_idelemu=_rec.kwhr_idelemu;
   
    il_wyk=min(il_wyk-delta_wyk,0);
    il_mag=min(il_mag-delta_mag,0);
    il_magc=min(il_magc-delta_magc,0);
   END IF;  
   
   --RAISE NOTICE '5. delta_magc=%, delta_mag=%, delta_wyk=%', delta_magc, delta_mag, delta_wyk;
  END LOOP;
 END IF; -- Zrob odejmowanie
 
 RETURN 1;
END;
$$;
