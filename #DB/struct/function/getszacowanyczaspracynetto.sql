CREATE FUNCTION getszacowanyczaspracynetto(numeric, integer, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
 DECLARE
 _ilosc ALIAS FOR $1;
 _ob_idobiektu ALIAS FOR $2;
 _kwe_idelemu ALIAS FOR $3;
 wynik NUMERIC=0;
 _rec RECORD;
 _nod RECORD;
BEGIN

 SELECT kwe_idelemu, kwe_flaga, kwe_tpz, kwe_tpj, kwe_iloscosob, kwe_wydajnosc, th_flaga INTO _nod FROM tr_kkwnod JOIN tr_kkwhead USING (kwh_idheadu) WHERE kwe_idelemu=_kwe_idelemu;

 IF (_ob_idobiektu>0 AND _nod.th_flaga&16=0) THEN 
 --liczymy normatyw wedlug normatywu z maszyny na danym etapie technologii, normatyw z technologii
  SELECT ts.* INTO _rec FROM tr_kkwnod AS nod JOIN tr_technostpracy AS ts ON (nod.the_idelem=ts.the_idelem AND ts.ob_idobiektu=_ob_idobiektu) WHERE kwe_idelemu=_kwe_idelemu;
  IF (_rec.tsp_idstanowiska>0) THEN
  ---jest normatyw pod ta maszyne
   IF (_rec.tsp_wydajnosc=0) THEN 
    RETURN 0;
   END IF;
    RAISE NOTICE 'Stanowisko % i % i %',_rec.tsp_tpj,_rec.tsp_wydajnosc,_rec.tsp_tpz;
    wynik=(_ilosc*_rec.tsp_tpj/_rec.tsp_wydajnosc)+_rec.tsp_tpz;
   RETURN Round(wynik,0);
  END IF;
 END IF;

 --liczymy normatyw z czasow ogolnych na nodzie technologii (normatyw ustawiany indywidualnie na nodzie lub normatyw domyslny z momentu tworzenia noda
 IF (_nod.kwe_wydajnosc=0) THEN 
  RETURN 0;
 END IF;

 wynik=(_ilosc*_nod.kwe_tpj/_nod.kwe_wydajnosc)+_nod.kwe_tpz;
 RETURN Round(wynik,0);

END;
$_$;
